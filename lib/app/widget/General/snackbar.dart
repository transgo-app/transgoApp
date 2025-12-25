
import 'dart:async';
import '../../data/data.dart';
class CustomSnackbar {
  static bool _isSnackbarActive = false;

  static void show({
    String? title,
    String? message,
    TextStyle? titleTextStyle,
    TextStyle? messageTextStyle,
    IconData? icon,
    Duration duration = const Duration(seconds: 2),
    Color backgroundColor = Colors.red,
    SnackPosition snackPosition = SnackPosition.TOP,
  }) {
    if (_isSnackbarActive) return;
    _isSnackbarActive = true;

    Get.snackbar(
      '',
      '',
      icon: Icon(icon ?? Icons.error_rounded, color: Colors.white),
      backgroundColor: backgroundColor,
      snackPosition: snackPosition,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      titleText: title != null
          ? Text(
              title,
              style: titleTextStyle ??
                  poppinsTextStyle.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            )
          : null,
      messageText: message != null
          ? Text(
              message,
              style: messageTextStyle ??
                  poppinsTextStyle.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
            )
          : null,
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      dismissDirection: DismissDirection.horizontal,
    );

    Timer(const Duration(seconds: 3), () {
      _isSnackbarActive = false;
    });
  }
}
