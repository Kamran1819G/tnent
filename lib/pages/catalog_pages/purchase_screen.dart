import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      total += (order['priceDetails']['price'] as num).toDouble() *
          (order['quantity'] as num).toDouble();
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
              height: 100.h,
              margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Purchase'.toUpperCase(),
                        style: TextStyle(
                          color: hexToColor('#1E1E1E'),
                          fontSize: 35.sp,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        ' •',
                        style: TextStyle(
                          fontSize: 35.sp,
                          color: hexToColor('#FF0000'),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.grey[100],
                      ),
                      shape: MaterialStateProperty.all(
                        const CircleBorder(),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              height: 100.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 24.sp,
                    ),
                  ),
                  Text(
                    '₹ ${_totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: hexToColor('#A9A9A9'),
                      fontSize: 26.sp,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _ordersStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final orders = snapshot.data!.docs;

                  // Calculate the total amount in a microtask
                  Future.microtask(() => _calculateTotalAmount(orders));

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order =
                          orders[index].data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: PurchaseItemTile(
                          order: order,
                        ),
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
      height: 285.h,
      margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 18.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 285.h,
            width: 255.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              image: widget.order['productImage'] != null
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(
                          widget.order['productImage']),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: widget.order['productImage'] == null
                ? Center(
                    child: Icon(Icons.image_not_supported,
                        size: 50.sp, color: Colors.grey))
                : null,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.order['productName'],
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 26.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Variation: ${widget.order['variation']}',
                  style: TextStyle(
                    color: hexToColor('#A9A9A9'),
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Quantity: ${widget.order['quantity']}',
                  style: TextStyle(
                    color: hexToColor('#A9A9A9'),
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 40.h),
                Text(
                  '₹${(widget.order['priceDetails']['price'] * widget.order['quantity']).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 28.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: Row(
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
                          height: 50.h,
                          width: 105.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: hexToColor('#343434')),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Text(
                            'Details',
                            style: TextStyle(
                              color: hexToColor('#737373'),
                              fontSize: 17.sp,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
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
                          height: 50.h,
                          width: 150.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: hexToColor('#343434'),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Text(
                            'Track Order',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
