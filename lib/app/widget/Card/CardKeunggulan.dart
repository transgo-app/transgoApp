
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class CardKeunggulanTransgo extends StatelessWidget {
  const CardKeunggulanTransgo({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundCard(
  stringHexBG: '#1F61D9',
  stringHexBorder: '#1F61D9',
  body: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: HexColor('#1F61D9'),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const SizedBox(height: 120),
              Container(
                height: 120,
                alignment: Alignment.center,
                child: gabaritoText(
                  text: 'Sewa Mobil & Motor 24 Jam',
                  textColor: Colors.white,
                  fontSize: 16,
                ),
              ),
              Container(
                height: 120,
                alignment: Alignment.center,
                child: gabaritoText(
                  text: 'Antar-Jemput Kendaraan',
                  textColor: Colors.white,
                  fontSize: 16,
                ),
              ),
              Container(
                height: 120,
                alignment: Alignment.center,
                child: gabaritoText(
                  text: 'Tanpa DP/Deposit & Survey',
                  textColor: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),

      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                height: 120,
                child: Image.asset('assets/icon.png'),
              ),
              Container(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(IconsaxPlusBold.tick_circle, color: Colors.green),
                    const SizedBox(height: 4),
                    gabaritoText(text: 'Ada', textColor: textPrimary),
                  ],
                ),
              ),
              Container(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(IconsaxPlusBold.tick_circle, color: Colors.green),
                    const SizedBox(height: 4),
                    gabaritoText(text: 'Ada', textColor: textPrimary),
                  ],
                ),
              ),
              Container(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(IconsaxPlusBold.tick_circle, color: Colors.green),
                    const SizedBox(height: 4),
                    gabaritoText(text: 'Ada', textColor: textPrimary),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      Expanded(
        child: Opacity(
          opacity: 0.5,
          child: Container(
            decoration: BoxDecoration(
              color: HexColor('#1F61D9'),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(IconsaxPlusBold.tag, color: Colors.white),
                      const SizedBox(height: 8),
                      gabaritoText(
                        text: "Brand\nLainnya",
                        textColor: Colors.white,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(IconsaxPlusBold.close_circle, color: Colors.white),
                      const SizedBox(height: 4),
                      gabaritoText(text: 'Tidak Ada', textColor: Colors.white),
                    ],
                  ),
                ),
                Container(
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(IconsaxPlusBold.close_circle, color: Colors.white),
                      const SizedBox(height: 4),
                      gabaritoText(text: 'Tidak Ada', textColor: Colors.white),
                    ],
                  ),
                ),
                Container(
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(IconsaxPlusBold.close_circle, color: Colors.white),
                      const SizedBox(height: 4),
                      gabaritoText(text: 'Tidak Ada', textColor: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
);
  }
}