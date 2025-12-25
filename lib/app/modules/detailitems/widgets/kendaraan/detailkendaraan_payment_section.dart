import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import '../../../../widget/widgets.dart';
import '../../../../data/data.dart';
import '../../controllers/detailitems_controller.dart';

class DetailKendaraanPaymentSection extends StatelessWidget {
  final DetailitemsController controller;

  const DetailKendaraanPaymentSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Divider(),
        ),
        gabaritoText(text: "Pembayaran"),
        gabaritoText(
          text: "Kamu bisa melakukan pembayaran lewat metode resmi berikut ini:",
          textColor: textPrimary,
        ),
        const SizedBox(height: 15),
        _buildPaymentMethod(
          'assets/paper.png',
          'Atas nama PT MARIFAH CIPTA BANGSA',
        ),
        _buildPaymentMethod(
          'assets/mandiri.png',
          'PT MARIFAH CIPTA BANGSA',
        ),
        _buildPaymentMethod(
          'assets/bca.png',
          'PT MARIFAH CIPTA BANGSA',
        ),
        BackgroundCard(
          marginVertical: 10,
          stringHexBorder: '#FCD9AB',
          paddingHorizontal: 10,
          paddingVertical: 10,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Icon(
                  IconsaxPlusBold.info_circle,
                  color: solidPrimaryYellow,
                ),
                decoration: BoxDecoration(
                  color: HexColor('#FCD9AB').withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: gabaritoText(
                  text:
                      'Jika transfer di luar metode pembayaran di atas, kami tidak bertanggung jawab atas kerugian yang dialami!',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(String imagePath, String text) {
    return BackgroundCard(
      height: 60,
      paddingHorizontal: 10,
      paddingVertical: 10,
      marginVertical: 5,
      stringHexBG: '#FAFAFA',
      body: Row(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 40,
              maxHeight: 40,
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: gabaritoText(
              text: text,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}