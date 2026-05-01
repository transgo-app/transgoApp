import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class HargaWidget extends StatelessWidget {
  final DetailitemsController controller;

  const HargaWidget({super.key, required this.controller});

  DateTime _parseOrNow(String? value, [DateTime? fallback]) {
    if (value == null) return fallback ?? DateTime.now();
    try {
      final dt = DateTime.tryParse(value);
      return dt ?? fallback ?? DateTime.now();
    } catch (_) {
      return fallback ?? DateTime.now();
    }
  }

  int _normalizeDurasi(int raw) => raw <= 0 ? 1 : raw;

  @override
  Widget build(BuildContext context) {
    // Access non-observable dataClient outside Obx
    final startStr = controller.dataClient?['startDate'] as String?;
    final endStr = controller.dataClient?['endDate'] as String?;

    DateTime startDate = _parseOrNow(startStr).toLocal();
    DateTime endDate =
        _parseOrNow(endStr, startDate.add(const Duration(days: 1))).toLocal();

    if (endDate.isBefore(startDate)) {
      endDate = startDate.add(const Duration(days: 1));
    }

    int durasiRaw = endDate.difference(startDate).inDays;
    final durasi = _normalizeDurasi(durasiRaw);

    // Only wrap observable parts in Obx
    return Obx(() {
      controller.updateTotalHarga();

      final dynamic product = controller.detailData['product'];
      final int hargaOriginal = controller.isKendaraan
          ? (controller.detailData['rent_price'] ?? 0)
          : ((product is Map)
              ? (product['price_after_discount'] ?? product['price'] ?? 0)
              : 0);

      final int hargaOriginalTotal = hargaOriginal * durasi;
      final int diskon = hargaOriginalTotal - controller.totalHarga.value;

      // Use hybrid high season: rental crosses high season → end 23:59 last day
      final isHighSeason = controller.rentalCrossesHighSeason.value;
      String dateRangeText;
      
      if (isHighSeason) {
        // Per-date calculation: show full period with end time at 23:59
        final endDateForDisplay = startDate.add(Duration(days: durasi - 1));
        final endTime = DateTime(endDateForDisplay.year, endDateForDisplay.month, 
            endDateForDisplay.day, 23, 59);
        dateRangeText = "${DateFormat('dd MMM yyyy HH:mm').format(startDate)} - ${DateFormat('dd MMM yyyy HH:mm').format(endTime)}";
      } else {
        // Per-day calculation: show start date/time only (end calculated as 24h later)
        final tanggalText = DateFormat('dd MMM yyyy').format(startDate);
        final waktuText = DateFormat('HH:mm').format(startDate);
        dateRangeText = "$tanggalText $waktuText";
      }

      return GestureDetector(
        onTap: () => _showCustomPopup(context),
        child: Card(
          color: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Rp ${NumberFormat.decimalPattern('id').format(controller.totalHarga.value)}",
                          style: gabaritoTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (diskon > 0)
                          Text(
                            "Rp ${NumberFormat.decimalPattern('id').format(hargaOriginalTotal)}",
                            style: gabaritoTextStyle.copyWith(
                              fontSize: 14,
                              color: Colors.white70,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      "/$durasi Hari",
                      style: gabaritoTextStyle.copyWith(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                if (controller.isKendaraan)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      "Penyewaan di hari libur maka akan dikenakan biaya",
                      style: gabaritoTextStyle.copyWith(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                const Divider(color: Colors.white70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(IconsaxPlusBold.calendar,
                              color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              dateRangeText,
                              style: gabaritoTextStyle.copyWith(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              maxLines: isHighSeason ? 2 : 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isHighSeason)
                      const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _openTimePicker(
    BuildContext context,
    VoidCallback refreshPopup,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return _BottomTimePickerHarga(
          controller: controller,
          onPicked: (hour, minute) async {
            final startStr = controller.dataClient['startDate'];
            DateTime base = _parseOrNow(startStr).toLocal();

            final updated = DateTime(
              base.year,
              base.month,
              base.day,
              hour,
              minute,
            );

            controller.dataClient['startDate'] = updated.toIso8601String();
            controller.dataClient['date'] = updated.toIso8601String();

            await controller.checkChargeSettings();

            controller.updateTotalHarga();
            refreshPopup();
            await controller.getDetailAPI(false);
          },
        );
      },
    );
  }

  void _showCustomPopup(BuildContext context) {
    DateTime startDate =
        _parseOrNow(controller.dataClient['startDate']).toLocal();
    DateTime endDate = _parseOrNow(controller.dataClient['endDate'],
            startDate.add(const Duration(days: 1)))
        .toLocal();

    if (endDate.isBefore(startDate)) {
      endDate = startDate.add(const Duration(days: 1));
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SfDateRangePicker(
                    backgroundColor: Colors.white,
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange: PickerDateRange(startDate, endDate),
                    minDate: DateTime.now(),
                    maxDate: DateTime.now().add(const Duration(days: 365)),
                    startRangeSelectionColor: solidPrimary,
                    endRangeSelectionColor: solidPrimary,
                    rangeSelectionColor: solidPrimary.withOpacity(0.2),
                    selectionColor: solidPrimary,
                    todayHighlightColor: solidPrimary,
                    showNavigationArrow: true,
                    headerStyle: const DateRangePickerHeaderStyle(
                      backgroundColor: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                    onSelectionChanged: (args) async {
                      if (args.value is PickerDateRange) {
                        final range = args.value as PickerDateRange;
                        final s = range.startDate;
                        final e = range.endDate;

                        if (s != null) {
                          controller.dataClient['startDate'] =
                              s.toIso8601String();
                          controller.dataClient['endDate'] =
                              (e ?? s.add(const Duration(days: 1)))
                                  .toIso8601String();
                        }

                        final start =
                            _parseOrNow(controller.dataClient['startDate']);
                        final end = _parseOrNow(
                            controller.dataClient['endDate'],
                            start.add(const Duration(days: 1)));

                        final durasi =
                            _normalizeDurasi(end.difference(start).inDays);

                        controller.selectedDurasi.value = durasi;
                        controller.dataClient['duration'] = durasi.toString();
                        controller.dataClient['date'] = start.toIso8601String();

                        await controller.checkChargeSettings();
                        controller.updateTotalHarga();
                        await controller.getDetailAPI(false);
                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Waktu Mulai"),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: solidPrimary),
                        onPressed: () =>
                            _openTimePicker(context, () => setState(() {})),
                        child: Text(
                          DateFormat('HH:mm').format(
                              _parseOrNow(controller.dataClient['startDate'])
                                  .toLocal()),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: solidPrimary),
                    onPressed: () async {
                      controller.updateTotalHarga();
                      await controller.getDetailAPI(false);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Pilih",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomTimePickerHarga extends StatefulWidget {
  final DetailitemsController controller;
  final void Function(int hour, int minute) onPicked;

  const _BottomTimePickerHarga({
    required this.controller,
    required this.onPicked,
  });

  @override
  State<_BottomTimePickerHarga> createState() => _BottomTimePickerHargaState();
}

class _BottomTimePickerHargaState extends State<_BottomTimePickerHarga> {
  final List<int> availableHours = [0, 1, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23];

  late int hour;
  late int minute;

  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;

  @override
  void initState() {
    super.initState();

    final base =
        DateTime.tryParse(widget.controller.dataClient['startDate'] ?? '') ??
            DateTime.now();

    hour = base.hour;
    minute = base.minute;

    // If initial hour is in the forbidden range (2-6), snap to 7
    if (hour >= 2 && hour < 7) {
      hour = 7;
    }

    // If hour is 1, minute must be 0
    if (hour == 1 && minute > 0) {
      minute = 0;
    }

    // Find index of the hour in availableHours
    int initialHourIndex = availableHours.indexOf(hour);
    if (initialHourIndex == -1) {
      // Fallback if not found (shouldn't happen with the logic above)
      initialHourIndex = availableHours.indexOf(7);
      hour = 7;
    }

    hourController = FixedExtentScrollController(initialItem: initialHourIndex);
    minuteController = FixedExtentScrollController(initialItem: minute);
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Pilih Waktu",
            style: gabaritoTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: Row(
              children: [
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    controller: hourController,
                    itemExtent: 40,
                    physics: const FixedExtentScrollPhysics(),
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: availableHours.length,
                      builder: (_, index) {
                        final h = availableHours[index];
                        return Center(
                          child: Text(
                            h.toString().padLeft(2, '0'),
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      },
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        hour = availableHours[index];
                        // If hour is 1, force minute to 0
                        if (hour == 1 && minute > 0) {
                          minute = 0;
                          minuteController.jumpToItem(0);
                        }
                      });
                    },
                  ),
                ),
                const Text(":", style: TextStyle(fontSize: 26)),
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    controller: minuteController,
                    itemExtent: 40,
                    physics: const FixedExtentScrollPhysics(),
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 60,
                      builder: (_, index) {
                        return Center(
                          child: Text(
                            index.toString().padLeft(2, '0'),
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      },
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        // If hour is 1, only allow minute 0
                        if (hour == 1) {
                          minute = 0;
                          minuteController.jumpToItem(0);
                        } else {
                          minute = index;
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: solidPrimary,
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: () {
              widget.onPicked(hour, minute);
              Navigator.pop(context);
            },
            child: const Text(
              "Pilih",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
