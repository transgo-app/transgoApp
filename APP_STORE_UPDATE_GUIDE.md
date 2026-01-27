# dApp Store Update Guide - Publishing New Version

## 📋 Quick Overview

Your current version: **2.1.0+39**

To publish an update, you need to:
1. ✅ Increment build number (REQUIRED - must be higher than current)
2. ⚠️ Optionally increment version (if new features)
3. Build and archive
4. Upload to App Store Connect
5. Create new version in App Store Connect
6. Submit for review

---

## 🚀 Step-by-Step Update Process

### Step 1: Update Version Number

**File:** `pubspec.yaml`

**Current:** `version: 2.1.0+39`

**For this update, change to:**
```yaml
version: 2.1.0+40
```

**Or if you have new features:**
```yaml
version: 2.1.1+40
```

**Rules:**
- **Build number (+40)** must be HIGHER than the current build on App Store
- **Version (2.1.0)** can stay same for bug fixes, or increment for new features
- Format: `MAJOR.MINOR.PATCH+BUILD_NUMBER`

**Version increment guide:**
- **Bug fixes only:** Keep version same, increment build: `2.1.0+40`
- **New features:** Increment minor: `2.1.1+40`
- **Major changes:** Increment major: `2.2.0+40`

---

### Step 2: Clean and Prepare Build

```bash
# Navigate to project
cd /path/to/transgoApp

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Install/update iOS pods
cd ios
pod install
cd ..
```

---

### Step 3: Test Before Building

```bash
# Test on simulator first
flutter run

# Or test on physical device
flutter run -d <device-id>
```

**Test checklist:**
- [ ] App launches correctly
- [ ] Google Sign In works
- [ ] All new features work
- [ ] No crashes or errors
- [ ] UI looks correct

---

### Step 4: Build for App Store

**Option A: Using Flutter CLI (Recommended)**

```bash
# Build iOS release
flutter build ipa --release

# This creates: build/ios/ipa/transgomobileapp.ipa
```

**Option B: Using Xcode**

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Product** > **Scheme** > **Runner**
3. Select **Any iOS Device** (not simulator)
4. Go to **Product** > **Archive**
5. Wait for archive to complete

---

### Step 5: Upload to App Store Connect

**Method 1: Using Flutter CLI (Easiest)**

```bash
# After building with flutter build ipa
# The .ipa file is ready at: build/ios/ipa/transgomobileapp.ipa

# Upload using Transporter app or Xcode
```

**Method 2: Using Xcode Organizer**

1. After archiving, Xcode Organizer opens automatically
2. Select your archive
3. Click **Distribute App**
4. Choose **App Store Connect**
5. Click **Next**
6. Select **Upload**
7. Click **Next**
8. Choose options:
   - ✅ Upload your app's symbols (recommended for crash reports)
   - ✅ Manage Version and Build Number (usually auto)
9. Click **Upload**
10. Wait for upload to complete (5-15 minutes)

**Method 3: Using Transporter App**

1. Download **Transporter** from Mac App Store (if not installed)
2. Open Transporter
3. Drag your `.ipa` file to Transporter
4. Click **Deliver**
5. Wait for upload to complete

---

### Step 6: Create New Version in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Click **My Apps**
3. Select your **Transgo** app
4. Click **+ Version or Platform** (or click on current version)
5. Enter new version number (e.g., `2.1.0` or `2.1.1`)
6. Click **Create**

---

### Step 7: Select Build

1. In the new version page, scroll to **Build** section
2. Click **+** next to Build
3. Select your uploaded build (it may take 10-30 minutes to process)
4. Wait until status shows "Ready to Submit"

**Note:** If you don't see your build:
- Wait 10-30 minutes for processing
- Refresh the page
- Check that build number is higher than previous version

---

### Step 8: Fill Version Information

**Required fields:**

1. **What's New in This Version** (Release Notes)
   - Describe new features, bug fixes, improvements
   - Example: "Bug fixes and performance improvements"
   - Or: "Added Google Sign In support, fixed weekend charge calculation, improved UI"

2. **Screenshots** (if changed)
   - Only required if you're changing screenshots
   - Can reuse previous screenshots

3. **App Review Information**
   - Contact information (usually pre-filled)
   - Demo account (if needed)
   - Notes for reviewer (optional)

---

### Step 9: Submit for Review

1. Review all information
2. Check that build is selected and "Ready to Submit"
3. Scroll to top
4. Click **Submit for Review**
5. Answer any compliance questions
6. Confirm submission

---

### Step 10: Monitor Review Status

**In App Store Connect:**

1. Go to your app
2. Check **App Store** tab
3. Status will show:
   - **Waiting for Review** (1-3 days typically)
   - **In Review** (few hours to 1 day)
   - **Ready for Sale** (approved!)
   - **Rejected** (fix issues and resubmit)

**Review times:**
- **Updates:** Usually 24-48 hours
- **First submission:** 1-3 days
- **Rejections:** Fix and resubmit (usually faster)

---

## ✅ Pre-Submission Checklist

### Version & Build:
- [ ] Build number incremented in `pubspec.yaml`
- [ ] Version number updated (if needed)
- [ ] Version matches what you want to show users

### Testing:
- [ ] App tested on iOS device
- [ ] Google Sign In tested and working
- [ ] All features working correctly
- [ ] No crashes or errors

### Build:
- [ ] `flutter clean` executed
- [ ] `pod install` completed successfully
- [ ] Build completed without errors
- [ ] Archive/IPA created successfully

### Upload:
- [ ] Build uploaded to App Store Connect
- [ ] Build processing completed
- [ ] Build status shows "Ready to Submit"

### App Store Connect:
- [ ] New version created
- [ ] Build selected for new version
- [ ] Release notes written
- [ ] All required fields filled
- [ ] Ready to submit

---

## 🚨 Common Issues & Solutions

### Issue: "Build number must be higher"

**Solution:**
- Check current build number on App Store Connect
- Make sure your new build number is higher
- Example: If current is 39, use 40 or higher

### Issue: "Build not appearing in App Store Connect"

**Solutions:**
1. Wait 10-30 minutes for processing
2. Refresh the page
3. Check upload was successful
4. Verify build number is higher than previous

### Issue: "Invalid Bundle Identifier"

**Solution:**
- Bundle ID must match exactly: `com.transgoapp.transgomobileapp`
- Check in Xcode project settings
- Verify in App Store Connect

### Issue: "Missing compliance information"

**Solution:**
- Answer export compliance questions in App Store Connect
- Usually: "No" to encryption questions for standard apps
- Required for each submission

### Issue: "Code signing failed"

**Solution:**
1. Open Xcode
2. Go to Signing & Capabilities
3. Select your Team
4. Enable "Automatically manage signing"
5. Clean and rebuild

---

## 📝 Version Number Examples

**Current:** `2.1.0+39`

**Bug fix update:**
```yaml
version: 2.1.0+40
```

**New feature update:**
```yaml
version: 2.1.1+40
```

**Major update:**
```yaml
version: 2.2.0+40
```

**Hotfix (urgent bug fix):**
```yaml
version: 2.1.0+41  # Same version, higher build
```

---

## 🔄 Quick Update Workflow

```bash
# 1. Update version in pubspec.yaml
# 2. Clean and build
flutter clean
flutter pub get
cd ios && pod install && cd ..

# 3. Build IPA
flutter build ipa --release

# 4. Upload via Transporter or Xcode
# 5. Create version in App Store Connect
# 6. Submit for review
```

---

## 📞 Need Help?

If you encounter issues:
1. Check error messages in App Store Connect
2. Review this guide's troubleshooting section
3. Check [Apple's App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
4. Verify all configuration files are correct

---

**Last Updated:** Guide for updating existing App Store app
**Current Version:** 2.1.0+39
**Next Update:** Increment build number to 40 or higher
