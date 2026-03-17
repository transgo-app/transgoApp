import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/data/helper/AppPrefs.dart';
import 'package:get/get.dart';
import 'package:transgomobileapp/app/data/globalvariables.dart';
import 'package:transgomobileapp/app/routes/app_pages.dart';

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

      final prefs = await getAppPrefs();

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
    final iOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final settings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

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

  static void _onNotificationTap(NotificationResponse response) {
    if (response.payload == 'email_verification_reminder') {
      try {
        Get.offAllNamed(Routes.DEFAULT, arguments: 3);
      } catch (_) {}
    }
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
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond, 
      title, 
      body, 
      notificationDetails,
    );
  }

  /// Notification id used for the "email belum diverifikasi" reminder.
  static const int emailVerificationReminderId = 9999;

  /// Schedules a one-time local notification in 24 hours reminding user to verify email.
  /// When tapped, app opens to profile tab. Call only when user is logged in and email not verified.
  Future<void> scheduleEmailVerificationReminder() async {
    try {
      await flutterLocalNotificationsPlugin.cancel(emailVerificationReminderId);
      final when = tz.TZDateTime.now(tz.local).add(const Duration(hours: 24));
      const title = 'Email Anda belum diverifikasi';
      const body = 'Verifikasi email untuk pengalaman lebih baik. Ketuk untuk buka Profil.';
      const payload = 'email_verification_reminder';

      final androidDetails = AndroidNotificationDetails(
        'channel1',
        'channel1',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );
      final details = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        emailVerificationReminderId,
        title,
        body,
        when,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
      );
    } catch (e) {
      print('Error scheduling email verification reminder: $e');
    }
  }
}