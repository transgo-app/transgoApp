
import 'package:hexcolor/hexcolor.dart';
import 'package:transgomobileapp/app/data/data.dart';

class BackgroundCard extends StatelessWidget {
  final double? height;
  final Widget body;
  final double? marginHorizontal;
  final double? marginVertical;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final VoidCallback? ontap;
  final double? width;
  final String? stringHexBG;
  final String? stringHexBorder;
  final double? borderRadius;
  const BackgroundCard({super.key, this.height = 80, required this.body, this.marginVertical = 0, this.marginHorizontal, this.paddingHorizontal, this.paddingVertical, this.ontap, this.width, this.stringHexBG, this.stringHexBorder, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: marginHorizontal ?? 0, vertical: marginVertical ?? 0),
        padding: EdgeInsets.symmetric(horizontal:paddingHorizontal ?? 10 , vertical: paddingVertical ?? 10) ,
        width: width ?? MediaQuery.of(context).size.width,
        constraints: BoxConstraints(
          minHeight: height ?? 0
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            color: HexColor(stringHexBG ?? "#FFFFFF"),
            border: Border.all(color: HexColor(stringHexBorder ?? '#9E9E9E80')),
            boxShadow: [
            ]),
            child: body,
      ),
    );
  }
}
