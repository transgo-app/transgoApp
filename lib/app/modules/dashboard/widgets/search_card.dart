import 'dart:async';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';
import '../controllers/dashboard_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ParentModal.dart';

class SearchCard extends StatefulWidget {
  final DashboardController controller;

  const SearchCard({
    super.key,
    required this.controller,
  });

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Transform.translate(
      offset: const Offset(0, -100),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearch(controller),
              const SizedBox(height: 16),
              _buildLokasi(controller),
              const SizedBox(height: 16),
              _buildTanggal(context, controller),
              const SizedBox(height: 16),
              _buildWaktu(context, controller),
              const SizedBox(height: 16),
              _buildDurasi(controller),
              const SizedBox(height: 20),
              _buildKategoriTab(controller),
              const SizedBox(height: 24),
              _buildSubmit(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearch(DashboardController controller) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari kendaraan...',
              ),
              onChanged: (value) {
                controller.searchQuery.value = value;
                _debounce?.cancel();
                _debounce = Timer(
                  const Duration(milliseconds: 500),
                  controller.getList,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLokasi(DashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const gabaritoText(
          text: "Lokasi",
          fontSize: 14,
        ),
        const SizedBox(height: 6),
        Obx(
          () => CustomDropdown(
            hintText: controller.teksLokasi.value,
            items: controller.dataKota,
            selectedValue: controller.selectedLokasiKendaraan.value,
            onChanged: (value) {
              controller.selectedLokasiKendaraan.value = value ?? '';
              controller.checkDataWhenHaveList();
            },
            dropdownColor: Colors.white,
            icon: const Icon(Icons.location_on, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildTanggal(
    BuildContext context,
    DashboardController controller,
  ) {
    return GestureDetector(
      onTap: () => _openDatePicker(context, controller),
      child: Obx(
        () => _SelectBox(
          label: 'Tanggal',
          value: controller.pickedDate.value.isEmpty
              ? 'Pilih Tanggal'
              : formatTanggalIndonesia(controller.pickedDate.value),
          icon: Icons.calendar_month,
        ),
      ),
    );
  }

  Widget _buildWaktu(
    BuildContext context,
    DashboardController controller,
  ) {
    return GestureDetector(
      onTap: () => _openTimePicker(context, controller),
      child: Obx(
        () => _SelectBox(
          label: 'Waktu',
          value: controller.pickedTime.value.isEmpty
              ? 'Pilih Waktu'
              : controller.pickedTime.value,
          icon: Icons.access_time,
        ),
      ),
    );
  }

  Widget _buildDurasi(DashboardController controller) {
    return Obx(
      () => DurationDropdown(
        key: ValueKey(
          '${controller.pickedDate.value}_${controller.pickedTime.value}',
        ),
        startDate: convertDateFormat(controller.pickedDate.value),
        time: controller.pickedTime.value,
        onSelectionChanged: (option) {
          controller.selectedDurasiSewa.value = option.days.toString();
        },
      ),
    );
  }

  Widget _buildKategoriTab(DashboardController controller) {
    return Obx(() {
      final filtered = _filteredKategori(controller);

      if (controller.tabController.length != filtered.length) {
        controller.tabController.dispose();
        controller.tabController = TabController(
          length: filtered.length,
          vsync: controller,
        );
      }

      return TabBar(
        controller: controller.tabController,
        isScrollable: true,
        labelColor: solidPrimary,
        unselectedLabelColor: Colors.grey,
        indicatorColor: solidPrimary,
        tabs: filtered.map((cat) {
          return Tab(
            child: Row(
              children: [
                Image.asset('assets/${cat['id']}.png', scale: 3),
                const SizedBox(width: 6),
                gabaritoText(text: cat['name'], fontSize: 14),
              ],
            ),
          );
        }).toList(),
        onTap: (index) async {
          controller.selectedKategori.value = filtered[index]['id'] ?? '';
          controller.teksLokasi.value = 'Harap tunggu...';
          controller.teksCari.value = 'Harap tunggu...';
          await controller.getKotaKendaraan();
          controller.getList();
        },
      );
    });
  }

  Widget _buildSubmit(DashboardController controller) {
    return ReusableButton(
      bgColor: solidPrimary,
      height: 50,
      ontap: controller.getList,
      widget: const gabaritoText(
        text: 'Terapkan',
        fontSize: 14,
        textColor: Colors.white,
      ),
    );
  }

  List _filteredKategori(DashboardController controller) {
    if (controller.role.value == 'customer') {
      return controller.kategori
          .where((e) => e['id'] == 'car' || e['id'] == 'motorcycle')
          .toList();
    }

    if (controller.role.value == 'product_customer') {
      return controller.kategori
          .where((e) =>
              e['id'] == 'iphone' ||
              e['id'] == 'camera' ||
              e['id'] == 'outdoor' ||
              e['id'] == 'starlink')
          .toList();
    }

    return controller.kategori;
  }

void _openDatePicker(
  BuildContext context,
  DashboardController controller,
) {
  showDialog(
    context: context,
    builder: (_) {
      DateTime now = DateTime.now();
      DateTime initialDate = controller.pickedDate.value.isNotEmpty
          ? DateTime.tryParse(controller.pickedDate.value) ?? now
          : now;

      DateTime minDate = DateTime(now.year, now.month, now.day, 0);
      if (now.hour >= 22) {
        minDate = now.add(const Duration(days: 1));
      }

      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 420,
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: SfDateRangePicker(
              backgroundColor: Colors.white,
              selectionMode: DateRangePickerSelectionMode.single,
              initialSelectedDate: initialDate,
              initialDisplayDate: initialDate,
              minDate: minDate,
              selectionColor: Colors.blue,
              todayHighlightColor: Colors.blue,
              headerStyle: const DateRangePickerHeaderStyle(
                backgroundColor: Colors.transparent,
              ),
              allowViewNavigation: false,
              showNavigationArrow: true,
              onSelectionChanged:
                  (DateRangePickerSelectionChangedArgs args) {
                if (args.value is DateTime) {
                  controller.pickedDate.value =
                      args.value.toIso8601String().split('T').first;
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ),
      );
    },
  );
}


  void _openTimePicker(
    BuildContext context,
    DashboardController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _BottomTimePicker(controller: controller),
    );
  }
}

class _SelectBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SelectBox({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gabaritoText(text: label, fontSize: 14),
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              gabaritoText(text: value),
              Icon(icon),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomTimePicker extends StatefulWidget {
  final DashboardController controller;
  const _BottomTimePicker({required this.controller});

  @override
  State<_BottomTimePicker> createState() => _BottomTimePickerState();
}

class _BottomTimePickerState extends State<_BottomTimePicker> {
  static const int minHourLimit = 7;
  static const int maxHourLimit = 23;

  late int hour;
  late int minute;
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late DateTime minTime;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    DateTime pickedDate = widget.controller.pickedDate.value.isNotEmpty
        ? DateTime.tryParse(widget.controller.pickedDate.value) ?? now
        : now;

    minTime = (pickedDate.year == now.year &&
            pickedDate.month == now.month &&
            pickedDate.day == now.day)
        ? now.add(const Duration(minutes: 120))
        : DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day, minHourLimit);

    if (minTime.hour < minHourLimit) {
      minTime = DateTime(
        minTime.year,
        minTime.month,
        minTime.day,
        minHourLimit,
      );
    }

    if (minTime.hour > maxHourLimit) {
      minTime = DateTime(
        minTime.year,
        minTime.month,
        minTime.day,
        maxHourLimit,
      );
    }

    if (widget.controller.pickedTime.value.isEmpty) {
      hour = minTime.hour;
      minute = 0;
    } else {
      try {
        hour = int.parse(widget.controller.pickedTime.value.split(":")[0]);
        minute = int.parse(widget.controller.pickedTime.value.split(":")[1]);

        if (hour < minTime.hour) {
          hour = minTime.hour;
          minute = 0;
        }
        if (hour > maxHourLimit) {
          hour = maxHourLimit;
          minute = 0;
        }
      } catch (_) {
        hour = minTime.hour;
        minute = 0;
      }
    }

    int hourIndex = (hour - minTime.hour).clamp(0, maxHourLimit - minTime.hour);
    int minuteIndex = minute.clamp(0, 59);

    hourController = FixedExtentScrollController(initialItem: hourIndex);
    minuteController = FixedExtentScrollController(initialItem: minuteIndex);
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int startHour = minTime.hour;
    final int availableHours = (maxHourLimit - startHour + 1).clamp(0, 24);

    return BottomSheetComponent(
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          gabaritoText(
            text: "Pilih Waktu",
            fontSize: 20,
            fontWeight: FontWeight.w600,
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
                      childCount: availableHours,
                      builder: (_, index) {
                        int h = startHour + index;
                        return Center(
                          child: Text(h.toString().padLeft(2, '0')),
                        );
                      },
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        hour = startHour + index;
                      });
                    },
                  ),
                ),
                const Text(
                  ":",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    controller: minuteController,
                    itemExtent: 40,
                    physics: const FixedExtentScrollPhysics(),
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 60,
                      builder: (_, index) {
                        return Center(
                          child: Text(index.toString().padLeft(2, '0')),
                        );
                      },
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        minute = index;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ReusableButton(
            bgColor: Colors.blue,
            height: 50,
            ontap: () {
              widget.controller.pickedTime.value =
                  "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
              Navigator.pop(context);
            },
            widget: gabaritoText(
              text: "Pilih",
              fontSize: 16,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
