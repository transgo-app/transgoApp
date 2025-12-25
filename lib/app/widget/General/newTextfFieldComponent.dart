import 'package:hexcolor/hexcolor.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class newReusableTextField extends StatelessWidget {
  final String? title;
  final String? hintText;
  final Widget? icon;
  final VoidCallback? ontap;
  final TextEditingController? controller;
  final bool? obscureText;
  final FocusNode? focusNode;
  final TextInputType? inputType;
  final String? errorText;
  const newReusableTextField(
      {super.key,
      this.title,
      this.hintText,
      this.icon,
      this.ontap,
      this.controller,
      this.obscureText,
      this.focusNode,
      this.inputType,
      this.errorText,
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: gabaritoText(
              text: title ?? '',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              textColor: textPrimary,
            )),
        TextFormField(
          maxLines: obscureText == true ? 1 : null,
          focusNode: focusNode,
          obscureText: obscureText ?? false,
          controller: controller,
          autofocus: false,
          keyboardType: inputType ?? TextInputType.text,
          cursorColor: Colors.blue,
          style: gabaritoTextStyle.copyWith(fontSize: 16),
          decoration: InputDecoration(
            errorText: errorText == null || errorText == '' ? null : errorText,
            errorStyle: gabaritoTextStyle.copyWith(
              fontSize: 14,
            ),
            contentPadding: EdgeInsets.symmetric(
            vertical: 12, 
            horizontal: 12,
          ),
            hintText: hintText,
            hintStyle: gabaritoTextStyle.copyWith(fontSize: 14, color: textSecondary),
            suffixIcon: icon,
            fillColor: HexColor("#EBEBEB"),

            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),

            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),

            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        )
      ],
    );
  }
}
