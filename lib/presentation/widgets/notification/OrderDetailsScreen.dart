import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  final String storeId;

  OrderDetailsScreen({required this.orderId, required this.storeId});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Map<String, dynamic>? _orderDetails;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    final orderDoc = await FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.orderId)
        .get();
    if (orderDoc.exists) {
      setState(() {
        _orderDetails = orderDoc.data();
      });
    } else {
      // Handle the case where the order document doesn't exist
      showSnackBar(context, 'Order not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_orderDetails == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${_orderDetails!['orderId']}'),
            SizedBox(height: 16.0),
            Image.network(_orderDetails!['productImage']),
            SizedBox(height: 16.0),
            Text('Product Name: ${_orderDetails!['productName']}'),
            SizedBox(height: 8.0),
            Text('Quantity: ${_orderDetails!['quantity']}'),
            SizedBox(height: 8.0),
            Text('Price: \$${_orderDetails!['priceDetails']['price']}'),
            SizedBox(height: 16.0),
            Text('Order Status: ${_orderDetails!['status'].keys.first}'),
          ],
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}