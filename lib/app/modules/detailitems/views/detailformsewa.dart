import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../controllers/detailitems_controller.dart';
import '../../../widget/widgets.dart';
import '../../../data/data.dart';
import '../widgets/formsewa/detailsewa_utils.dart';
import '../widgets/formsewa/section_map.dart';
import '../widgets/formsewa/section_pemakaian.dart';
import '../widgets/formsewa/section_lokasi.dart';
import '../widgets/formsewa/section_asuransi.dart';
import '../widgets/formsewa/bottom_estimation.dart';
import '../widgets/formsewa/harga_widget.dart';
import '../../../widget/Card/BackgroundCard.dart';
import '../widgets/formsewa/addons_produk.dart';
import '../widgets/formsewa/section_voucher.dart';
import '../widgets/formsewa/section_supir.dart';

class DetailFormSewa extends GetView<DetailitemsController> {
  const DetailFormSewa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(IconsaxPlusBold.arrow_left_1, size: 33),
        ),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: gabaritoText(
          text: "Form Sewa",
          fontSize: 16,
          textColor: textHeadline,
        ),
      ),
      body: Obx(() {
        if (controller.isLoadinggetdetailkendaraan.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.detailData;
        final isKendaraan = controller.isKendaraan;
        final item = isKendaraan ? data['fleet'] : data['product'] ?? {};
        final foto = item['photo']?['photo'] ??
            ((item['photos'] != null &&
                    item['photos'] is List &&
                    item['photos'].isNotEmpty)
                ? item['photos'][0]['photo']
                : '');
        final name = item['name'] ?? '-';
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                foto,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    Container(color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                gabaritoText(
                                  text: name,
                                  textColor: textHeadline,
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(height: 5),
                                iconWithDetailSewa(
                                  IconsaxPlusBold.calendar_edit,
                                  formatTanggalSewa(
                                    controller.dataClient['date'],
                                    int.tryParse(
                                            "${controller.dataClient['duration']}") ??
                                        0,
                                  ),
                                ),
                                if (controller.isKendaraan)
                                  Obx(() => iconWithDetailSewa(
                                        IconsaxPlusBold.user_tag,
                                        controller.isWithDriver.value
                                            ? "Dengan Supir"
                                            : "Tanpa Supir",
                                      )),
                                if (isKendaraan)
                                  iconWithDetailSewa(
                                    IconsaxPlusBold.color_swatch,
                                    "${item['color'] ?? '-'}",
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      HargaWidget(controller: controller),
                      AddonsListView(controller: controller),
                      if (controller.isKendaraan)
                        DriverOption(controller: controller),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          gabaritoText(
                            text: isKendaraan
                                ? "Lokasi Kendaraan"
                                : "Lokasi Produk",
                          ),
                          SectionMaps(controller: controller),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(),
                          ),
                          if (isKendaraan) ...[
                            gabaritoText(text: "Pemakaian"),
                            gabaritoText(
                              text:
                                  "Kalau kamu pakai kendaraannya ke luar kota, ada biaya tambahan harian.",
                              fontSize: 13,
                              textColor: textPrimary,
                            ),
                            SectionPemakaian(controller: controller),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(),
                            ),
                          ],
                        ],
                      ),
                      SectionLokasi(controller: controller),
                      SectionVoucher(controller: controller),
                      SectionAsuransi(controller: controller),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(),
                      ),
                      BackgroundCard(
                        stringHexBG: "#FAFAFA",
                        body: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gabaritoText(
                              text: controller.isKendaraan
                                  ? "Permintaan Khusus"
                                  : "Tujuan pemakaian dan permintaan khusus",
                            ),
                            gabaritoText(
                              text: controller.isKendaraan
                                  ? "Tulis kebutuhan sewa kamu di sini."
                                  : "Harap masukkan tujuan pemakaian dan permintaan khusus yang relevan. Informasi ini bersifat wajib untuk melanjutkan proses sewa.",
                              textColor: textPrimary,
                              fontSize: 13,
                            ),
                            const SizedBox(height: 10),
                            reusableTextField(
                              title: controller.isKendaraan
                                  ? 'Tuliskan permintaan khususmu disini'
                                  : 'Tuliskan tujuan pemakaian dan permintaan khusus',
                              maxLines: 3,
                              controller: controller.deskripsiPermintaanKhusus,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
            BottomEstimation(controller: controller),
          ],
        );
      }),
    );
  }
}
