import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/modules/detailriwayat/controllers/detailriwayat_controller.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ParentModal.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class ModalBatalkanSewa extends StatelessWidget {
  const ModalBatalkanSewa({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailriwayatController>();
    final fleet = controller.detailKendaraan['fleet'];
    final product = controller.detailKendaraan['product'];
    final totalPrice = controller.detailKendaraan['grand_total'] ?? 0;
    final insurance = controller.detaiItemsID['insurance'];

    final isVehicle = fleet != null;
    final itemName = isVehicle ? fleet['name'] : product?['name'] ?? '-';

    return BottomSheetComponent(
      widget: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gabaritoText(text: "Batalkan Sewa", fontSize: 18),
              const SizedBox(height: 10),
              detailBatalkanSewa(isVehicle ? "Kendaraan" : "Produk", itemName),
              if (isVehicle)
                detailBatalkanSewa(
                  "Keterangan Sewa",
                  controller.detaiItemsID['is_with_driver'] == false
                      ? "Lepas Kunci"
                      : "Dengan Driver",
                ),
              if (isVehicle)
                detailBatalkanSewa(
                  "Pemakaian",
                  controller.detaiItemsID['is_out_of_town'] == false
                      ? "Dalam Kota"
                      : "Luar Kota",
                ),
              detailBatalkanSewa(
                "Tanggal Ambil",
                formatTanggalNew(controller.detaiItemsID['start_date']),
              ),
              detailBatalkanSewa(
                "Tanggal Kembali",
                formatTanggalNew(controller.detaiItemsID['end_date']),
              ),
              if ((controller.detaiItemsID['addons'] ?? []).isNotEmpty)
                detailBatalkanSewa(
                  "Addon",
                  (controller.detaiItemsID['addons'] as List)
                      .map((e) =>
                          "${e['name']} (+Rp${formatRupiah("${e['price']}")})")
                      .join(", "),
                ),
              if (insurance != null)
                detailBatalkanSewa(
                  "Asuransi",
                  "${insurance['name']} (+Rp${formatRupiah("${insurance['price']}")})",
                ),
              detailBatalkanSewa("Total Harga", "Rp ${formatRupiah(totalPrice.toString())}"),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Checkbox(
                        activeColor: primaryColor,
                        value: controller.menyetujuiPembatalan.value,
                        onChanged: (value) {
                          controller.menyetujuiPembatalan.value = value ?? false;
                        },
                      )),
                  Expanded(
                    child: gabaritoText(
                      text:
                          'Saya udah paham dan setuju buat batalkan sewa ini.',
                      textColor: textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ReusableButton(
                ontap: () {
                  if (!controller.menyetujuiPembatalan.value) {
                    CustomSnackbar.show(
                      title: "Terjadi Kesalahan",
                      message:
                          "Anda perlu menyetujui checkbox terlebih dahulu sebelum melanjutkan.",
                    );
                  } else {
                    Get.back();
                    Get.dialog(KonfirmasiAcction());
                  }
                },
                bgColor:primaryColor,
                borderSideColor:primaryColor,
                textColor: Colors.white,
                title: "Batalkan",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget detailBatalkanSewa(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gabaritoText(text: title, textColor: textSecondary),
          gabaritoText(text: value, textColor: textHeadline, fontSize: 16),
        ],
      ),
    );
  }
}
