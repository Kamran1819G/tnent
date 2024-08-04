import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null, // null means it will use the default app icon
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel for basic notifications',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: const Color(0xFF9D50DD),
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
        NotificationChannel(
          channelKey: 'order_channel',
          channelName: 'Order Notifications',
          channelDescription: 'Notification channel for order notifications',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: const Color(0xFF9D50DD),
          importance: NotificationImportance.High,
          channelShowBadge: true,
        )
      ],
    );

    // Set up notification handlers
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );

    // Request FCM token on app start
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _storeFcmToken(token);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });
  }

  static Future<void> _storeFcmToken(String token) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('Users').doc(user.uid).update({
        'fcmToken': token,
        'fcmTokenLastUpdated': FieldValue.serverTimestamp(),
      });
    } else {
      // If the user is not logged in, store the token temporarily
      // You might want to use shared preferences or secure storage for this
      debugPrint('User not logged in. Storing FCM token temporarily.');
      // TODO: Implement temporary storage
    }
  }

  static Future<void> onUserLogin() async {
    // Call this method when a user logs in
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _storeFcmToken(token);
    }
  }

  static Future<void> onUserLogout() async {
    // Call this method when a user logs out
    final User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('Users').doc(user.uid).update({
        'fcmToken': FieldValue.delete(),
        'fcmTokenLastUpdated': FieldValue.delete(),
      });
    }
  }

  static Future<String?> getStoredFcmToken(String userId) async {
    final DocumentSnapshot doc =
        await _firestore.collection('Users').doc(userId).get();
    return doc.get('fcmToken') as String?;
  }

  static Future<void> _handleMessage(RemoteMessage message) async {
    debugPrint('Handling a message: ${message.messageId}');
    // Process the message and show a notification
    AwesomeNotifications().createNotificationFromJsonData(message.data);
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
    debugPrint('Notification created: ${receivedNotification.title}');
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
    debugPrint('Notification displayed: ${receivedNotification.title}');
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
    debugPrint('Notification dismissed: ${receivedAction.title}');
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
    debugPrint('Notification action received: ${receivedAction.title}');
    // You can navigate to a specific screen based on the notification action here
  }
}
