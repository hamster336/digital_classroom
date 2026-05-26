import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings android = AndroidInitializationSettings(
      'ic_notification',
    );
    const settings = InitializationSettings(android: android);

    await _plugin.initialize(settings: settings);

    _listenToForegroundMessages();
    _listenToBackgroundTap();
  }

  void _listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;

      if (notification != null) {
        _plugin.show(
          id: message.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'assignment_reminders',
              'Assignment Reminders',
              icon: "ic_notification",
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          payload: message.data['assignment_id'],
        );
      }
    });
  }

  void _listenToBackgroundTap() {
    // When user taps notification and app was completely closed
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('Opened from terminated state');
      }
    });

    // When user taps notification and app was in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Opened from background');
    });
  }
}
