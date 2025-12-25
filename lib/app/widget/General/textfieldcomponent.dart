
import 'package:hexcolor/hexcolor.dart';
import '../../data/data.dart';

class reusableTextField extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? ontap;
  final TextEditingController? controller;
  final bool? obscureText;
  final FocusNode? focusNode;
  final TextInputType? inputType;
  final String? errorText;
  final int? maxLines;
  final Color? backgroundColor; 
  const reusableTextField(
      {super.key,
      required this.title,
      this.icon,
      this.ontap,
      this.controller,
      this.obscureText,
      this.focusNode,
      this.inputType,
      this.errorText,
      this.maxLines,
      this.backgroundColor, 
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: obscureText == true ? 1 : maxLines ?? 1,
      focusNode: focusNode,
      obscureText: obscureText ?? false,
      controller: controller,
      autofocus: false,
      keyboardType: inputType ?? TextInputType.text,
      cursorColor: Colors.black87,
      style: poppinsTextStyle.copyWith(fontSize: 14),
      decoration: InputDecoration(
        errorText: errorText == null || errorText == '' ? null : errorText ,
        errorStyle: poppinsTextStyle.copyWith(
          fontSize: 11,
        ),
        hintText: title,
        hintStyle: poppinsTextStyle.copyWith(fontSize: 11),
        suffixIcon: ontap == null
            ? Icon(icon)
            : IconButton(
                onPressed: ontap,
                icon: Icon(
                  icon,
                  color: HexColor("#79747E"),
                ),
              ),
        fillColor: backgroundColor ?? HexColor("#EBEBEB"), 
        filled: backgroundColor != null ? true : false,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.amber,
          ),
          borderRadius: BorderRadius.circular(11),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(11),
        ),
      ),
    );
  }
}
