import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:upgrader/upgrader.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'app/routes/app_pages.dart';
import 'app/data/data.dart';
import 'app/data/service/LocationTrackingTaskHandler.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final Upgrader upgrader = Upgrader(
  debugLogging: true,
  debugDisplayAlways: false,
  durationUntilAlertAgain: Duration.zero,
  storeController: UpgraderStoreController(
    onAndroid: () => UpgraderPlayStore(),
  ),
  willDisplayUpgrade: ({
    required bool display,
    String? installedVersion,
    versionInfo,
  }) {
    debugPrint('display=$display');
    debugPrint('storeVersion=${versionInfo?.appStoreVersion}');
    debugPrint('installedVersion=$installedVersion');
  },
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

  await initializeDateFormatting('id_ID', null);
  await GlobalVariables.initializeData();

  final bool loggedIn = await GlobalVariables().isLoggedIn();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyDPZWOTBBZpDDExpo4Z4ew3oOtK6a9To7s',
          appId: '1:1022276810838:android:13e9e87a3cc417575763f7',
          messagingSenderId: '1022276810838',
          projectId: 'transgo-app',
        ),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Firebase initialization timeout');
          throw TimeoutException('Firebase initialization timeout');
        },
      );
    } else {
      await Firebase.initializeApp().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Firebase initialization timeout');
          throw TimeoutException('Firebase initialization timeout');
        },
      );
    }
  } catch (e) {
    debugPrint('Error initializing Firebase Core: $e');
    // Continue even if Firebase fails
  }

  // Initialize Firebase API in background - don't block app startup
  FirebaseApi().init().catchError((error) {
    debugPrint('Firebase API initialization error: $error');
  });

  // Initialize foreground task for background location (Android)
  if (!kIsWeb) {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'transgo_location_channel',
        channelName: 'Lokasi Transgo',
        channelDescription: 'Mengirim lokasi untuk peta dashboard',
      ),
      iosNotificationOptions: IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(45000), // 45 seconds
      ),
    );
    FlutterForegroundTask.setTaskHandler(LocationTrackingTaskHandler());
    FlutterForegroundTask.initCommunicationPort();
  }

  runApp(
    LocationTrackingAppWrapper(
      initialRoute: loggedIn ? AppPages.DEFAULT : AppPages.INITIAL,
    ),
  );
}

/// Wraps the app and starts location tracking when app resumes (e.g. from background)
/// so the 45s interval runs whenever the app is open or user returns to it.
class LocationTrackingAppWrapper extends StatefulWidget {
  final String initialRoute;

  const LocationTrackingAppWrapper({super.key, required this.initialRoute});

  @override
  State<LocationTrackingAppWrapper> createState() => _LocationTrackingAppWrapperState();
}

class _LocationTrackingAppWrapperState extends State<LocationTrackingAppWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        GlobalVariables.token.value.isNotEmpty) {
      LocationTrackingService.instance.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyApp(initialRoute: widget.initialRoute);
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final app = GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      locale: const Locale('id', 'ID'),
      supportedLocales: const [
        Locale('id', 'ID'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      builder: (context, child) {
        return UpgradeAlert(
          upgrader: upgrader,
          navigatorKey: navigatorKey,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    return kIsWeb ? app : WithForegroundTask(child: app);
  }
}
