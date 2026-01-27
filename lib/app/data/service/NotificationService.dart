import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/data/globalvariables.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    try {
      // Add timeout to prevent hanging - wrap in try-catch for timeout
      try {
        await _firebaseMessaging.requestPermission().timeout(
          const Duration(seconds: 10),
        );
      } catch (e) {
        print('Firebase permission request timeout or error: $e');
        // Continue even if permission request fails
      }
      
      try {
        await _initializeNotifications().timeout(
          const Duration(seconds: 5),
        );
      } catch (e) {
        print('Notification initialization timeout or error: $e');
        // Continue even if notification initialization fails
      }

      final prefs = await SharedPreferences.getInstance();
      
      // Add timeout for FCM token retrieval
      String? fcmToken;
      try {
        fcmToken = await _firebaseMessaging.getToken().timeout(
          const Duration(seconds: 10),
        );
      } catch (e) {
        print('FCM token retrieval timeout or error: $e');
        fcmToken = null;
      }
      
      await prefs.setString('fcmToken', fcmToken ?? 'Gaada');

      print("FCM Token: $fcmToken");
      GlobalVariables.fcmToken.value = fcmToken ?? '';

      // These operations are non-blocking, so they won't cause hanging
      _firebaseMessaging.subscribeToTopic('masyarakat');

      FirebaseMessaging.onMessage.listen(_handleMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } catch (e) {
      print('Error initializing Firebase: $e');
      // Don't rethrow - allow app to continue even if Firebase fails
    }
  }

  void _handleMessage(RemoteMessage message) {
    print("INI MESSAGE ${message.toMap()}");
    if (message.notification != null) {
      NotificationService().showNotification(
        title: message.notification!.title ?? '',
        body: message.notification!.body ?? '',
      );
    }
  }

  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOSSettings = DarwinInitializationSettings();

    final settings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(settings);

    const channel = AndroidNotificationChannel(
      'channel1',
      'channel1',
      description: 'This is channel 1 with sound1',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  FirebaseApi()._handleMessage(message);
}

class NotificationService {
  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'channel1',
      'channel1',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(body), 
      sound: null,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond, 
      title, 
      body, 
      notificationDetails,
    );
  }
}