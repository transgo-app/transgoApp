import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';

class CustomDropdown extends StatelessWidget {
  final String? hintText;
  final List<dynamic> items;
  final String? selectedValue;
  final Function(String?) onChanged;
  final Color dropdownColor;
  final Icon? icon;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.selectedValue,
    this.hintText,
    this.dropdownColor = Colors.white,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final uniqueItems = <String>{};
    final validItems = items.where((item) {
      final id = item['id'].toString();
      if (uniqueItems.contains(id)) {
        return false;
      } else {
        uniqueItems.add(id);
        return true;
      }
    }).toList();

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), 
        border: Border.all(
          color: Colors.grey,
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: hintText != null
              ? gabaritoText(
                  text: hintText ?? '',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                )
              : null,
          isExpanded: true,
          value: selectedValue?.isEmpty ?? true ? null : selectedValue,
          dropdownColor: dropdownColor,
          items: validItems.map((item) {
            return DropdownMenuItem<String>(
              value: item['id'].toString(),
              child: poppinsText(
                text: item['name'].toString(),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: icon ?? const Icon(Icons.arrow_drop_down_rounded),
        ),
      ),
    );
  }
}


class DurationOption {
  final int days;
  final String label;
  final String endDate;
  final String displayTime;

  DurationOption({
    required this.days,
    required this.label,
    required this.endDate,
    required this.displayTime,
  });

  @override
  String toString() {
    return '$label ($endDate - $displayTime)';
  }
}

class DurationDropdown extends StatefulWidget {
  final String startDate; 
  final String time;
  final Function(DurationOption)? onSelectionChanged;

  const DurationDropdown({
    Key? key,
    required this.startDate,
    required this.time,
    this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<DurationDropdown> createState() => _DurationDropdownState();
}

class _DurationDropdownState extends State<DurationDropdown> {
  DurationOption? selectedOption;
  late List<DurationOption> options;
  @override
  void initState() {
    super.initState();
    options = _generateDurationOptions();
    selectedOption = options.first;
  }

  List<DurationOption> _generateDurationOptions() {
    List<DurationOption> result = [];
    DateTime startDate = _parseDate(widget.startDate);
    
    for (int i = 1; i <= 30; i++) {
      DateTime endDate = startDate.add(Duration(days: i));
      result.add(DurationOption(
        days: i,
        label: '$i Hari',
        endDate: _formatDate(endDate),
        displayTime: widget.time,
      ));
    }
    
    return result;
  }

  DateTime _parseDate(String dateStr) {
    List<String> parts = dateStr.split('/');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gabaritoText(text: "Durasi*", textColor: textPrimary, fontSize: 14,),
          const SizedBox(height: 5),
          
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<DurationOption>(
                padding: EdgeInsets.symmetric(horizontal: 10),
                value: selectedOption,
                isExpanded: true,
                isDense: false,
                icon: Icon(
                  IconsaxPlusBold.arrow_circle_down,
                  color: Colors.black,
                  size: 24,
                ),
                style: gabaritoTextStyle.copyWith(
                  color: Colors.black,
                  fontSize: 14,
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(8),
                menuMaxHeight: 300, 
                items: options.map((DurationOption option) {
                  return DropdownMenuItem<DurationOption>(
                    value: option,
                    child: Container(
                      height: 56,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            option.label,
                            style: gabaritoTextStyle.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${option.endDate} - ${option.displayTime}',
                            style: gabaritoTextStyle.copyWith(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (DurationOption? newValue) {
                  setState(() => selectedOption = newValue);
                  if (widget.onSelectionChanged != null && newValue != null) {
                    widget.onSelectionChanged!(newValue);
                  }
                },
                selectedItemBuilder: (BuildContext context) {
                  return options.map((DurationOption option) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        option.label,
                        style: gabaritoTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
