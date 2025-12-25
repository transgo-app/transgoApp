import 'dart:async';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';
import '../controllers/dashboard_controller.dart';
import 'filter_bottomsheet.dart';

class SearchCard extends StatefulWidget {
  final DashboardController controller;
  const SearchCard({super.key, required this.controller});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
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

                              if (_debounce?.isActive ?? false) {
                                _debounce!.cancel();
                              }
                              _debounce = Timer(
                                  const Duration(milliseconds: 500), () {
                                controller.getList();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) =>
                          FilterBottomSheet(controller: controller),
                    );
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: solidPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.filter_list, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() {
              List filteredKategori = [];

              if (controller.role.value == "customer") {
                filteredKategori = controller.kategori
                    .where((cat) =>
                        cat['id'] == 'car' || cat['id'] == 'motorcycle')
                    .toList();
              } else if (controller.role.value == "product_customer") {
                filteredKategori = controller.kategori
                    .where((cat) =>
                        cat['id'] == 'iphone' ||
                        cat['id'] == 'camera' ||
                        cat['id'] == 'outdoor' ||
                        cat['id'] == 'starlink')
                    .toList();
              } else {
                filteredKategori = controller.kategori;
              }

              // Sync TabController length jika berbeda
              if (controller.tabController.length != filteredKategori.length) {
                controller.tabController.dispose();
                controller.tabController = TabController(
                    length: filteredKategori.length, vsync: controller);
              }

              return TabBar(
                controller: controller.tabController,
                isScrollable: true,
                labelColor: solidPrimary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: solidPrimary,
                tabs: filteredKategori
                    .map((cat) => Tab(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/${cat['id']}.png',
                                scale: 3,
                              ),
                              const SizedBox(width: 5),
                              gabaritoText(
                                text: cat['name'] ?? '',
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                onTap: (index) async {
                  controller.selectedKategori.value =
                      filteredKategori[index]['id'] ?? '';
                  controller.selectedLokasiKendaraan.value = '';
                  controller.teksLokasi.value = 'Harap tunggu...';
                  controller.teksCari.value = 'Harap tunggu...';

                  await controller.getKotaKendaraan();
                  controller.getList();
                },
              );
            }),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
