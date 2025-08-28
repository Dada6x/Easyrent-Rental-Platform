import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  static final NotificationsService _instance =
      NotificationsService._internal();

  factory NotificationsService() => _instance;

  NotificationsService._internal();

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  //! Initialize Notifications
  Future<void> initNotification() async {
    if (_isInitialized) return;

    // Android Initialization
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings initSettings =
        InitializationSettings(android: initSettingsAndroid);

    await notificationsPlugin.initialize(initSettings);
    _isInitialized = true;
  }

  //! Notification Details Setup
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription:
            'This channel handles daily scheduled notifications.',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        ongoing: false,
        autoCancel: true,
        visibility: NotificationVisibility.public,
      ),
    );
  }

  //! Show Instant Notification
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    await notificationsPlugin.show(id, title, body, notificationDetails());
  }
}



