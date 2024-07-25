import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tnennt/pages/catalog_pages/track_order_screen.dart';
import '../../helpers/color_utils.dart';
import 'detail_screen.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  late Stream<QuerySnapshot> _ordersStream;
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _ordersStream = FirebaseFirestore.instance
          .collection('Orders')
          .where('userId', isEqualTo: user.uid)
          .snapshots();
    }
  }

  void _calculateTotalAmount(List<QueryDocumentSnapshot> orders) {
    double total = 0.0;
    for (var order in orders) {
      total += (order['priceDetails']['price'] as num).toDouble() * (order['quantity'] as num).toDouble();
    }
    setState(() {
      _totalAmount = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Purchase'.toUpperCase(),
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
                          color: hexToColor('#FF0000'),
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
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    '₹ ${_totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: hexToColor('#A9A9A9'),
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _ordersStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final orders = snapshot.data!.docs;

                  // Calculate the total amount in a microtask
                  Future.microtask(() => _calculateTotalAmount(orders));

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index].data() as Map<String, dynamic>;
                      return PurchaseItemTile(
                        order: order,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PurchaseItemTile extends StatefulWidget {
  final Map<String, dynamic> order;

  PurchaseItemTile({
    required this.order,
  });

  @override
  State<PurchaseItemTile> createState() => _PurchaseItemTileState();
}

class _PurchaseItemTileState extends State<PurchaseItemTile> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 190,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              image: DecorationImage(
                image: NetworkImage(widget.order['productImage']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.order['productName'],
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Variation: ${widget.order['variation']}',
                  style: TextStyle(
                    color: hexToColor('#A9A9A9'),
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Quantity: ${widget.order['quantity']}',
                  style: TextStyle(
                    color: hexToColor('#A9A9A9'),
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '₹${(widget.order['priceDetails']['price'] * widget.order['quantity']).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              order: widget.order,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: hexToColor('#343434')),
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Text(
                          'Details',
                          style: TextStyle(
                            color: hexToColor('#737373'),
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrackOrderScreen(
                              order: widget.order,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: hexToColor('#343434'),
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Text(
                          'Track Order',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}