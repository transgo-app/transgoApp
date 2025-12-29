import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../widget/widgets.dart';
import '../../../data/data.dart';
import '../controllers/detailitems_controller.dart';

class DetailitemsWarningSection extends StatelessWidget {
  final DetailitemsController controller;

  const DetailitemsWarningSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber,
            Colors.orange,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/man.png',
              scale: 6,
            ),
          ),
          gabaritoText(
            text: 'Penting Buat Kamu Tahu!',
            fontSize: 20,
            textColor: Colors.white,
          ),
          gabaritoText(
            text:
                'Transgo nggak pernah minta:\n  • Uang deposit atau jaminan\n  • Pembayaran sebelum serah terima kendaraan',
            fontSize: 14,
            textColor: Colors.white,
            fontWeight: FontWeight.w400,
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Icon(
                    IconsaxPlusBold.warning_2,
                    color: solidPrimaryYellow,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: gabaritoText(
                    text: 'Semua pembayaran dilakukan saat serah terima unit!',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
