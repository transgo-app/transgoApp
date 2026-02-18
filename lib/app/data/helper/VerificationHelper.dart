import 'package:flutter/material.dart';
import '../globalvariables.dart';
import '../../widget/widgets.dart';
import 'package:get/get.dart';

class VerificationHelper {
  /// Check if user account is verified
  /// Returns true if account is verified (not pending or rejected)
  /// Also returns true if user is not logged in (to avoid blocking non-logged-in users)
  static bool isAccountVerified() {
    // If user is not logged in, allow access (login check should be done separately)
    if (GlobalVariables.token.value.isEmpty) {
      return true;
    }
    
    final status = GlobalVariables.statusVerificationAccount.value.trim();
    
    // If status is empty, assume verified (for legacy accounts or accounts without status set)
    if (status.isEmpty) {
      return true;
    }
    
    final statusLower = status.toLowerCase();
    // Account is NOT verified if status is 'pending', 'rejected', or 'pending_verification'
    // All other statuses (approved, verified, active, etc.) are considered verified
    return statusLower != 'pending' && 
           statusLower != 'rejected' && 
           statusLower != 'pending_verification';
  }

  /// Show snackbar and return false if account is not verified
  /// Returns true if account is verified
  static bool checkVerificationAndShowMessage() {
    if (!isAccountVerified()) {
      CustomSnackbar.show(
        title: "Akun Belum Terverifikasi",
        message: "Anda tidak dapat mengakses fitur ini karena akun Anda belum terverifikasi. Silakan lengkapi verifikasi akun terlebih dahulu.",
        backgroundColor: Colors.orange,
        icon: Icons.verified_user_outlined,
      );
      return false;
    }
    return true;
  }
}
