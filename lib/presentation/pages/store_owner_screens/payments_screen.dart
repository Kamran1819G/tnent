import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../core/helpers/color_utils.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  String selectedPeriod = DateFormat('MMMM').format(DateTime.now());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Stream<QuerySnapshot> _ordersStream;
  Map<String, double> monthlyEarnings = {};
  String upiId = '';
  String? storeId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStoreIdAndUpiId();
    _initializeOrdersStream();
  }

  Future<void> _fetchStoreIdAndUpiId() async {
    try {
      final userDoc = await _firestore.collection('Users').doc(_auth.currentUser!.uid).get();
      final fetchedStoreId = userDoc.data()?['storeId'];

      if (fetchedStoreId != null) {
        final storeDoc = await _firestore.collection('Stores').doc(fetchedStoreId).get();
        setState(() {
          storeId = fetchedStoreId;
          upiId = storeDoc.data()?['upiId'] ?? '';
          isLoading = false;
        });
        _initializeOrdersStream();
      } else {
        print('No storeId found for this user');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching store ID and UPI ID: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _initializeOrdersStream() {
    _ordersStream = _firestore
        .collection('Orders')
        .where('storeId', isEqualTo: storeId)
        .snapshots();
  }

  double calculateMonthlyEarning(List<QueryDocumentSnapshot> orders, String month) {
    return orders
        .where((order) {
      var orderAt = order['orderAt'] as Timestamp;
      var deliveredStatus = (order['status'] as Map<String, dynamic>)['delivered'];
      return DateFormat('MMMM').format(orderAt.toDate()) == month && deliveredStatus != null;
    })
        .map((order) => order['priceDetails']['price'] as double)
        .fold(0, (sum, price) => sum + price);
  }

  Future<void> updateEarningsCollection(Map<String, double> earnings) async {
    if (storeId == null) return;

    final earningsRef = _firestore.collection('Stores').doc(storeId).collection('earnings');

    final batch = _firestore.batch();

    earnings.forEach((month, amount) {
      final docRef = earningsRef.doc(month);
      batch.set(docRef, {
        'amount': amount,
        'year': DateTime.now().year,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });

    await batch.commit();
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Payments'.toUpperCase(),
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
                              color: hexToColor('#42FF00'),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'My Earnings',
                        style: TextStyle(
                          color: hexToColor('#9C9C9C'),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gotham',
                          fontSize: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.grey[100],
                      ),
                      shape: MaterialStateProperty.all(
                        CircleBorder(),
                      ),
                    ),
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 105.h,
              width: 610.w,
              margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 30.w),
              padding: EdgeInsets.only(left: 12.w),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: hexToColor('#F5F5F5'),
                borderRadius: BorderRadius.circular(26.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 90.h,
                    width: 90.w,
                    decoration: BoxDecoration(
                      color: hexToColor('#FFFFFF'),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Icon(Icons.credit_card_rounded,
                        color: hexToColor('#1E1E1E')),
                  ),
                  SizedBox(width: 20.w),
                  Text(
                    'UPI ID:',
                    style: TextStyle(
                      color: hexToColor('#272822'),
                      fontFamily: 'Poppins',
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    upiId.isNotEmpty ? upiId : 'Not available',
                    style: TextStyle(
                      color: hexToColor('#838383'),
                      fontFamily: 'Gotham',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 50.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Earning',
                        style: TextStyle(
                          color: hexToColor('#838383'),
                          fontSize: 24.sp,
                        ),
                      ),
                      Text(
                        '₹${monthlyEarnings[selectedPeriod]?.toStringAsFixed(2) ?? '0.00'}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 24.sp,
                          height: 1.5,
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: hexToColor('#AFAFAF'),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: DropdownButton<String>(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      style: TextStyle(
                        color: hexToColor('#272822'),
                        fontFamily: 'Gotham Black',
                        fontSize: 20.sp,
                      ),
                      icon: Icon(Icons.keyboard_arrow_down_rounded),
                      underline: SizedBox(),
                      value: selectedPeriod,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPeriod = newValue!;
                        });
                      },
                      items: <String>[
                        'January', 'February', 'March', 'April', 'May', 'June',
                        'July', 'August', 'September', 'October', 'November', 'December',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _ordersStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final orders = snapshot.data!.docs;

                  // Calculate monthly earnings
                  monthlyEarnings.clear();
                  for (var month in ['January', 'February', 'March', 'April', 'May', 'June',
                    'July', 'August', 'September', 'October', 'November', 'December']) {
                    monthlyEarnings[month] = calculateMonthlyEarning(orders, month);
                  }


                  // Update earnings collection in Firebase
                  updateEarningsCollection(monthlyEarnings);


                  // Filter orders for the selected month and delivered status
                  final filteredOrders = orders.where((order) {
                    var orderAt = order['orderAt'] as Timestamp;
                    var deliveredStatus = (order['status'] as Map<String, dynamic>)['delivered'];
                    return DateFormat('MMMM').format(orderAt.toDate()) == selectedPeriod && deliveredStatus != null;
                  }).toList();

                  return ListView.separated(
                    itemCount: filteredOrders.length,
                    separatorBuilder: (context, index) => SizedBox(height: 20.h),
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return PaymentInfoTile(order: order);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PaymentInfoTile extends StatelessWidget {
  final QueryDocumentSnapshot order;

  const PaymentInfoTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final orderDate = (order['orderAt'] as Timestamp).toDate();
    final paymentMethod = order['payment']['method'] as String;
    final amount = order['priceDetails']['price'] as double;
    final deliveredStatus = (order['status'] as Map<String, dynamic>)['delivered'];
    final deliveryDate = deliveredStatus != null
        ? (deliveredStatus['timestamp'] as Timestamp).toDate()
        : null;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Order ID:',
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    order['orderId'],
                    style: TextStyle(
                      color: hexToColor('#747474'),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              Text(
                deliveryDate != null
                    ? DateFormat('MMM d, yyyy, HH:mm a').format(deliveryDate)
                    : 'Not delivered yet',
                style: TextStyle(
                  color: hexToColor('#747474'),
                  fontFamily: 'Poppins',
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 40.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Payment Mode:',
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 17.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    paymentMethod,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              Text(
                '₹ ${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 32.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}