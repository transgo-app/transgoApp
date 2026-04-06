import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/modules/detailitems/controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ParentModal.dart';
import 'package:transgomobileapp/app/widget/address_autocomplete_field.dart';
import 'package:transgomobileapp/app/widget/saved_address_picker_sheet.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => showCustomerSavedAddressPicker(
                          ctx,
                          isPengambilan: isPengambilan,
                          textController: controllerView,
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey[400]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 14,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: primaryColor,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Pilih alamat tersimpan',
                                style: gabaritoTextStyle.copyWith(
                                  fontSize: 14,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
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
