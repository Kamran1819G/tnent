import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:tnennt/widgets/notification/order_update_notification.dart';
import 'package:tnennt/widgets/notification/store_connection_notification.dart';

import '../helpers/color_utils.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  // Store the notification
  await _storeNotification(message);
}

Future<void> _storeNotification(RemoteMessage message) async {
  final firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId != null) {
    await firestore.collection('Users').doc(userId).collection('notifications').add({
      'title': message.notification?.title,
      'body': message.notification?.body,
      'data': message.data,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isStoreOwner = true;
  int _selectedIndex = 0;
  Map<String, List<QueryDocumentSnapshot>> groupedGeneralNotifications = {};
  Map<String, List<QueryDocumentSnapshot>> groupedStoreNotifications = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: isStoreOwner ? 2 : 1, vsync: this);
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final firestore = FirebaseFirestore.instance;
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshots = await firestore
          .collection('Users')
          .doc(userId)
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .get();

      groupedGeneralNotifications = _groupNotifications(
          snapshots.docs.where((doc) => doc.data()['data']['type'] != 'store').toList()
      );
      groupedStoreNotifications = _groupNotifications(
          snapshots.docs.where((doc) => doc.data()['data']['type'] == 'store').toList()
      );

      setState(() {});
    }
  }

  Map<String, List<QueryDocumentSnapshot>> _groupNotifications(List<QueryDocumentSnapshot> notifications) {
    Map<String, List<QueryDocumentSnapshot>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));

    for (var notification in notifications) {
      final timestamp = (notification.data() as Map<String, dynamic>)['timestamp'] as Timestamp;
      final date = timestamp.toDate();
      final notificationDate = DateTime(date.year, date.month, date.day);

      String key;
      if (notificationDate == today) {
        key = 'Today';
      } else if (notificationDate == yesterday) {
        key = 'Yesterday';
      } else {
        key = DateFormat('d MMMM y').format(date);
      }

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(notification);
    }

    return grouped;
  }

  String _getTabLabel(int index) {
    switch (index) {
      case 0:
        return 'General';
      case 1:
        return 'Store';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 50.0),
          Container(
            height: 100,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Row(
                  children: [
                    Text(
                      'Update'.toUpperCase(),
                      style: TextStyle(
                        color: hexToColor('#1E1E1E'),
                        fontSize: 24.0,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      ' •',
                      style: TextStyle(
                        fontSize: 28.0,
                        color: hexToColor('#1770B5'),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 8.0),
            child: Wrap(
              children: List.generate(2, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: ChoiceChip(
                    label: Text(_getTabLabel(index)),
                    labelStyle: TextStyle(
                      fontSize: 12.0,
                      color: _selectedIndex == index
                          ? Colors.white
                          : hexToColor("#343434"),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                        color: hexToColor('#343434'),
                      ),
                    ),
                    showCheckmark: false,
                    selected: _selectedIndex == index,
                    selectedColor: Theme.of(context).primaryColor,
                    backgroundColor: Colors.white,
                    onSelected: (selected) {
                      setState(() {
                        _selectedIndex = index;
                        _tabController.index = index;
                      });
                    },
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildNotificationList(groupedGeneralNotifications, isGeneralTab: true),
                if (isStoreOwner)
                  _buildNotificationList(groupedStoreNotifications, isGeneralTab: false),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNotificationList(Map<String, List<QueryDocumentSnapshot>> groupedNotifications, {required bool isGeneralTab}) {
    return ListView.builder(
      itemCount: groupedNotifications.length,
      itemBuilder: (context, index) {
        final date = groupedNotifications.keys.elementAt(index);
        final notifications = groupedNotifications[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                date,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ...notifications.map((notification) {
              final data = notification.data() as Map<String, dynamic>;
              if (isGeneralTab) {
                return OrderUpdateNotification(
                  type: _getNotificationType(data['data']['status']),
                  productImage: data['data']['productImage'],
                  productName: data['data']['productName'],
                  price: double.parse(data['data']['price']),
                  orderId: data['data']['orderId'],
                  time: DateFormat('jm').format((data['timestamp'] as Timestamp).toDate()),
                );
              } else {
                return StoreConnectionNotification(
                  name: data['data']['name'],
                  image: data['data']['image'],
                  time: DateFormat('jm').format((data['timestamp'] as Timestamp).toDate()),
                );
              }
            }).toList(),
            SizedBox(height: 16),
          ],
        );
      },
    );
  }

  NotificationType _getNotificationType(String status) {
    switch (status) {
      case 'orderplaced':
        return NotificationType.orderplaced;
      case 'cancelled':
        return NotificationType.cancelled;
      case 'delivered':
        return NotificationType.delivered;
      case 'refunded':
        return NotificationType.refunded;
      default:
        return NotificationType.orderplaced;
    }
  }
}