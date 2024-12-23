import 'dart:typed_data';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnent/presentation/pages/accept_reject_order_screen.dart';
import 'package:tnent/presentation/pages/catalog_pages/detail_screen.dart';

class NotificationController {
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
            defaultRingtoneType: DefaultRingtoneType.Ringtone,
            enableVibration: true,
            enableLights: true,
            playSound: true,
            defaultColor: const Color(0xFF9D50DD),
            ledColor: const Color(0xFF9D50DD),
            importance: NotificationImportance.Max,
            criticalAlerts: true,
            channelShowBadge: true,
            onlyAlertOnce: false,
            locked: true,
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
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
    );
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _storeFcmToken(token);
    }

    // Set up message handlers
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleBackgroundMessage(message);
    });
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleInitialMessage(initialMessage);
    }
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Handling a foreground message: ${message.messageId}');
    _showNotification(message);
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    debugPrint('Handling a background message: ${message.messageId}');
    _navigateBasedOnMessage(message);
  }

  static Future<void> _handleInitialMessage(RemoteMessage message) async {
    debugPrint('Handling initial message: ${message.messageId}');
    _navigateBasedOnMessage(message);
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

  static Future<void> _showNotification(RemoteMessage message) async {
    debugPrint('Handling a message: ${message.messageId}');

    // Get the channel key from the message data, or use a default
    final String channelKey = message.data['channelKey'] ?? 'default_channel';

    // Display the notification using Awesome Notifications
    if (channelKey == 'store_new_order_channel') {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: message.hashCode, // Unique ID for the notification
          channelKey: channelKey, // Change as per your requirement
          title: message.notification?.title,
          body: message.notification?.body,
          category: NotificationCategory.Call,
          wakeUpScreen: true,
          fullScreenIntent: true,
          autoDismissible: false,
          criticalAlert: true,
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
          'status.accepted': {
            'timestamp': FieldValue.serverTimestamp(),
            'message': 'Order accepted by store owner',
          },
        });
      }
    } catch (e) {
      debugPrint('Error accepting order: $e');
    }
  }

  static Future<void> _declineOrder(String orderId) async {
    try {
      // Find the document with the given orderId
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .where('orderId', isEqualTo: orderId)
          .get();

      // Update each document found (assuming orderId is unique)
      for (final doc in querySnapshot.docs) {
        await doc.reference.update({
          'status.cancelled': {
            'timestamp': FieldValue.serverTimestamp(),
            'message': 'Order rejected by store owner',
          },
        });
      }
    } catch (e) {
      debugPrint('Error accepting order: $e');
    }
  }

  static Future<void> _fetchOrderAndNavigate(String orderId) async {
    try {
      final orderDoc = await FirebaseFirestore.instance
          .collection('Orders')
          .where('orderId', isEqualTo: orderId)
          .get();

      if (orderDoc.docs.isNotEmpty) {
        final orderData = orderDoc.docs.first.data();
        Get.to(() => DetailScreen(order: orderData));
      }
    } catch (e) {
      print("Failed to fetch order");
    }
  }

  static void _navigateBasedOnMessage(RemoteMessage message) {
    final String channelKey = message.data['channelKey'] ?? 'default_channel';
    final String? orderId = message.data['orderId'];

    if (channelKey == 'store_new_order_channel' && orderId != null) {
      _navigateToAcceptRejectScreen(orderId);
    } else if (channelKey == 'user_order_channel' && orderId != null) {
      _fetchOrderAndNavigate(orderId);
    }
  }

  static Future<void> _navigateToAcceptRejectScreen(String orderId) async {
    try {
      final orderDoc = await FirebaseFirestore.instance
          .collection('Orders')
          .where('orderId', isEqualTo: orderId)
          .get();

      if (orderDoc.docs.isNotEmpty) {
        final orderData = orderDoc.docs.first.data();
        Get.to(() => AcceptRejectOrderScreen(item: orderData));
      }
    } catch (e) {
      print("Failed to fetch order");
    }
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    await initialize();
    await _handleBackgroundMessage(message);
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
    if (receivedAction.channelKey == 'store_new_order_channel') {
      final orderId = receivedAction.payload?['orderId'];
      if (orderId != null) {
        if (receivedAction.buttonKeyPressed == 'accept') {
          await _acceptOrder(orderId);
          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: receivedAction.id! + 1,
              channelKey: 'store_order_channel',
              title: 'Order Accepted',
              body: 'You have accepted order #$orderId',
            ),
          );
        } else if (receivedAction.buttonKeyPressed == 'decline') {
          await _declineOrder(orderId);
          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: receivedAction.id! + 1,
              channelKey: 'store_order_channel',
              title: 'Order Declined',
              body: 'You have declined order #$orderId',
            ),
          );
        } else {
          await _navigateToAcceptRejectScreen(orderId);
        }
      }
    }

    if (receivedAction.channelKey == 'user_order_channel') {
      final orderId = receivedAction.payload?['orderId'];

      if (orderId != null) {
        _fetchOrderAndNavigate(orderId);
      }
    }
    // Dismiss the notification
    await AwesomeNotifications().cancel(receivedAction.id!);
  }
}
