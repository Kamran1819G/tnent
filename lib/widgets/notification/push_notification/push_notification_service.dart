import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import '../../../models/store_order.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _fcm.requestPermission();

    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    await _initializeLocalNotifications();
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    /*final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();*/
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
     /* iOS: initializationSettingsIOS,*/
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _handleMessage(RemoteMessage message) async {
    if (message.data['type'] == 'new_order') {
      StoreOrder order = StoreOrder.fromJson(message.data);
      _showNotification(order);
    }
  }

  void _showNotification(StoreOrder order) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'new_order_channel',
      'New Order Notifications',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
      playSound: true,
      ongoing: true,
      autoCancel: false,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'New Order',
      'Order #${order.id} received',
      platformChannelSpecifics,
      payload: order.id,
    );
  }

  void cancelNotification(int id) {
    _flutterLocalNotificationsPlugin.cancel(id);
  }
}