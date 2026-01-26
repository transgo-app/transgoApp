# Google Sign In iOS Setup Guide

## Overview
This guide will help you configure Google Sign In for iOS in your Flutter app.

## Prerequisites
- Xcode installed
- Apple Developer account
- Firebase project with iOS app configured
- Google Cloud Console access

## Step 1: Configure OAuth Client in Google Cloud Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project (`transgo-app`)
3. Navigate to **APIs & Services** > **Credentials**
4. Find or create an **OAuth 2.0 Client ID** for iOS:
   - Click **Create Credentials** > **OAuth client ID**
   - Choose **iOS** as application type
   - Enter your iOS Bundle ID: `com.transgoapp.transgomobileapp`
   - Click **Create**
   - **Copy the Client ID** (you'll need this)

## Step 2: Update GoogleService-Info.plist

Your `ios/Runner/GoogleService-Info.plist` needs to include the iOS OAuth Client ID. 

**Current file is missing the CLIENT_ID key.** You need to add it:

```xml
<key>CLIENT_ID</key>
<string>YOUR_IOS_CLIENT_ID_HERE.apps.googleusercontent.com</string>
```

**Also add REVERSED_CLIENT_ID** (reverse of CLIENT_ID):
```xml
<key>REVERSED_CLIENT_ID</key>
<string>com.googleusercontent.apps.YOUR_CLIENT_ID_PREFIX</string>
```

Example:
- If CLIENT_ID is: `1022276810838-abc123xyz.apps.googleusercontent.com`
- Then REVERSED_CLIENT_ID is: `com.googleusercontent.apps.1022276810838-abc123xyz`

## Step 3: Update Info.plist

Add the URL scheme to `ios/Runner/Info.plist`. Add this **before the closing `</dict>` tag**:

```xml
<!-- Google Sign In URL Scheme -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

**Important:** Replace `YOUR_REVERSED_CLIENT_ID` with the actual REVERSED_CLIENT_ID from Step 2.

## Step 4: Update AppDelegate.swift

Update `ios/Runner/AppDelegate.swift` to handle Google Sign In URL callbacks:

```swift
import Flutter
import UIKit
import FirebaseCore
import GoogleSignIn

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    
    // Configure Google Sign In
    guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
          let plist = NSDictionary(contentsOfFile: path),
          let clientId = plist["CLIENT_ID"] as? String else {
      fatalError("GoogleService-Info.plist not found or CLIENT_ID missing")
    }
    
    guard let config = GIDConfiguration(clientID: clientId) else {
      fatalError("Failed to create GIDConfiguration")
    }
    GIDSignIn.sharedInstance.configuration = config

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle URL callbacks for Google Sign In
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    if GIDSignIn.sharedInstance.handle(url) {
      return true
    }
    return super.application(app, open: url, options: options)
  }
}
```

## Step 5: Update Podfile (if needed)

Make sure your `ios/Podfile` includes the Google Sign In pod. Run:

```bash
cd ios
pod install
```

If you get errors, you might need to update your Podfile to specify the platform:

```ruby
platform :ios, '12.0'  # or higher
```

## Step 6: Update google_auth_service.dart (Optional)

If you want to specify the iOS client ID explicitly, you can update your service:

```dart
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'profile',
  ],
  serverClientId: _serverClientId,
  // Optional: specify iOS client ID if needed
  // iosClientId: 'YOUR_IOS_CLIENT_ID_HERE.apps.googleusercontent.com',
);
```

## Step 7: Clean and Rebuild

1. Clean the build:
```bash
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

2. Rebuild the app:
```bash
flutter pub get
flutter run
```

## Troubleshooting

### Error: "The operation couldn't be completed"
- Check that CLIENT_ID is correctly added to GoogleService-Info.plist
- Verify the Bundle ID matches in Google Cloud Console and Xcode

### Error: "URL scheme not found"
- Verify REVERSED_CLIENT_ID is correctly added to Info.plist
- Make sure CFBundleURLTypes is properly formatted

### Error: "GIDConfiguration not found"
- Make sure you've imported `GoogleSignIn` in AppDelegate.swift
- Verify pod install completed successfully

### Sign In button doesn't respond
- Check that the URL scheme callback is properly handled in AppDelegate
- Verify the iOS Client ID is created in Google Cloud Console

## Verification Checklist

- [ ] iOS OAuth Client ID created in Google Cloud Console
- [ ] CLIENT_ID added to GoogleService-Info.plist
- [ ] REVERSED_CLIENT_ID added to GoogleService-Info.plist
- [ ] CFBundleURLTypes added to Info.plist
- [ ] AppDelegate.swift updated with Google Sign In configuration
- [ ] AppDelegate.swift handles URL callbacks
- [ ] Pods installed successfully
- [ ] App rebuilt and tested

## Additional Resources

- [Google Sign In Flutter Plugin](https://pub.dev/packages/google_sign_in)
- [Google Sign In iOS Setup](https://developers.google.com/identity/sign-in/ios/start)
- [Firebase iOS Setup](https://firebase.google.com/docs/ios/setup)
