import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  final String storeId;

  const OrderDetailsScreen({Key? key, required this.orderId, required this.storeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Orders').doc(orderId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final orderData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order ID: $orderId', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Status: ${orderData['status']}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Text('Items:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                // Add more order details here
                Expanded(
                  child: ListView.builder(
                    itemCount: orderData['items'].length,
                    itemBuilder: (context, index) {
                      final item = orderData['items'][index];
                      return ListTile(
                        title: Text(item['productName']),
                        subtitle: Text('Quantity: ${item['quantity']}'),
                        trailing: Text('\$${item['price']}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}