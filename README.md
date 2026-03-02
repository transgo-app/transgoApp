# Transgo Mobile App

A Flutter mobile application for **Transgo** — vehicle (car & motorcycle) rental services in Indonesia. Browse fleets, book rentals, manage orders, and pay with TgPay.

## Features

- **Authentication** — Login, register, and Google Sign-in
- **Dashboard** — Search vehicles, filters, flash sales, seasonal charges, fleet recommendations
- **Vehicle details & booking** — View vehicle info, pickup terms, pricing, and complete rental forms
- **Order history** — Riwayat pemesanan and order detail views
- **Profile & account** — User profile, additional data, and verification status
- **TgPay** — In-app wallet and payment
- **Transgo Rewards** — Rewards and tier display
- **Fleet ranking** — Fleet leaderboard
- **Chatbot** — In-app support
- **Location tracking** — Background location (Android) for dashboard map when app is in use
- **Push notifications** — Firebase Cloud Messaging and local notifications
- **App updates** — In-app prompt to update from Play Store / App Store

## Tech Stack

- **Framework:** Flutter (SDK >=3.4.0)
- **State management:** GetX
- **Backend:** REST API (`api.transgo.id`)
- **Firebase:** Core, Messaging
- **Maps:** flutter_map, geolocator, geocoding
- **Other:** Google Sign-In, PDF viewer (Syncfusion), WebView, shared_preferences, cached_network_image

## Project Structure

```
lib/
├── main.dart                 # App entry, Firebase, foreground task, upgrader
├── app/
│   ├── data/                 # API, models, helpers, global state
│   │   ├── service/          # APIService, LocationTrackingService, NotificationService, etc.
│   │   ├── models/           # Fleet, recommendations, etc.
│   │   ├── helper/           # Storage, verification, formatting
│   │   └── globalvariables.dart
│   ├── modules/              # Feature modules (GetX)
│   │   ├── dashboard/
│   │   ├── detailitems/      # Vehicle detail & rental form
│   │   ├── login/
│   │   ├── register/
│   │   ├── profile/
│   │   ├── riwayatpemesanan/ # Order history
│   │   ├── tgpay/
│   │   ├── chatbot/
│   │   ├── fleet_ranking/
│   │   └── ...
│   ├── routes/               # app_pages, app_routes, Navbar
│   ├── widget/               # Shared dialogs, modals, UI components
│   ├── services/             # e.g. google_auth_service
│   └── utils/                # Helpers (e.g. url_launcher)
```

## Prerequisites

- Flutter SDK >=3.4.0
- Dart SDK >=3.4.0
- Android Studio / Xcode for device builds
- Firebase project (for FCM and optional web config)

## Getting Started

### 1. Clone and install

```bash
git clone <repository-url>
cd transgoApp
flutter pub get
```

### 2. Firebase (optional but recommended)

- Create a Firebase project and add Android/iOS apps.
- Place `google-services.json` in `android/app/` and `GoogleService-Info.plist` in `ios/Runner/`.
- For web, Firebase options are set in `main.dart`; update if using a different project.

### 3. Run

```bash
# Debug
flutter run

# Release
flutter run --release
```

## Build

- **Android:** `flutter build apk` or `flutter build appbundle`
- **iOS:** `flutter build ios` (then archive in Xcode)

### iOS: building from Xcode (e.g. Run on device)

If you get **PhaseScriptExecution failed** when pressing Cmd+R in Xcode:

1. **See the actual error:** In Xcode, open the **Report navigator** (⌘9), click the failed build, then expand the **"Run Script"** or **"Thin Binary"** step. The log will show either a FLUTTER_ROOT message, a CocoaPods "Run pod install" message, or "xcode_backend.sh failed with exit code N".

2. **From Terminal** (project root `transgoApp/`), run:
   ```bash
   flutter pub get
   cd ios && pod install && cd ..
   ```
3. Open **`ios/Runner.xcworkspace`** in Xcode (not the `.xcodeproj`), select your device, and press Cmd+R.

4. **If it still fails,** build and run from the command line so Flutter sets up the iOS build correctly, then try Xcode again:
   ```bash
   cd /path/to/transgoApp
   flutter run
   ```
   (Choose your iPhone when prompted.) After a successful `flutter run`, building from Xcode (Cmd+R) often works for subsequent runs.

5. **"xcode_backend.sh build failed with exit code 255"** — This usually means `ios/Flutter/Generated.xcconfig` has paths for a different OS (e.g. Windows paths on a Mac). Fix: delete that file and regenerate it on the machine you’re building on:
   ```bash
   rm -f ios/Flutter/Generated.xcconfig
   flutter pub get
   flutter run
   ```
   (Do not commit `Generated.xcconfig`; it’s in `ios/.gitignore` and is regenerated per machine.)

6. **iOS crash on reopen (EXC_BAD_ACCESS in plugin registration)** — The native iOS code of `flutter_foreground_task` and `map_launcher` can crash on cold start (null dereference in `register(with:)`). A Run Script build phase "Patch GeneratedPluginRegistrant (disable crashy plugins on iOS)" in the Runner target comments out their registration lines in `GeneratedPluginRegistrant.m` before compile. If that file is regenerated (e.g. after `flutter pub get`), the script re-applies the patch on the next build. The app does not use these plugins on iOS (foreground task is Android-only; map_launcher is unused in lib).

## Configuration

- **Locale:** Default is Indonesian (`id_ID`); `en_US` is supported.
- **Timezone:** Set to `Asia/Jakarta` for notifications/scheduling.
- **Orientation:** Portrait only (locked in `main.dart`).

## Version

Current app version: **2.2.2+47** (from `pubspec.yaml`).

---

For Flutter basics, see the [Flutter documentation](https://docs.flutter.dev/).
