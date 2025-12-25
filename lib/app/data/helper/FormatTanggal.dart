
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

String formatTanggalSewa(String isoDate, int duration) {
  final startUtc = DateTime.parse(isoDate);
  final jakarta = tz.getLocation('Asia/Jakarta');
  final start = tz.TZDateTime.from(startUtc, jakarta);

  final end = start.add(Duration(days: duration));

  final formatter = DateFormat("dd/MM/yyyy HH:mm");
  return "${formatter.format(start)} - ${formatter.format(end)}";
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