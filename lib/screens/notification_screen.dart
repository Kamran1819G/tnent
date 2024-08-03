import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tnent/widgets/notification/order_update_notification.dart';
import 'package:tnent/widgets/notification/store_connection_notification.dart';

import '../helpers/color_utils.dart';

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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100.h,
                    margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.grey[100],
                            ),
                            shape: WidgetStateProperty.all(
                              CircleBorder(),
                            ),
                          ),
                          icon: Icon(Icons.arrow_back_ios_new,
                              color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:EdgeInsets.only(left: 12.w),
                    child: Wrap(
                      children: List.generate(2, (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 6.w),
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: ChoiceChip(
                            label: Text(_getTabLabel(index)),
                            labelStyle: TextStyle(
                              fontSize: 18.sp,
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
                  SizedBox(height: 50.h),
                ],
              ),
            ),
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
                style: TextStyle(fontSize: 20.sp),
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