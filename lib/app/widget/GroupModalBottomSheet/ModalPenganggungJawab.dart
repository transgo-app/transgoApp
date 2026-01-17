
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/modules/detailriwayat/controllers/detailriwayat_controller.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ParentModal.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ModalPenanggungJawab extends StatefulWidget {
  const ModalPenanggungJawab({super.key});

  @override
  State<ModalPenanggungJawab> createState() => _ModalPenanggungJawabState();
}

class _ModalPenanggungJawabState extends State<ModalPenanggungJawab> {
  bool _isLoadingLinks = true;
  String _serahTerimaLink = WhatsAppLinksService.fallbackSerahTerimaLink;
  String _pusatBantuanLink = WhatsAppLinksService.fallbackPusatBantuanLink;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchLinks();
  }

  Future<void> _fetchLinks() async {
    try {
      final links = await WhatsAppLinksService.fetchLinks();
      setState(() {
        _serahTerimaLink = links['serahTerima'] ?? WhatsAppLinksService.fallbackSerahTerimaLink;
        _pusatBantuanLink = links['pusatBantuan'] ?? WhatsAppLinksService.fallbackPusatBantuanLink;
        _isLoadingLinks = false;
      });
    } catch (e) {
      print('Error fetching WhatsApp links: $e');
      setState(() {
        _hasError = true;
        _isLoadingLinks = false;
        // Use fallback links
        _serahTerimaLink = WhatsAppLinksService.fallbackSerahTerimaLink;
        _pusatBantuanLink = WhatsAppLinksService.fallbackPusatBantuanLink;
      });
      // Show error message but still allow using fallback links
      CustomSnackbar.show(
        title: "Perhatian",
        message: "Tidak dapat memperbarui link grup. Menggunakan link default.",
        icon: Icons.info_outline,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailriwayatController>();
    return BottomSheetComponent(
      widget: Obx(() => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gabaritoText(text: "Penganggung Jawab Antar & Ambil", fontSize: 18, textColor: textHeadline,),
        const SizedBox(height: 5,),
        gabaritoText(text: 'Butuh konfirmasi soal pengambilan atau pengembalian? Hubungi tim Transgo yang bertanggung jawab di sini, ya!', textColor: textPrimary, fontSize: 14,),
        BackgroundCard(
          height: 50,
          marginVertical: 20,
          body: Row(
          children: [
            Expanded(child: GestureDetector(
              onTap: () {
                controller.activePenanggungJawabTab.value = 1;
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                color: controller.activePenanggungJawabTab.value == 1 ? primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: gabaritoText(text: "Antar", textColor: controller.activePenanggungJawabTab.value == 1 ? Colors.white : Colors.black,))),
            )),
              const SizedBox(width: 5,),
             Expanded(child: GestureDetector(
              onTap: () {
                controller.activePenanggungJawabTab.value = 2;
              },
               child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                color: controller.activePenanggungJawabTab.value == 2 ? primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: gabaritoText(text: "Ambil", textColor: controller.activePenanggungJawabTab.value == 2 ? Colors.white : Colors.black,))),
             )),
          ],
        )),
        if(controller.dataArguments['start_request']['driver'] != null && controller.dataArguments['end_request']['driver'] != null )
        BackgroundCard(
          ontap: () {
            if(controller.activePenanggungJawabTab.value == 1){
              launchUrl(Uri.parse('https://wa.me/${controller.dataArguments['start_request']['driver']['phone_number']}'));
            }else{
              launchUrl(Uri.parse('https://wa.me/${controller.dataArguments['end_request']['driver']['phone_number']}'));
            }
          },
          height: 30,
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(IconsaxPlusBold.call),
              const SizedBox(width: 10,),
              Flexible(child: gabaritoText(text:  '${controller.activePenanggungJawabTab.value == 1 ? '${controller.dataArguments['start_request']['driver']['name']}' : "${controller.dataArguments['end_request']['driver']['name']}"}'))
            ],
          )),
          if(controller.dataArguments['start_request']['driver'] == null && controller.dataArguments['end_request']['driver'] == null )
           BackgroundCard(
            height: 30,
            body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(IconsaxPlusBold.call),
                const SizedBox(width: 10,),
                Expanded(
                  child: gabaritoText(
                    textAlign: TextAlign.center,
                    text:  'Penganggung jawab kendaraan belum ditambahkan, harap menunggu pesanan dikonfirmasi oleh pihak transgo')),
              ],
            )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider()),
            ReusableButton(
            bgColor: Colors.white,
            borderSideColor: Colors.grey,
            height: 45,
            widget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/wa_green.png', scale: 20,),
                const SizedBox(width: 10,),
                Expanded(child: Center(child: poppinsText(text: "Masuk Ke Group Serah Terima", textColor: Colors.black)))
              ],
            ),
            ontap: () {
              launchUrl(Uri.parse(_serahTerimaLink));
            },
          ),
          const SizedBox(height: 10,),
           ReusableButton(
            bgColor: Colors.white,
            height: 45,
            borderSideColor: Colors.grey,
            widget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/wa_green.png', scale: 20,),
                const SizedBox(width: 10,),
                Expanded(child: Center(child: poppinsText(text: "Masuk Ke Group Pusat Bantuan", textColor: Colors.black,)))
              ],
            ),
            ontap: () {
              launchUrl(Uri.parse(_pusatBantuanLink));
            },
          ),
          const SizedBox(height: 20,),
      ],
    ),));
  }
}