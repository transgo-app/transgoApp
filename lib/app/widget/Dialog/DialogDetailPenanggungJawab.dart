
import 'package:transgomobileapp/app/modules/detailriwayat/controllers/detailriwayat_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/data.dart';
import '../widgets.dart';
import '../Button/buttons.dart';

class DialogPenanggungJawab extends StatefulWidget {
  const DialogPenanggungJawab({super.key});

  @override
  State<DialogPenanggungJawab> createState() => _DialogPenanggungJawabState();
}

class _DialogPenanggungJawabState extends State<DialogPenanggungJawab> {
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
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15,),
            poppinsText(text: "Penanggung Jawab Transgo\nuntuk Unit Anda", fontSize: 13, fontWeight: FontWeight.w600, textAlign: TextAlign.center,),
            const SizedBox(height: 15,),
            const SizedBox(height: 10,),
            RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              text: "Anda bisa menghubungi Penanggung Jawab Transgo untuk mengonfirmasi serah terima pengambilan / pengembalian pada hari sewa pertamamu",
              style: poppinsTextStyle.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: "Sesuai jadwal yang ditentukan ya!",
                  style: poppinsTextStyle.copyWith(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50,),
          if(controller.dataArguments['start_request']['driver']['name'] != controller.dataArguments['end_request']['driver']['name'] && 
          controller.dataArguments['start_request']['driver']['phone_number'] != controller.dataArguments['end_request']['driver']['phone_number'])
          ReusableButton(
            bgColor: Colors.green,
            height: 50,
            widget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/wa_white.png', scale: 20,),
                const SizedBox(width: 10,),
                Expanded(child: poppinsText(text: "Kontak via WhatsApp '${controller.dataArguments['start_request']['driver']['name']}' Untuk Pengantaran", textColor: Colors.white, fontWeight: FontWeight.w600,))
              ],
            ),
            ontap: () {
              launchUrl(Uri.parse('https://wa.me/${controller.dataArguments['start_request']['driver']['phone_number']}'));
            },
          ),
          if(controller.dataArguments['start_request']['driver']['name'] != controller.dataArguments['end_request']['driver']['name'] && 
          controller.dataArguments['start_request']['driver']['phone_number'] != controller.dataArguments['end_request']['driver']['phone_number'])
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ReusableButton(
              bgColor: Colors.green,
              height: 45,
              widget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/wa_white.png', scale: 20,),
                  const SizedBox(width: 10,),
                  Expanded(child: poppinsText(text: "Kontak via WhatsApp '${controller.dataArguments['end_request']['driver']['name']}' Untuk Pengembalian", textColor: Colors.white, fontWeight: FontWeight.w600,))
                ],
              ),
              ontap: () {
              launchUrl(Uri.parse('https://wa.me/${controller.dataArguments['end_request']['driver']['phone_number']}'));
              },
            ),
          ),
          if(controller.dataArguments['start_request']['driver']['name'] == controller.dataArguments['end_request']['driver']['name'] && 
          controller.dataArguments['start_request']['driver']['phone_number'] == controller.dataArguments['end_request']['driver']['phone_number'])
           Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ReusableButton(
              bgColor: Colors.green,
              height: 45,
              widget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/wa_white.png', scale: 20,),
                  const SizedBox(width: 10,),
                  Expanded(child: poppinsText(text: "Kontak via WhatsApp '${controller.dataArguments['start_request']['driver']['name']}' Untuk Pengantaran dan Pengembalian", textColor: Colors.white, fontWeight: FontWeight.w600,))
                ],
              ),
              ontap: () {
              launchUrl(Uri.parse('https://wa.me/${controller.dataArguments['start_request']['driver']['phone_number']}'));
              },
            ),
          ),
           Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(children: <Widget>[
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: poppinsText(text: "Atau", fontSize: 12, fontWeight: FontWeight.w600,)),
              Expanded(child: Divider()),
            ]),
          ),
          ReusableButton(
            bgColor: Colors.white,
            borderSideColor: Colors.grey,
            height: 45,
            widget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/wa_green.png', scale: 20,),
                const SizedBox(width: 10,),
                Expanded(child: poppinsText(text: "Masuk Ke Group Serah Terima", textColor: Colors.black))
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
                Expanded(child: poppinsText(text: "Masuk Ke Group Pusat Bantuan", textColor: Colors.black,))
              ],
            ),
            ontap: () {
              launchUrl(Uri.parse(_pusatBantuanLink));
            },
          ),
          const SizedBox(height: 10,),
          CustomTextButton(title: "Tutup", ontap: () {
            Get.back();
          },)
          ],
        ),
      ),
    );
  }
}