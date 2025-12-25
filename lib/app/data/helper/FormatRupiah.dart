
import 'package:intl/intl.dart';

String formatRupiah(dynamic nilaiUang) {
  try {
    double value;

    if (nilaiUang is String) {
      value = double.parse(nilaiUang);
    } else if (nilaiUang is double) {
      value = nilaiUang;
    } else if (nilaiUang is int) {
      value = nilaiUang.toDouble();
    } else {
      throw Exception('Tipe data tidak didukung');
    }

    int roundedValue = (value % 1 >= 0.5) 
        ? value.ceil()
        : value.floor();

    return NumberFormat.decimalPattern('id').format(roundedValue);
  } catch (e) {
    return '$nilaiUang';
  }
}
