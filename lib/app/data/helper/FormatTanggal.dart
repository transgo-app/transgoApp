
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

String formatTanggalIndonesia(String isoDate) {
  try {
    tzData.initializeTimeZones();
    final jakarta = tz.getLocation('Asia/Jakarta');
    final dateUtc = DateTime.parse(isoDate).toUtc();

    final dateJakarta = tz.TZDateTime.from(dateUtc, jakarta);

    return DateFormat('dd MMMM yyyy', 'id_ID').format(dateJakarta);
  } catch (e) {
    return isoDate;
  }
}

String formatTanggalSewa(String isoDate, int duration, {bool isHighSeason = false}) {
  final startUtc = DateTime.parse(isoDate);
  final jakarta = tz.getLocation('Asia/Jakarta');
  final start = tz.TZDateTime.from(startUtc, jakarta);

  final formatter = DateFormat("dd/MM/yyyy HH:mm");
  
  if (isHighSeason) {
    // Per-date calculation: end at 23:59 of the last calendar date
    // Duration includes the start date, so if duration = 3, it's start date + 2 more days
    // Example: Start Monday 05:00, duration 3 → ends Wednesday 23:59
    final endDate = start.add(Duration(days: duration - 1));
    final end = tz.TZDateTime(
      jakarta,
      endDate.year,
      endDate.month,
      endDate.day,
      23,
      59,
    );
    
    return "${formatter.format(start)} - ${formatter.format(end)}";
  } else {
    // Per-day calculation: 24 hours from start time
    final end = start.add(Duration(days: duration));
    return "${formatter.format(start)} - ${formatter.format(end)}";
  }
}

String formatTanggalNew(String isoDate) {
  final startUtc = DateTime.parse(isoDate);
  final jakarta = tz.getLocation('Asia/Jakarta');
  final start = tz.TZDateTime.from(startUtc, jakarta);

  final formatter = DateFormat("dd/MM/yyyy HH:mm");
  return "${formatter.format(start)}";
}

String formatTanggalNew2(String isoDate) {
  final startUtc = DateTime.parse(isoDate);
  final jakarta = tz.getLocation('Asia/Jakarta');
  final start = tz.TZDateTime.from(startUtc, jakarta);

  final formatter = DateFormat("dd/MM/yyyy");
  return "${formatter.format(start)}";
}

/// Returns true if rental period [startDate, startDate + duration - 1] overlaps
/// any high season range. Used for riwayat/detail riwayat display.
/// [calendarRanges] is the list from order-calculation-settings (calendar_dates_ranges).
/// [categoryType] is 'car' or 'motorcycle' (only these use high season in the app).
bool rentalPeriodCrossesHighSeason(
  String startDateStr,
  int duration,
  String? categoryType,
  List<dynamic>? calendarRanges,
) {
  if (calendarRanges == null || calendarRanges.isEmpty || duration <= 0) return false;
  if (categoryType != 'car' && categoryType != 'motorcycle') return false;
  final start = DateTime.tryParse(startDateStr);
  if (start == null) return false;
  final startLocal = start.toLocal();
  for (var range in calendarRanges) {
    final fleets = range['fleets'] as List?;
    if (fleets == null || fleets.isEmpty || !fleets.contains(categoryType)) continue;
    final startDateStrR = range['start_date'] as String?;
    final endDateStrR = range['end_date'] as String?;
    if (startDateStrR == null || endDateStrR == null) continue;
    final startMatch = RegExp(r'(\d{4})-(\d{2})-(\d{2})').firstMatch(startDateStrR);
    final endMatch = RegExp(r'(\d{4})-(\d{2})-(\d{2})').firstMatch(endDateStrR);
    if (startMatch == null || endMatch == null) continue;
    final rangeStart = int.parse(startMatch.group(1)!) * 10000 +
        int.parse(startMatch.group(2)!) * 100 +
        int.parse(startMatch.group(3)!);
    final rangeEnd = int.parse(endMatch.group(1)!) * 10000 +
        int.parse(endMatch.group(2)!) * 100 +
        int.parse(endMatch.group(3)!);
    for (int i = 0; i < duration; i++) {
      final d = startLocal.add(Duration(days: i));
      final dayVal = d.year * 10000 + d.month * 100 + d.day;
      if (dayVal >= rangeStart && dayVal <= rangeEnd) return true;
    }
  }
  return false;
}

String convertDateFormat(String dateStr) {
  if (dateStr.isEmpty) return '';
  
  List<String> parts = dateStr.split('-');
  if (parts.length == 3) {
    return "${parts[2]}/${parts[1]}/${parts[0]}";
  }
  return dateStr;
}

String formatTanggalJamIndonesia(String isoDate) {
  try {
    tzData.initializeTimeZones();
    final jakarta = tz.getLocation('Asia/Jakarta');
    final dateUtc = DateTime.parse(isoDate).toUtc();

    final dateJakarta = tz.TZDateTime.from(dateUtc, jakarta);

    return DateFormat('dd MMMM yyyy HH:mm', 'id_ID').format(dateJakarta);
  } catch (e) {
    return isoDate;
  }
}