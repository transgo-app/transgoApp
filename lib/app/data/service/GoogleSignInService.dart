import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  // Server Client ID (OAuth 2.0 Web Client ID) - needed to get ID token
  // This should be the Web application client ID from Google Cloud Console
  static const String serverClientId = '1022276810838-c7s6hdn8sirt5gl4tppkhrdk1g0lr40j.apps.googleusercontent.com';
  
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: serverClientId, // Required to get ID token for backend verification
  );

  /// Sign in with Google and return user information with ID token
  /// Returns a map with 'email', 'name', 'photoUrl', and 'idToken' keys, or null if sign-in failed
  /// This method signs out first to ensure the account picker appears
  static Future<Map<String, String>?> signIn() async {
    try {
      // Sign out first to clear any cached account and force account picker to show
      await _googleSignIn.signOut();
      
      // Now sign in - this will show the account picker
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      
      if (account == null) {
        // User cancelled the sign-in
        return null;
      }

      // Get the authentication object to retrieve ID token
      final GoogleSignInAuthentication auth = await account.authentication;

      // Debug: Print token info
      print('Google Sign-In - Email: ${account.email}');
      print('Google Sign-In - ID Token exists: ${auth.idToken != null}');
      print('Google Sign-In - ID Token length: ${auth.idToken?.length ?? 0}');
      
      if (auth.idToken == null || auth.idToken!.isEmpty) {
        print('ERROR: ID Token is null or empty!');
        print('Make sure serverClientId is correctly configured.');
      }

      return {
        'email': account.email,
        'name': account.displayName ?? '',
        'photoUrl': account.photoUrl ?? '',
        'idToken': auth.idToken ?? '', // Google ID Token (JWT) for backend verification
        'accessToken': auth.accessToken ?? '',
      };
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  /// Sign out from Google
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error signing out from Google: $e');
    }
  }

  /// Check if user is currently signed in
  static Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  /// Get current signed in account
  static Future<GoogleSignInAccount?> getCurrentUser() async {
    return await _googleSignIn.currentUser;
  }
}
