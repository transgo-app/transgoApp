# Complete iOS App Store Deployment & Google Sign In Setup Guide

## 📋 Overview

This comprehensive guide will walk you through:
1. Setting up Google Sign In for iOS
2. Preparing your app for App Store deployment
3. All necessary configurations and steps

---

## 🎯 Part 1: Google Sign In iOS Setup

### Step 1: Get iOS OAuth Client ID from Google Cloud Console

**You can do this on Windows (in browser):**

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project: **transgo-app**
3. Navigate to **APIs & Services** > **Credentials**
4. Click **Create Credentials** > **OAuth client ID**
5. Choose **iOS** as application type
6. Enter Bundle ID: `com.transgoapp.transgomobileapp`
7. Click **Create**
8. **Copy the Client ID** (format: `1022276810838-xxxxx.apps.googleusercontent.com`)
9. **Save this Client ID** - you'll need it!

### Step 2: Update GoogleService-Info.plist

**File:** `ios/Runner/GoogleService-Info.plist`

**Add these keys before the closing `</dict>` tag:**

```xml
	<!-- Google Sign In Configuration -->
	<key>CLIENT_ID</key>
	<string>YOUR_IOS_CLIENT_ID_HERE.apps.googleusercontent.com</string>
	
	<key>REVERSED_CLIENT_ID</key>
	<string>com.googleusercontent.apps.YOUR_CLIENT_ID_PREFIX</string>
```

**How to calculate REVERSED_CLIENT_ID:**
- If CLIENT_ID is: `1022276810838-abc123xyz.apps.googleusercontent.com`
- Then REVERSED_CLIENT_ID is: `com.googleusercontent.apps.1022276810838-abc123xyz`
- Basically: Remove `.apps.googleusercontent.com` and reverse the format

**Example:**
```xml
	<key>CLIENT_ID</key>
	<string>1022276810838-abc123xyz.apps.googleusercontent.com</string>
	
	<key>REVERSED_CLIENT_ID</key>
	<string>com.googleusercontent.apps.1022276810838-abc123xyz</string>
```

### Step 3: Update Info.plist URL Scheme

**File:** `ios/Runner/Info.plist`

**Find line 78** and replace the placeholder with your actual REVERSED_CLIENT_ID:

**Before:**
```xml
<string>com.googleusercontent.apps.1022276810838</string>
```

**After (use your actual REVERSED_CLIENT_ID):**
```xml
<string>com.googleusercontent.apps.1022276810838-abc123xyz</string>
```

### Step 4: Verify AppDelegate.swift

**File:** `ios/Runner/AppDelegate.swift`

✅ **Already configured!** The file already has:
- Google Sign In import
- Configuration code
- URL callback handling

No changes needed here.

---

## 🍎 Part 2: App Store Deployment Preparation

### Step 5: Apple Developer Account Setup

**Before you start, you need:**
- [ ] Apple Developer Account ($99/year)
- [ ] Access to [Apple Developer Portal](https://developer.apple.com/)
- [ ] Xcode installed on MacBook

### Step 6: Configure App Versioning

**File:** `pubspec.yaml`

Your current version is: `version: 2.1.0+39`

**Format:** `version: MAJOR.MINOR.PATCH+BUILD_NUMBER`

- **2.1.0** = Version shown to users (CFBundleShortVersionString)
- **39** = Build number (CFBundleVersion)

**For App Store:**
- Increment BUILD_NUMBER for each submission
- Increment VERSION when releasing new features

### Step 7: Update Info.plist for App Store

**File:** `ios/Runner/Info.plist`

**Verify these settings:**

1. **App Display Name:**
   ```xml
   <key>CFBundleDisplayName</key>
   <string>Transgo</string>
   ```

2. **Bundle Identifier:**
   - Must match: `com.transgoapp.transgomobileapp`
   - Verify in Xcode project settings

3. **Version Numbers:**
   - These come from `pubspec.yaml` automatically
   - No manual changes needed

4. **Privacy Descriptions:**
   - ✅ Camera permission - Already added
   - ✅ Photo library permission - Already added
   - ✅ Photo library add permission - Already added

### Step 8: Prepare App Icons and Launch Screen

**App Icon:**
- Location: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- Required sizes: 1024x1024 (App Store), plus various device sizes
- Format: PNG without alpha channel

**Launch Screen:**
- Already configured: `LaunchScreen.storyboard`

### Step 9: Configure Signing & Capabilities (In Xcode)

**When you get your MacBook:**

1. Open `ios/Runner.xcworkspace` in Xcode (NOT .xcodeproj)
2. Select **Runner** in project navigator
3. Go to **Signing & Capabilities** tab
4. Select your **Team** (Apple Developer account)
5. Enable **Automatically manage signing**
6. Verify Bundle Identifier: `com.transgoapp.transgomobileapp`

**Capabilities to enable:**
- ✅ Push Notifications (if using FCM)
- ✅ Background Modes (for notifications)
- ✅ Associated Domains (if needed)

---

## 🔧 Part 3: Build & Deploy Steps (On MacBook)

### Step 10: Install Dependencies

```bash
# Navigate to project root
cd /path/to/transgoApp

# Install Flutter dependencies
flutter pub get

# Install iOS CocoaPods
cd ios
pod install
cd ..
```

### Step 11: Verify Google Sign In Configuration

**Check these files:**

1. **GoogleService-Info.plist:**
   - ✅ CLIENT_ID present
   - ✅ REVERSED_CLIENT_ID present

2. **Info.plist:**
   - ✅ URL scheme matches REVERSED_CLIENT_ID

3. **AppDelegate.swift:**
   - ✅ Google Sign In code present

### Step 12: Test Google Sign In

```bash
# Run on simulator or device
flutter run

# Or build for device
flutter build ios
```

**Test:**
1. Open app
2. Try Google Sign In
3. Verify it works correctly

### Step 13: Build for App Store

**Option A: Using Flutter CLI**

```bash
# Build iOS release
flutter build ios --release

# This creates: build/ios/iphoneos/Runner.app
```

**Option B: Using Xcode (Recommended)**

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Product** > **Scheme** > **Runner**
3. Select **Any iOS Device** or **Generic iOS Device**
4. Go to **Product** > **Archive**
5. Wait for archive to complete
6. **Organizer** window will open automatically

### Step 14: Upload to App Store Connect

**In Xcode Organizer:**

1. Select your archive
2. Click **Distribute App**
3. Choose **App Store Connect**
4. Click **Next**
5. Select **Upload**
6. Click **Next**
7. Choose distribution options:
   - ✅ Include bitcode (if required)
   - ✅ Upload symbols (for crash reports)
8. Click **Upload**
9. Wait for upload to complete

**Alternative: Using Transporter App**

1. Export archive from Xcode
2. Open **Transporter** app (from Mac App Store)
3. Drag .ipa file to Transporter
4. Click **Deliver**

### Step 15: Configure App Store Connect

**In [App Store Connect](https://appstoreconnect.apple.com/):**

1. **Create App:**
   - App Name: Transgo
   - Primary Language: Indonesian (or your choice)
   - Bundle ID: `com.transgoapp.transgomobileapp`
   - SKU: `transgo-app` (unique identifier)

2. **App Information:**
   - Category
   - Subtitle
   - Privacy Policy URL

3. **Pricing:**
   - Set price (Free or Paid)

4. **Version Information:**
   - What's New (release notes)
   - Screenshots (required for each device size)
   - Description
   - Keywords
   - Support URL
   - Marketing URL (optional)

5. **Build Selection:**
   - After upload completes, select build
   - Wait for processing (can take 10-30 minutes)

6. **App Review Information:**
   - Contact information
   - Demo account (if needed)
   - Notes for reviewer

7. **Submit for Review:**
   - Review all information
   - Click **Submit for Review**

---

## ✅ Pre-Deployment Checklist

### Google Sign In Setup:
- [ ] iOS OAuth Client ID created in Google Cloud Console
- [ ] CLIENT_ID added to GoogleService-Info.plist
- [ ] REVERSED_CLIENT_ID calculated and added to GoogleService-Info.plist
- [ ] Info.plist URL scheme updated with REVERSED_CLIENT_ID
- [ ] AppDelegate.swift configured (already done ✅)
- [ ] Google Sign In tested on device/simulator

### App Store Preparation:
- [ ] Apple Developer Account active
- [ ] App version and build number set in pubspec.yaml
- [ ] App icons prepared (all required sizes)
- [ ] Launch screen configured
- [ ] Privacy descriptions added to Info.plist
- [ ] Bundle ID verified: `com.transgoapp.transgomobileapp`
- [ ] Signing certificates configured in Xcode
- [ ] App tested on physical device
- [ ] Screenshots prepared for App Store
- [ ] App description and metadata prepared
- [ ] Privacy policy URL ready

### Build & Upload:
- [ ] `pod install` completed successfully
- [ ] App builds without errors
- [ ] Archive created successfully
- [ ] App uploaded to App Store Connect
- [ ] Build processing completed
- [ ] App information filled in App Store Connect
- [ ] Submitted for review

---

## 🚨 Common Issues & Solutions

### Google Sign In Issues:

**Error: "CLIENT_ID missing"**
- Solution: Verify CLIENT_ID is in GoogleService-Info.plist
- Check spelling: `CLIENT_ID` (not `CLIENTID`)

**Error: "URL scheme not found"**
- Solution: Verify REVERSED_CLIENT_ID in Info.plist matches GoogleService-Info.plist
- Check CFBundleURLTypes is properly formatted

**Error: "The operation couldn't be completed"**
- Solution: Verify Bundle ID matches in:
  - Xcode project settings
  - Google Cloud Console OAuth client
  - GoogleService-Info.plist

### App Store Issues:

**Error: "No signing certificate found"**
- Solution: In Xcode, go to Signing & Capabilities
- Select your team
- Enable "Automatically manage signing"

**Error: "Invalid Bundle Identifier"**
- Solution: Verify Bundle ID is unique and matches everywhere
- Check it's registered in Apple Developer Portal

**Error: "Missing compliance"**
- Solution: In App Store Connect, answer export compliance questions
- Usually: "No" to encryption questions for standard apps

**Error: "Missing screenshots"**
- Solution: Provide screenshots for all required device sizes:
  - iPhone 6.7" (iPhone 14 Pro Max)
  - iPhone 6.5" (iPhone 11 Pro Max)
  - iPhone 5.5" (iPhone 8 Plus)
  - iPad Pro 12.9" (if supporting iPad)

---

## 📝 Important Notes

### Version Numbering:
- **Version** (2.1.0): User-facing version, increment for releases
- **Build** (39): Internal build number, increment for each upload
- App Store requires build number to increase with each submission

### Bundle ID:
- **Must be unique** across all App Store apps
- **Cannot be changed** after first submission
- Current: `com.transgoapp.transgomobileapp`

### Testing:
- **TestFlight** is recommended before App Store release
- Upload build to App Store Connect
- Add internal/external testers
- Test for 1-2 weeks before public release

### Review Time:
- **Initial review:** 1-3 days typically
- **Updates:** Usually faster (few hours to 1 day)
- **Rejections:** Fix issues and resubmit

---

## 🔗 Useful Links

- [Apple Developer Portal](https://developer.apple.com/)
- [App Store Connect](https://appstoreconnect.apple.com/)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

---

## 📞 Support

If you encounter issues:
1. Check error messages carefully
2. Review this guide's troubleshooting section
3. Check Flutter/Apple documentation
4. Verify all configuration files match

---

**Last Updated:** Complete setup guide for iOS deployment
**Status:** Ready for MacBook setup and App Store submission
