import 'package:flutter/material.dart';
import 'package:transgomobileapp/app/widget/Card/BackgroundCard.dart';
import '../../../../widget/widgets.dart';
import '../../controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ModalAsuransi.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/data/theme.dart';

class SectionAsuransi extends StatelessWidget {
  final DetailitemsController controller;
  const SectionAsuransi({required this.controller, super.key});
  @override
  Widget build(BuildContext context) {
    if (!controller.isKendaraan) {
      return SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
        gabaritoText(text: "Asuransi"),
        gabaritoText(
          text:
              "Pilih perlindungan yang paling pas biar perjalanan makin aman dan tenang, ya!",
          fontSize: 13,
          textColor: textPrimary,
        ),
        BackgroundCard(
            paddingHorizontal: 10,
            paddingVertical: 10,
            marginVertical: 10,
            ontap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return Wrap(
                    children: [
                      ModalPilihanAsuransi(),
                    ],
                  );
                },
              );
            },
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    gabaritoText(
                      text: controller.detailSelectedAsuransi.value,
                      textColor: solidPrimary,
                    ),
                    Icon(
                      IconsaxPlusBold.arrow_square_right,
                      color: solidPrimary,
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                BackgroundCard(
                    borderRadius: 8,
                    marginVertical: 10,
                    stringHexBorder: '#A8F2FC',
                    paddingHorizontal: 10,
                    paddingVertical: 10,
                    body: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Icon(
                            IconsaxPlusBold.info_circle,
                            color: HexColor('#03AEC4'),
                          ),
                          decoration: BoxDecoration(
                              color: HexColor('#F2FDFF'),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: gabaritoText(
                          text:
                              'Asuransi ini bantu lindungi kamu dari risiko finansial kalau ada kejadian tak terduga yang nyangkut sama kendaraan sewaanmu.',
                          fontSize: 14,
                        )),
                      ],
                    )),
              ],
            )),
      ],
    );
  }
}
