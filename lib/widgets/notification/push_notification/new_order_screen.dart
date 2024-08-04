import 'package:flutter/material.dart';
import 'package:tnent/widgets/notification/push_notification/push_notification_service.dart';
import 'package:tnent/widgets/notification/push_notification/push_notification_service.dart';
import '../../../models/store_order.dart';
import 'package:tnent/widgets/notification/push_notification/firebase_service.dart';

import 'firebase_service.dart';


class NewOrderScreen extends StatelessWidget {
  final StoreOrder order;

  NewOrderScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Order')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('New order received: #${order.id}'),
            SizedBox(height: 20),
            Text('Total: \$${order.total.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _handleOrder(context, true),
                  child: Text('Accept'),
                ),
                ElevatedButton(
                  onPressed: () => _handleOrder(context, false),
                  child: Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleOrder(BuildContext context, bool accepted) async {
    await FirebaseService().updateOrderStatus(order.id, accepted ? 'accepted' : 'rejected');
    PushNotificationService().cancelNotification(0);
    Navigator.of(context).pop();
  }
}