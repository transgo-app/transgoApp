import 'package:url_launcher/url_launcher.dart';
import '../widgets.dart';
import '../../data/data.dart';

class DialogBerhasilDaftar extends StatelessWidget {
  final String title;
  final String buttonText;
  final String kontakAdminMessage;
  final VoidCallback ontap;
  const DialogBerhasilDaftar({super.key, required this.title, required this.buttonText, required this.kontakAdminMessage, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 250,
              width: 250,
              child: Image.asset('assets/suksesregister.jpg')),
            poppinsText(text: '$title', fontSize: 12, fontWeight: FontWeight.w600, textAlign: TextAlign.center, ),
            const SizedBox(height: 12,),
            poppinsText(text: '${kontakAdminMessage}', textAlign: TextAlign.justify,),
            const SizedBox(height: 30,),
             ReusableButton(
              height: 45,
              ontap: () {
              launchUrl(Uri.parse('https://wa.me/$whatsAppNumberAdmin?text=${kontakAdminMessage}'));
              },
              bgColor: primaryColor,
              textColor: Colors.white,
              title: "Kontak Admin Sekarang",
            ),
            const SizedBox(height: 10,),
            ReusableButton(
              height: 45,
              ontap: ontap,
              bgColor: Colors.white,
              borderSideColor: Colors.grey,
              textColor: Colors.black,
              title: "${buttonText}",
            ),
           
            const SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}