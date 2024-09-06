import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnent/presentation/pages/home_screen.dart';

// TODO: this page is not used anywhere but meant to be used ti handle notifications on "New Order Received"
class AcceptRejectOrderScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const AcceptRejectOrderScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final String orderId = order['orderId'] ?? 'Unknown';
    Future<void> _handleOrder(BuildContext context, bool accept) async {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('Orders')
            .where('orderId', isEqualTo: orderId)
            .get();

        if (querySnapshot.docs.isEmpty) {
          throw Exception('Order not found');
        }

        final doc = querySnapshot.docs.first;
        final status = accept ? 'accepted' : 'cancelled';
        final message = accept
            ? 'Order accepted by store owner'
            : 'Order rejected by store owner';

        await doc.reference.update({
          'status.$status': {
            'timestamp': FieldValue.serverTimestamp(),
            'message': message,
          },
        });

        if (accept) {
          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 10,
              channelKey: 'store_order_channel',
              title: 'Order Accepted',
              body: 'You have accepted order #$orderId',
            ),
          );
        } else {
          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 11,
              channelKey: 'store_order_channel',
              title: 'Order Declined',
              body: 'You have declined order #$orderId',
            ),
          );
        }

        Get.offAll(() => HomeScreen());
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Order #${orderId}')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Accept or Reject Order #${orderId}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _handleOrder(context, true),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Accept'),
                ),
                ElevatedButton(
                  onPressed: () => _handleOrder(context, false),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
