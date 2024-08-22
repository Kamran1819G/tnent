import 'dart:typed_data';

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
            channelKey: 'default_channel',
            channelName: 'Default Channel',
            channelDescription: 'This is the default channel',
            playSound: true,
            defaultColor: const Color(0xFF9D50DD),
            ledColor: const Color(0xFF9D50DD),
            importance: NotificationImportance.High,
            channelShowBadge: true,
          ),

          // Store Notifications Channels
          NotificationChannel(
            channelKey: 'store_new_order_channel',
            channelName: 'New Orders',
            channelGroupKey: 'store_channel_group',
            channelDescription: 'New order notifications for store owners',
            playSound: true,
            enableVibration: true,
            defaultColor: const Color(0xFF9D50DD),
            ledColor: const Color(0xFF9D50DD),
            importance: NotificationImportance.Max,
            channelShowBadge: true,
          ),

          NotificationChannel(
            channelKey: 'store_order_channel',
            channelName: 'Communication for store orders',
            channelGroupKey: 'store_channel_group',
            channelDescription: 'Notification channel for store notifications',
            playSound: true,
            enableVibration: true,
            vibrationPattern: Int64List(400),
            defaultColor: const Color(0xFF9D50DD),
            ledColor: const Color(0xFF9D50DD),
            importance: NotificationImportance.High,
            channelShowBadge: true,
          ),

          NotificationChannel(
            channelKey: 'store_new_follower',
            channelName: 'New Followers',
            channelGroupKey: 'store_channel_group',
            channelDescription: 'Notification channel for store notifications',
            playSound: true,
            defaultColor: const Color(0xFF9D50DD),
            ledColor: const Color(0xFF9D50DD),
            importance: NotificationImportance.High,
            channelShowBadge: true,
          ),

          // User Notifications Channels
          NotificationChannel(
            channelKey: 'user_order_channel',
            channelName: 'Communication for your orders',
            channelDescription: 'Order Status, Payments, Status, etc.',
            channelGroupKey: 'user_channel_group',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: const Color(0xFF9D50DD),
            importance: NotificationImportance.High,
            channelShowBadge: true,
          ),
          NotificationChannel(
            channelKey: 'help_support_channel',
            channelName: 'Help & Support',
            channelDescription: 'Notification channel for help & support',
            channelGroupKey: 'help_support_channel_group',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: const Color(0xFF9D50DD),
            importance: NotificationImportance.High,
            channelShowBadge: true,
          )
        ], channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'user_channel_group',
        channelGroupName: 'User Notifications',
      ),
      NotificationChannelGroup(
        channelGroupKey: 'store_channel_group',
        channelGroupName: 'Store Notifications',
      ),
      NotificationChannelGroup(
        channelGroupKey: 'help_support_channel_group',
        channelGroupName: 'Help & Support',
      ),
    ]);

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

    // Get the channel key from the message data, or use a default
    final String channelKey = message.data['channelKey'] ?? 'default_channel';

    // Display the notification using Awesome Notifications
    if (channelKey == 'store_new_order_channel') {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: message.hashCode, // Unique ID for the notification
          channelKey: channelKey, // Change as per your requirement
          autoDismissible: false,
          title: message.notification?.title,
          body: message.notification?.body,
          fullScreenIntent: true,
          wakeUpScreen: true,
          notificationLayout: NotificationLayout.Default,
          payload: {
            'orderId': message.data['orderId'],
          },
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'accept',
            label: 'Accept',
          ),
          NotificationActionButton(
            key: 'decline',
            label: 'Decline',
            isDangerousOption: true,
          ),
        ],
      );
    } else {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: message.hashCode, // Unique ID for the notification
          channelKey: channelKey, // Change as per your requirement
          title: message.notification?.title,
          body: message.notification?.body,
        ),
      );
    }
  }

  static Future<void> _acceptOrder(String orderId) async {
    try {
      // Find the document with the given orderId
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .where('orderId', isEqualTo: orderId)
          .get();

      // Update each document found (assuming orderId is unique)
      for (final doc in querySnapshot.docs) {
        await doc.reference.update({
          'status': {
            'Accepted': {
              'timestamp': FieldValue.serverTimestamp(),
              'message': 'Order accepted by store owner',
            }
          },
        });
      }
    } catch (e) {
      debugPrint('Error accepting order: $e');
    }
  }

  static Future<void> _rejectOrder(String orderId) async {
    try {
      // Find the document with the given orderId
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .where('orderId', isEqualTo: orderId)
          .get();

      // Update each document found (assuming orderId is unique)
      for (final doc in querySnapshot.docs) {
        await doc.reference.update({
          'status': {
            'Rejected': {
              'timestamp': FieldValue.serverTimestamp(),
              'message': 'Order rejected by store owner',
            }
          },
        });
      }
    } catch (e) {
      debugPrint('Error accepting order: $e');
    }
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
    if (receivedAction.buttonKeyPressed == 'accept') {
      final orderId = receivedAction.payload?['orderId'];
      if (orderId != null) {
        await _acceptOrder(orderId);
      }
    } else if (receivedAction.buttonKeyPressed == 'reject') {
      final orderId = receivedAction.payload?['orderId'];
      if (orderId != null) {
        await _rejectOrder(orderId);
      }
    }
    // You can navigate to a specific screen based on the notification action here
  }
}
