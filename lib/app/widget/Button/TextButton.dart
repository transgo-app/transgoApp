import '../../data/data.dart';
import '../../widget/General/text.dart';
class CustomTextButton extends StatelessWidget {
  final String title;
  final VoidCallback ontap;
  final Color? textColor;
  const CustomTextButton({super.key, required this.title, required this.ontap, this.textColor});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: ontap,
      child: poppinsText(
        textAlign: TextAlign.center,
        text: title,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        textColor: textColor
      ),
    );
  }
}
