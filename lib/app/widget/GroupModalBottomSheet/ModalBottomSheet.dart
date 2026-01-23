import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/modules/detailitems/controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/widget/Dialog/DialogBerhailSewa.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ModalDaftarAccount.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';
import 'package:flutter/gestures.dart';
import '../../data/theme.dart';


class RincianOrderModal extends StatelessWidget {
  final bool? isWithButton;
  const RincianOrderModal({super.key, this.isWithButton = true});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailitemsController>();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: gabaritoText(text: "Rincian Harga", fontSize: 18),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      Column(
                        children: [
                          if (controller.isKendaraan &&
                              controller.isWithDriver.value)
                            detailRincianHarga(
                              "Dengan Driver",
                              "Rp. ${formatRupiah(controller.detailData['total_driver_price'] ?? 0)}",
                            ),
                        ],
                      ),

                      if (controller.isKendaraan)
                        detailRincianHarga(
                            "Pemakaian\n${controller.detailData['out_of_town_price'] == 0 ? "Dalam Kota" : "Luar Kota"}",
                            "Rp. ${formatRupiah(controller.detailData['out_of_town_price'])}"),
                      if (controller.isKendaraan)
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Divider()),

                      // --- Item utama (kendaraan atau produk) ---
                      gabaritoText(
                          text: controller.isKendaraan ? "Kendaraan" : "Produk",
                          textColor: textSecondary),
                      detailRincianHarga(
                          "${controller.detailData['item']['name']}" +
                              (controller.isKendaraan ? " / Hari" : ""),
                          'Rp ${formatRupiah(controller.isKendaraan ? controller.detailData['item']['price'] : controller.detailData['item']['price_after_discount'] ?? controller.detailData['item']['price'])}'),

                      detailRincianHarga(
                          "${controller.dataClient['duration']} Hari",
                          'Rp. ${formatRupiah(controller.detailData['total_rent_price'])}'),

                      if (controller.detailData['weekend_days'] != null &&
                          controller.detailData['weekend_days'].length > 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            detailRincianHarga(
                              "${controller.detailData['weekend_days'].length} Hari Weekend",
                              "Rp ${formatRupiah(controller.detailData['total_weekend_price'])}",
                            ),
                          ],
                        ),
                      detailRincianHarga(
                          "Diskon (${controller.detailData['discount_percentage']}%)",
                          '-Rp ${formatRupiah(controller.detailData['discount'])}'),
                      (controller.detailData['applied_voucher_code'] != null &&
                              (controller.detailData['applied_voucher_code']
                                  .toString()
                                  .trim()
                                  .isNotEmpty))
                          ? detailRincianHarga(
                              "Voucher (${controller.detailData['applied_voucher_code']})",
                              '-Rp ${formatRupiah((controller.detailData['voucher_discount'] ?? 0).abs())}',
                            )
                          : const SizedBox.shrink(),
                      
                      // High Season Charge (D-1 only)
                      Obx(() {
                        final alert = controller.currentChargeAlert.value;
                        if (alert != null && alert['type'] == 'd1') {
                          final chargeAmount = controller.getHighSeasonChargeAmount();
                          if (chargeAmount > 0) {
                            final chargePercent = alert['chargePercent'] ?? 0;
                            return detailRincianHarga(
                              "High Season Charge ($chargePercent%)",
                              "Rp ${formatRupiah(chargeAmount)}",
                            );
                          }
                        }
                        return const SizedBox.shrink();
                      }),

                      if (controller.selectedAddons.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(),
                            ),
                            gabaritoText(
                                text: "Addons", textColor: textSecondary),
                            ...controller.selectedAddons.map((addon) =>
                                detailRincianHarga(
                                    "${addon['name']} x ${addon['quantity']}",
                                    "Rp ${formatRupiah(addon['price'] * (addon['quantity'] ?? 1))}")),
                          ],
                        ),

                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider()),
                      if (controller.isKendaraan)
                        gabaritoText(
                            text: "Asuransi", textColor: textSecondary),
                      if (controller.isKendaraan)
                        detailRincianHarga(
                          (controller.detailData.containsKey('insurance') &&
                                  controller.detailData['insurance'] != null)
                              ? "${controller.detailData['insurance']['name']}"
                              : "Tidak Ada",
                          (controller.detailData.containsKey('insurance') &&
                                  controller.detailData['insurance'] != null)
                              ? 'Rp ${formatRupiah(controller.detailData['insurance']['price'])}'
                              : 'Rp 0',
                        ),
                      if (controller.isKendaraan)
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Divider()),
                      // TG Pay Balance Checkbox
                      Obx(() {
                        final grandTotal = controller.detailData['grand_total'] ?? 0;
                        final balance = controller.tgPayBalance.value;
                        final useBalance = controller.useTgPayBalance.value;
                        final isSufficient = balance >= grandTotal;
                        final balanceUsed = balance > grandTotal ? grandTotal : balance;
                        final remaining = grandTotal - balanceUsed;
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.useTgPayBalance.value = !controller.useTgPayBalance.value;
                              },
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: useBalance
                                      ? primaryColor.withOpacity(0.1)
                                      : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: useBalance
                                        ? primaryColor
                                        : Colors.grey.shade300,
                                    width: useBalance ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      activeColor: primaryColor,
                                      value: useBalance,
                                      onChanged: (value) {
                                        controller.useTgPayBalance.value = value ?? false;
                                      },
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: gabaritoText(
                                                  text: 'Gunakan Saldo Transgo Pay',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  textColor: textHeadline,
                                                ),
                                              ),
                                              if (useBalance)
                                                gabaritoText(
                                                  text: 'Rp ${formatRupiah(balanceUsed.toInt())}',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  textColor: primaryColor,
                                                ),
                                            ],
                                          ),
                                          if (useBalance) ...[
                                            SizedBox(height: 8),
                                            gabaritoText(
                                              text: isSufficient
                                                  ? 'Saldo cukup, order akan langsung lunas'
                                                  : 'Saldo akan digunakan Rp ${formatRupiah(balanceUsed.toInt())}, sisa tagihan Rp ${formatRupiah(remaining.toInt())} akan dibayar melalui payment gateway',
                                              fontSize: 12,
                                              textColor: isSufficient ? Colors.green.shade700 : Colors.orange.shade700,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        );
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: gabaritoText(
                                  text: "Estimasi Biaya",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18)),
                          const SizedBox(width: 20),
                          gabaritoText(
                              text:
                                  "Rp. ${formatRupiah(controller.detailData['grand_total'])}",
                              textColor: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // --- Button ---
                      if (isWithButton == true)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Obx(() => InkWell(
                                    onTap: () {
                                      controller.menyetujuiSnK.value =
                                          !controller.menyetujuiSnK.value;
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                          activeColor: primaryColor,
                                          value: controller.menyetujuiSnK.value,
                                          onChanged: (value) {
                                            controller.menyetujuiSnK.value =
                                                value ?? false;
                                          },
                                        ),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                              children: [
                                                const TextSpan(
                                                  text:
                                                      'Saya telah menyetujui ',
                                                ),
                                                TextSpan(
                                                  text: 'S&K dari TransGo',
                                                  style: TextStyle(
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.w600,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          Get.toNamed(
                                                              '/syaratdanketentuan');
                                                        },
                                                ),
                                                const TextSpan(
                                                  text:
                                                      ' dan data yang saya input telah benar sepenuhnya.',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            ReusableButton(
                              ontap: () {
                                if (!controller.menyetujuiSnK.value) {
                                  return CustomSnackbar.show(
                                      title: "Terjadi Kesalahan",
                                      message:
                                          "Silahkan setujui dahulu syarat & ketentuan transgo");
                                }
                                if (GlobalVariables.token.value == '') {
                                  Get.back();
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) =>
                                        Wrap(children: [ModalDaftarAkun()]),
                                  );
                                } else {
                                  if (controller.menyetujuiSnK.value) {
                                    controller
                                        .getDetailAPI(true, true)
                                        .then((value) {
                                      if (value == 200) {
                                        Get.dialog(
                                            barrierDismissible: false,
                                            PopScope(
                                                canPop: false,
                                                child: DialogBerhasilSewa()));
                                      }
                                    });
                                  }
                                }
                              },
                              bgColor: primaryColor,
                              title: "Sewa Sekarang",
                            ),
                            const SizedBox(height: 10),
                            ReusableButton(
                              ontap: () {
                                Get.back();
                              },
                              bgColor: Colors.white,
                              borderSideColor: Colors.grey,
                              title: "Tutup Rincian",
                              textColor: textPrimary,
                            )
                          ],
                        ),
                      if (isWithButton == false) SizedBox(height: 30)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -40,
          right: 16,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.close, size: 18, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget detailRincianHarga(String title, String subtile) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: gabaritoText(text: title, fontWeight: FontWeight.w500)),
          const SizedBox(width: 20),
          gabaritoText(
              text: subtile,
              textColor: textPrimary,
              fontWeight: FontWeight.w600)
        ],
      ),
    );
  }
}
