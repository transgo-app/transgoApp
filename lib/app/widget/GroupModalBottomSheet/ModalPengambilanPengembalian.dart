import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/modules/detailitems/controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ParentModal.dart';
import 'package:transgomobileapp/app/widget/address_autocomplete_field.dart';
import 'package:transgomobileapp/app/widget/saved_address_picker_sheet.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';
import 'package:transgomobileapp/app/routes/app_pages.dart';

class ModalPengambilanPengembalianKendaraan extends StatelessWidget {
  final String labelTitle;
  final String tempatAsal;
  final TextEditingController controllerView;
  final bool isPengambilan;

  ModalPengambilanPengembalianKendaraan({
    super.key,
    required this.labelTitle,
    required this.tempatAsal,
    required this.controllerView,
    this.isPengambilan = true,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailitemsController>();
    final ctx = context;
    return BottomSheetComponent(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gabaritoText(
            text: "$labelTitle",
            fontSize: 18,
          ),
          const SizedBox(height: 20),
          BackgroundCard(
            height: 50,
            body: Row(
              children: [
                Expanded(child: gabaritoText(text: '$tempatAsal')),
                Obx(() => Radio(
                      activeColor: primaryColor,
                      value: controller.detailData['item']['location'],
                      groupValue: isPengambilan
                          ? controller.selectedPengambilan.value
                          : controller.selectedPengembalian.value,
                      onChanged: (value) {
                        if (isPengambilan) {
                          controller.selectedPengambilan.value = value!;
                          controller.pengambilanSendiri.value = true;
                          controller.clearStartDeliveryCoords();
                          controller.clearEndDeliveryCoords();
                          controller.detailLokasiPengambilan.value =
                              controller.detailData['item']['location'];

                          // Update otomatis pengembalian
                          controller.selectedPengembalian.value =
                              controller.selectedPengambilan.value;
                          controller.detailLokasiPengembalian.value =
                              controller.detailLokasiPengambilan.value;
                          controller.lokasiPengembalianC.text =
                              controller.lokasiPengambilanC.text;
                          controller.pengembalianSendiri.value =
                              controller.pengambilanSendiri.value;
                        } else {
                          controller.selectedPengembalian.value = value!;
                          controller.pengembalianSendiri.value = true;
                          controller.clearEndDeliveryCoords();
                          controller.detailLokasiPengembalian.value =
                              controller.detailData['item']['location'];
                        }
                        controller.getDetailAPI(false);
                      },
                    )),
              ],
            ),
          ),
          const SizedBox(height: 20),
          BackgroundCard(
            height: 50,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: gabaritoText(
                        text: isPengambilan
                            ? "Langsung kami antar ke tempatmu"
                            : "Langsung kami jemput ke tempatmu",
                        fontSize: 16,
                      ),
                    ),
                    Obx(() => Radio(
                          activeColor: primaryColor,
                          value: "Diantar Ke Lokasi Kamu",
                          groupValue: isPengambilan
                              ? controller.selectedPengambilan.value
                              : controller.selectedPengembalian.value,
                          onChanged: (value) {
                            if (isPengambilan) {
                              controller.selectedPengambilan.value = value!;
                              controller.pengambilanSendiri.value = false;

                              // Update otomatis pengembalian
                              controller.selectedPengembalian.value =
                                  controller.selectedPengambilan.value;
                              controller.detailLokasiPengembalian.value =
                                  controller.detailLokasiPengambilan.value;
                              controller.lokasiPengembalianC.text =
                                  controller.lokasiPengambilanC.text;
                              controller.pengembalianSendiri.value =
                                  controller.pengambilanSendiri.value;
                            } else {
                              controller.selectedPengembalian.value = value!;
                              controller.pengembalianSendiri.value = false;
                            }
                            controller.getDetailAPI(false);
                          },
                        )),
                  ],
                ),
                AddressAutocompleteField(
                  controller: controllerView,
                  onResolvedCoords: (lat, lng) {
                    if (isPengambilan) {
                      controller.setStartDeliveryCoords(lat, lng);
                    } else {
                      controller.setEndDeliveryCoords(lat, lng);
                    }
                    controller.getDetailAPI(false);
                  },
                  onClearCoords: () {
                    if (isPengambilan) {
                      controller.clearStartDeliveryCoords();
                    } else {
                      controller.clearEndDeliveryCoords();
                    }
                  },
                ),
                if (controller.isLoggedIn)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Obx(() {
                      if (controller.isLoadingAddresses.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }

                      if (controller.savedAddresses.isEmpty) {
                        return Container(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => Get.toNamed(Routes.SAVED_ADDRESSES),
                            icon: const Icon(Icons.add_location_alt_outlined, size: 18),
                            label: gabaritoText(
                              text: "Tambah Alamat Baru",
                              fontSize: 14,
                              textColor: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        );
                      }

                      // Find main address or first address
                      final mainAddr = controller.savedAddresses.firstWhere(
                        (a) => a['is_default'] == true,
                        orElse: () => controller.savedAddresses.first,
                      );

                      final label = mainAddr['label']?.toString() ?? 'Alamat';
                      final address = mainAddr['address']?.toString() ?? '-';
                      final isDefault = mainAddr['is_default'] == true;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          gabaritoText(
                            text: "PAKAI ALAMAT TERSIMPAN",
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            textColor: Colors.blueGrey[300],
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => showCustomerSavedAddressPicker(
                              ctx,
                              isPengambilan: isPengambilan,
                              textController: controllerView,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      border: Border.all(color: Colors.grey[100]!),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      label.toLowerCase().contains('kantor') 
                                          ? Icons.business_outlined 
                                          : label.toLowerCase().contains('rumah') 
                                              ? Icons.home_outlined 
                                              : Icons.location_on_outlined,
                                      color: primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            gabaritoText(
                                              text: label,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            if (isDefault) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: const Text(
                                                  'UTAMA',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          address,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: gabaritoText(
                    text: controller.isLoggedIn
                        ? "*Pilih saran alamat agar biaya antar/jemput terhitung otomatis"
                        : "*Login untuk saran alamat & estimasi biaya layanan",
                    textColor: textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          ReusableButton(
            height: 60,
            ontap: () {
              if (isPengambilan && !controller.pengambilanSendiri.value) {
                controller.detailLokasiPengambilan.value = controllerView.text;
              } else if (!isPengambilan && !controller.pengembalianSendiri.value) {
                controller.detailLokasiPengembalian.value = controllerView.text;
              } else if (isPengambilan && controller.pengambilanSendiri.value) {
                controller.detailLokasiPengambilan.value =
                    controller.detailData['item']['location'];
              } else if (!isPengambilan && controller.pengembalianSendiri.value) {
                controller.detailLokasiPengembalian.value =
                    controller.detailData['item']['location'];
              }

              // Update otomatis pengembalian saat pengambilan
              if (isPengambilan) {
                controller.selectedPengembalian.value =
                    controller.selectedPengambilan.value;
                controller.detailLokasiPengembalian.value =
                    controller.detailLokasiPengambilan.value;
                controller.lokasiPengembalianC.text =
                    controller.lokasiPengambilanC.text;
                controller.pengembalianSendiri.value =
                    controller.pengambilanSendiri.value;
              }

              controller.getDetailAPI(false);
              Get.back();
            },
            title: "Simpan Lokasi",
            bgColor: primaryColor,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ReusableButton(
              height: 60,
              textColor: textHeadline,
              ontap: () {
                Get.back();
              },
              title: "Batal",
              bgColor: Colors.white,
              borderSideColor: Colors.grey[400],
            ),
          )
        ],
      ),
    );
  }
}
