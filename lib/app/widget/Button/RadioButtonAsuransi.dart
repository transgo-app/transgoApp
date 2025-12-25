
import 'package:transgomobileapp/app/widget/General/text.dart';
import '../../data/data.dart';
import '../widgets.dart';

class AsuransiRadioButton<T> extends StatelessWidget {
  final T groupValue;
  final ValueChanged onChanged;
  final String value;
  final String title;
  final String subtitle;
  final Color? activeColor;
  final Color? textColor;

  const AsuransiRadioButton({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.value,
    required this.title,
    required this.subtitle,
    this.activeColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: groupValue,
          activeColor: primaryColor,
          onChanged: onChanged,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              poppinsText(
                text: title,
                textColor: primaryColor,
              ),
              poppinsText(text: subtitle),
            ],
          ),
        )
      ],
    );
  }
}