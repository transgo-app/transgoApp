import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'app/routes/app_pages.dart';
import 'package:intl/date_symbol_data_local.dart';
import './app/data/data.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

  bool loggedIn = await GlobalVariables().isLoggedIn();
  await initializeDateFormatting('id_ID', null);
  await GlobalVariables.initializeData();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (kIsWeb) {
    Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyDPZWOTBBZpDDExpo4Z4ew3oOtK6a9To7s',
            appId: '1:1022276810838:android:13e9e87a3cc417575763f7',
            messagingSenderId: '1022276810838',
            projectId: 'transgo-app'));
  } else {
    await Firebase.initializeApp();
  }
  await FirebaseApi().init();

  String initialRoute = loggedIn ? AppPages.DEFAULT : AppPages.INITIAL;
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    ),
  );
}
