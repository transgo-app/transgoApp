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

### 2. Environment

The app loads `.env` via `flutter_dotenv`. Create a `.env` file in the project root with any required keys (e.g. API base URL overrides if used). The `.env` path is listed under `flutter.assets` in `pubspec.yaml`.

### 3. Firebase (optional but recommended)

- Create a Firebase project and add Android/iOS apps.
- Place `google-services.json` in `android/app/` and `GoogleService-Info.plist` in `ios/Runner/`.
- For web, Firebase options are set in `main.dart`; update if using a different project.

### 4. Run

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

1. In Terminal, from the **project root** (`transgoApp/`), run:
   ```bash
   flutter pub get
   cd ios && pod install && cd ..
   ```
2. Open the **workspace** (not the project): `ios/Runner.xcworkspace` in Xcode.
3. Select your iPhone as the run destination and press Cmd+R.

This ensures `FLUTTER_ROOT` is set via `ios/Flutter/Generated.xcconfig` and CocoaPods are in sync.

## Configuration

- **Locale:** Default is Indonesian (`id_ID`); `en_US` is supported.
- **Timezone:** Set to `Asia/Jakarta` for notifications/scheduling.
- **Orientation:** Portrait only (locked in `main.dart`).

## Version

Current app version: **2.2.2+47** (from `pubspec.yaml`).

---

For Flutter basics, see the [Flutter documentation](https://docs.flutter.dev/).
