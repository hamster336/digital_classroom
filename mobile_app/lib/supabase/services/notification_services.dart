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
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    _listenToForegroundMessages();
    _listenToBackgroundTap();
  }

  void _listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;

      if (notification != null) {
        _plugin.show(
          id: message.hashCode, // unique id instead of 0
          title: notification.title,
          body: notification.body,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'assignment_reminders', // meaningful channel name
              'Assignment Reminders',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          payload: message.data['assignment_id'], // pass assignment id
        );
      }
    });
  }

  void _listenToBackgroundTap() {
    // When user taps notification and app was completely closed
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationTap(
          NotificationResponse(
            payload: message.data['assignment_id'],
            notificationResponseType:
                NotificationResponseType.selectedNotification,
          ),
        );
      }
    });

    // When user taps notification and app was in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationTap(
        NotificationResponse(
          payload: message.data['assignment_id'],
          notificationResponseType:
              NotificationResponseType.selectedNotification,
        ),
      );
    });
  }

  Future<void> _handleNotificationTap(NotificationResponse response) async {
    final assignmentId = response.payload;

    if (assignmentId != null && assignmentId.isNotEmpty) {
      print('Navigating to assignment: $assignmentId');
    }
  }
}
