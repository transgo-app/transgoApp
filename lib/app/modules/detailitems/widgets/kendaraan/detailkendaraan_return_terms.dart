import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import '../../../../widget/widgets.dart';
import '../../../../data/data.dart';
import '../../controllers/detailitems_controller.dart';

class DetailKendaraanReturnTerms extends StatelessWidget {
  final DetailitemsController controller;

  const DetailKendaraanReturnTerms({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isKendaraan = controller.isKendaraan;

    if (!isKendaraan) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Divider(),
        ),
        gabaritoText(text: 'Pengembalian Kendaraan'),
        const SizedBox(height: 10),
        gabaritoText(
          text:
              'Setelah penyewaan mobil berakhir, unit harus dikembalikan dalam keadaan di steam bersih. Jika mobil dalam keadaan belum dicuci, akan dikenakan denda pelanti sebesar 200k!',
          textColor: textPrimary,
          fontSize: 14,
        ),
        BackgroundCard(
          marginVertical: 10,
          stringHexBorder: '#A8F2FC',
          paddingHorizontal: 10,
          paddingVertical: 10,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Icon(
                  IconsaxPlusBold.info_circle,
                  color: HexColor('#03AEC4'),
                ),
                decoration: BoxDecoration(
                  color: HexColor('#F2FDFF'),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: gabaritoText(
                  text:
                      '2 jam sebelum unit dikembalikan, pastikan customer sudah mempersiapkan untuk steam mobil.',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}