import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../widget/widgets.dart';
import '../../../../data/data.dart';
import '../../controllers/detailitems_controller.dart';

class DetailKendaraanPickupTerms extends StatelessWidget {
  final DetailitemsController controller;

  const DetailKendaraanPickupTerms({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isKendaraan = controller.isKendaraan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isKendaraan) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Divider(),
          ),
          gabaritoText(
            text: 'Ketentuan Antar - Jemput',
            fontSize: 18,
          ),
          gabaritoText(
            text:
                'Berikut ini biaya antar-jemput kendaraan per unit kalau dilakukan di luar jam operasional, ya!',
            fontSize: 14,
            textColor: textPrimary,
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimeCostRow('06:30', '21:00', 'biaya antar'),
              _buildTimeCostRow('21:01', '21:29', 'biaya antar + 20.000'),
              _buildTimeCostRow('21:30', '22:29', 'biaya antar + 40.000'),
              _buildTimeCostRow('22:30 ', '05:29', 'biaya antar + 50.000'),
              _buildTimeCostRow('05:30', '05:59', 'biaya antar + 40.000'),
              _buildTimeCostRow('06:00', '06:29', 'biaya antar + 20.000'),
            ],
          ),
          const SizedBox(height: 15),
          gabaritoText(
            text: 'Catatan:',
            fontSize: 18,
          ),
          const SizedBox(height: 10),
          _buildNote(
            [
              "Diambil/dikembalikan ke pool Transgo di luar jam kerja akan dikenakan charge setengah dari biaya di atas.",
              "Mohon dikonfirmasi terlebih dahulu apakah kami bisa melayani di jam tersebut atau tidak.",
              "Serah terima unit di luar jam kerja akan dikenakan biaya tambahan sesuai ketentuan di atas."
            ],
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Divider(),
          ),
          gabaritoText(
            text: 'Catatan:',
            fontSize: 18,
          ),
          const SizedBox(height: 10),
          _buildNote(
            [
              "Diambil/dikembalikan ke pool Transgo di luar jam kerja akan dikenakan charge setengah dari biaya di atas.",
              "Mohon dikonfirmasi terlebih dahulu apakah kami bisa melayani di jam tersebut atau tidak."
            ],
          ),
        ],
      ],
    );
  }
  Widget _buildNote(List<String> notes) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: HexColor('#1B18181A'),
      ),
      child: Column(
        children: notes.map((note) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: gabaritoText(
                    text: "•",
                    fontSize: 18,
                  ),
                ),
                Expanded(
                  child: gabaritoText(
                    text: note,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimeCostRow(String startTime, String endTime, String cost) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(IconsaxPlusBold.clock, size: 18),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: gabaritoText(
                text: startTime,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Text("-"),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: gabaritoText(
                text: endTime,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: gabaritoText(
              text: "→  $cost",
              fontSize: 15,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
