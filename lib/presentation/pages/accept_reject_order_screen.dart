import 'package:flutter/material.dart';

// TODO: this page is not used anywhere but meant to be used ti handle notifications on "New Order Received"
class AcceptRejectOrderScreen extends StatelessWidget {
  final String orderId;

  const AcceptRejectOrderScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    // Build the UI for accepting/rejecting the order using the orderId
    return Scaffold(
      appBar: AppBar(title: Text('Order #$orderId')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Accept or Reject Order #$orderId'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle order acceptance
                  },
                  child: const Text('Accept'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Handle order rejection
                  },
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
