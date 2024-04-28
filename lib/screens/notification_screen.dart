import 'package:flutter/material.dart';
import 'package:tnennt/widgets/notification/order_update_notification.dart';
import 'package:tnennt/widgets/notification/store_connection_notification.dart';

import '../helpers/color_utils.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isStoreOwner = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: isStoreOwner ? 2 : 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20.0),
          Container(
            height: 100,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Row(
                  children: [
                    Text(
                      'Updates'.toUpperCase(),
                      style: TextStyle(
                        color: hexToColor('#1E1E1E'),
                        fontWeight: FontWeight.w900,
                        fontSize: 28.0,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      ' •',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              unselectedLabelColor: Colors.black,
              labelColor: Colors.white,
              indicator: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
              labelStyle: TextStyle(
                fontSize: 14.0,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              dividerColor: Colors.transparent,
              tabs: <Widget>[
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text("General")),
                if (isStoreOwner)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      "Store",
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: TabBarView(controller: _tabController, children: [
              ListView(
                children: [
                  OrderUpdateNotification(
                    type: NotificationType.orderplaced,
                    productImage: 'assets/sahachari_image.png',
                    productName: 'Nikon Camera',
                    price: 12000,
                    orderID: '123456',
                    time: '2024-04-24 10:00 AM',
                  ),
                  SizedBox(height: 16.0),
                  OrderUpdateNotification(
                    type: NotificationType.cancelled,
                    orderID: '123456',
                    time: '2024-04-24 10:00 AM',
                  ),
                  SizedBox(height: 16.0),
                  OrderUpdateNotification(
                    type: NotificationType.delivered,
                    name: 'Kamran Khan',
                    orderID: '789012',
                    time: '2024-04-23 3:00 PM',
                  ),
                  SizedBox(height: 16.0),
                  OrderUpdateNotification(
                    type: NotificationType.refunded, // or delivered
                    orderID: '345678',
                    time: '2024-04-22 12:00 PM',
                  ),
                ],
              ),
              if (isStoreOwner)
                ListView.separated(
                    itemBuilder: (context, index) =>
                        StoreConnectionNotification(
                            name: 'Kamran Khan',
                            image: 'assets/profile_image.png',
                            time: 'April 20, 2024, 12:45pm'),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 16.0),
                    itemCount: 5)
            ]),
          )
        ],
      ),
    );
  }
}
