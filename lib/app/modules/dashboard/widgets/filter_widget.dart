import 'package:flutter/material.dart';
import '../../../data/data.dart';
import '../../../data/intended_use_options.dart';
import '../../../widget/widgets.dart';
import '../controllers/dashboard_controller.dart';

class FilterWidget extends StatelessWidget {
  final DashboardController controller;

  const FilterWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Check if it's a vehicle category
      bool isVehicle = controller.selectedKategori.value == 'car' ||
          controller.selectedKategori.value == 'motorcycle';

      // Only show filter widget after user clicks "Terapkan" (when results are shown)
      if (!isVehicle || !controller.showDataMobil.value) {
        return const SizedBox.shrink();
      }

      return Transform.translate(
          offset: const Offset(0, -70),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.isFilterExpanded.value =
                        !controller.isFilterExpanded.value;
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.filter_list, color: Colors.black87),
                          const SizedBox(width: 8),
                          gabaritoText(
                            text: 'Filter',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      Icon(
                        controller.isFilterExpanded.value
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),
                if (controller.isFilterExpanded.value) ...[
                  const SizedBox(height: 20),
                  _buildFilterCari(controller),
                  const SizedBox(height: 16),
                  _buildTujuanPemakaian(controller),
                  const SizedBox(height: 16),
                  _buildFilterHarga(controller),
                  const SizedBox(height: 16),
                  _buildFilterMerk(controller),
                  const SizedBox(height: 16),
                  _buildFilterTier(controller),
                  const SizedBox(height: 20),
                  _buildApplyFilterButton(controller),
                ],
              ],
            ),
          ),
        );
    });
  }

  Widget _buildApplyFilterButton(DashboardController controller) {
    return ReusableButton(
      bgColor: solidPrimary,
      height: 50,
      ontap: () async {
        // Reset pagination and apply filters
        print('Applying filters - Brand: ${controller.selectedBrand.value}, Tier: ${controller.selectedTier.value}');
        // Force clear lists and reset pagination
        controller.isLoading.value = true;
        controller.listKendaraan.clear();
        controller.listProduk.clear();
        controller.hasMore.value = true;
        // Reset currentPage before calling getList
        controller.currentPage = 1;
        // Call getList which will apply filters
        await controller.getList();
      },
      widget: const gabaritoText(
        text: 'Terapkan Filter',
        fontSize: 14,
        textColor: Colors.white,
      ),
    );
  }

  /// Rekomendasi pintar header (matches web `fleet-recommendation.tsx`) + `intended_use` chips.
  Widget _buildTujuanPemakaian(DashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, size: 14, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                'Rekomendasi Pintar',
                style: gabaritoTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Pilih Kendaraan Favoritmu',
          style: gabaritoTextStyle.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade900,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final cat = controller.selectedKategori.value;
          if (cat != 'car' && cat != 'motorcycle') {
            return const SizedBox.shrink();
          }
          final use = controller.searchIntendedUse.value;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _intentFilterChip(controller, use, '', 'Semua'),
                ...kIntendedUseSearchOptions.map(
                  (o) => _intentFilterChip(controller, use, o.value, o.label),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _intentFilterChip(
    DashboardController controller,
    String current,
    String value,
    String label,
  ) {
    final selected =
        value.isEmpty ? current.isEmpty : current == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 4),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
        selected: selected,
        showCheckmark: true,
        checkmarkColor: Colors.white,
        selectedColor: primaryColor,
        backgroundColor: Colors.grey.shade100,
        side: BorderSide(
          color: selected ? primaryColor : Colors.grey.shade400,
        ),
        onSelected: (_) async {
          controller.searchIntendedUse.value = value;
          if (controller.showDataMobil.value &&
              (controller.selectedKategori.value == 'car' ||
                  controller.selectedKategori.value == 'motorcycle')) {
            await controller.fetchRecommendations();
          }
        },
      ),
    );
  }

  Widget _buildFilterCari(DashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const gabaritoText(
          text: "Cari",
          fontSize: 14,
        ),
        const SizedBox(height: 6),
        Container(
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
                    hintText: 'Nama kendaraan...',
                  ),
                  onChanged: (value) {
                    controller.searchQuery.value = value;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterHarga(DashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const gabaritoText(
          text: "Harga",
          fontSize: 14,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    const Text('Rp', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Min (Rp)',
                        ),
                        onChanged: (value) {
                          controller.minPrice.value = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    const Text('Rp', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Max (Rp)',
                        ),
                        onChanged: (value) {
                          controller.maxPrice.value = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterMerk(DashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const gabaritoText(
          text: "Merk",
          fontSize: 14,
        ),
        const SizedBox(height: 6),
        Obx(
          () {
            // Build items list with "Semua Merk" option
            List<Map<String, dynamic>> items = [
              {'id': 'all', 'name': 'Semua Merk'},
              ...controller.availableBrands,
            ];
            
            // Convert selectedBrand to display value (use 'all' if empty)
            String displayValue = controller.selectedBrand.value.isEmpty 
                ? 'all' 
                : controller.selectedBrand.value;
            
            return CustomDropdown(
              hintText: "Semua Merk",
              items: items,
              selectedValue: displayValue,
              onChanged: (value) {
                // Convert 'all' back to empty string for API
                final brandValue = (value == 'all' || value == null) ? '' : value;
                controller.selectedBrand.value = brandValue;
                print('Selected brand value: $brandValue');
                print('Available brands: ${controller.availableBrands}');
              },
              dropdownColor: Colors.white,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFilterTier(DashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const gabaritoText(
          text: "Tier",
          fontSize: 14,
        ),
        const SizedBox(height: 6),
        Obx(
          () {
            // Build items list with "Semua Tier" option
            List<Map<String, dynamic>> items = [
              {'id': 'all', 'name': 'Semua Tier'},
              ...controller.availableTiers.map((tier) => {
                    'id': tier,
                    'name': tier,
                  }),
            ];
            
            // Convert selectedTier to display value (use 'all' if empty)
            String displayValue = controller.selectedTier.value.isEmpty 
                ? 'all' 
                : controller.selectedTier.value;
            
            return CustomDropdown(
              hintText: "Semua Tier",
              items: items,
              selectedValue: displayValue,
              onChanged: (value) {
                // Convert 'all' back to empty string for API
                controller.selectedTier.value = (value == 'all' || value == null) ? '' : value;
              },
              dropdownColor: Colors.white,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            );
          },
        ),
      ],
    );
  }
}
