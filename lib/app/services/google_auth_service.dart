import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  GoogleAuthService._();
  static final GoogleAuthService instance = GoogleAuthService._();

  // TODO: Ganti nilai ini dengan Web Client ID dari Google Cloud / Firebase Console
  static const String _serverClientId = '1022276810838-c7s6hdn8sirt5gl4tppkhrdk1g0lr40j.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
    serverClientId: _serverClientId,
  );

  /// Melakukan sign-in ke Google.
  /// Jika [forceAccountSelection] = true, maka akun yang sudah login akan di-signOut
  /// terlebih dahulu sehingga pemilih akun (account picker) selalu muncul.
  Future<GoogleSignInAccount?> signIn({bool forceAccountSelection = false}) async {
    try {
      if (forceAccountSelection && _googleSignIn.currentUser != null) {
        await _googleSignIn.disconnect();
      }

      final account = await _googleSignIn.signIn();
      return account;
    } catch (e) {
      print('Error Google sign-in: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error Google sign-out: $e');
    }
  }

  Future<String?> getIdToken({bool forceAccountSelection = false}) async {
    final account = await signIn(forceAccountSelection: forceAccountSelection);
    if (account == null) return null;

    final auth = await account.authentication;
    return auth.idToken;
  }
}

