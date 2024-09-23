import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tnent/core/helpers/snackbar_utils.dart';

import '../../core/helpers/color_utils.dart';
import '../../models/store_model.dart';
import 'home_screen.dart';

class AcceptRejectOrderScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const AcceptRejectOrderScreen({Key? key, required this.item})
      : super(key: key);

  @override
  State<AcceptRejectOrderScreen> createState() =>
      _AcceptRejectOrderScreenState();
}

class _AcceptRejectOrderScreenState extends State<AcceptRejectOrderScreen> {
  late StoreModel store;
  bool isLoading = true;
  bool isStoreOwnerAccepted = false; // New variable

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await _fetchStore();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchStore() async {
    final String storeId = widget.item['storeId'] ?? 'Unknown';
    final storeDoc = await FirebaseFirestore.instance
        .collection('Stores')
        .doc(storeId)
        .get();
    store = StoreModel.fromFirestore(storeDoc);
  }

  Future<void> _handleOrder(BuildContext context, bool accept) async {
    final String orderId = widget.item['orderId'] ?? 'Unknown';
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
        'isStoreOwnerAccepted': accept, // Add this line to update the new field
      });

      setState(() {
        isStoreOwnerAccepted = accept; // Update the state variable
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

      Get.offAll(() => const HomeScreen());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount =
        widget.item['priceDetails']['price'] * widget.item['quantity'];

    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildStoreSection(),
                          const SizedBox(height: 20),
                          _buildProductSection(),
                          Row(
                            children: [
                              StylizedCustomIllustration(
                                label: 'Optional: ',
                                value: widget.item['variation']
                                    .toString()
                                    .toUpperCase(),
                              ),
                              StylizedCustomIllustration(
                                label: 'Quantity: ',
                                value: widget.item['quantity'].toString(),
                              )
                            ],
                          ),
                          Card(
                            margin: EdgeInsets.all(24.w),
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Additional Notes: ',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    widget.item['note'] ?? 'N/A',
                                    style: const TextStyle(
                                        fontFamily: 'Poppins', fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildSummarySection(totalAmount),
                          const SizedBox(height: 20),
                          btn(() => _handleOrder(context, true), 'Accept Order',
                              isBlackBG: true),
                          const SizedBox(height: 20),
                          btn(() {
                            showSnackBarWithAction(
                              context,
                              text: "Do you want to reject this order?",
                              action: () => _handleOrder(context, false),
                              quickAlertType: QuickAlertType.warning,
                              confirmBtnColor: Colors.red,
                            );
                          }, 'Reject Order'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 100.h,
      margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          Row(
            children: [
              Text(
                'New order'.toUpperCase(),
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
        ],
      ),
    );
  }

  Widget _buildStoreSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            height: 80.h,
            width: 80.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              image: DecorationImage(
                image: NetworkImage(store.logoUrl),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                store.name,
                style: TextStyle(
                  color: hexToColor('#343434'),
                  fontSize: 25.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Row(children: [
                Image.asset(
                  'assets/icons/globe.png',
                  width: 14.w,
                ),
                SizedBox(width: 6.h),
                Text(
                  '${store.storeDomain}.tnent.com',
                  style: TextStyle(
                    color: hexToColor('#A9A9A9'),
                    fontSize: 14.sp,
                  ),
                ),
              ])
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection() {
    return ItemTile(item: widget.item);
  }

  Widget _buildSummarySection(double totalAmount) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: TextStyle(color: hexToColor('#343434'), fontSize: 24.sp),
          ),
          const SizedBox(height: 20.0),
          _buildItemSummary(widget.item),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.h),
            height: 1.h,
            color: hexToColor('#E3E3E3'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(color: hexToColor('#343434'), fontSize: 30.sp),
              ),
              Text(
                '₹ ${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(color: hexToColor('#343434'), fontSize: 30.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemSummary(Map<String, dynamic> item) {
    final price = item['priceDetails']?['price'] ?? 0.0;
    final quantity = item['quantity'] ?? 1;
    final totalPrice = price * quantity;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item['productName'],
            style: TextStyle(
              color: hexToColor('#B9B9B9'),
              fontFamily: 'Gotham',
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
            ),
          ),
          Text(
            '₹ ${totalPrice.toStringAsFixed(2)}',
            style: TextStyle(color: hexToColor('#606060'), fontSize: 18.sp),
          ),
        ],
      ),
    );
  }
}

Widget btn(VoidCallback onTap, String text, {bool isBlackBG = false}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 500.w,
      height: 100.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: isBlackBG ? hexToColor('#343434') : Colors.white,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
                fontSize: 23.sp,
                color: isBlackBG ? Colors.white : Colors.black,
                fontFamily: 'regular',
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}

class StylizedCustomIllustration extends StatelessWidget {
  final String label;
  final String value;

  const StylizedCustomIllustration({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Container(
          height: 63,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Colors.grey.shade100,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  final Map<String, dynamic> item;

  const ItemTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final priceDetails = item['priceDetails'] as Map<String, dynamic>? ?? {};
    final price = priceDetails['price']?.toString() ?? 'N/A';
    final mrp = priceDetails['mrp']?.toString() ?? 'N/A';
    final discount = priceDetails['discount'] ?? 0;

    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      margin: EdgeInsets.all(16.w),
      child: Container(
        width: 600.w,
        height: 250.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 185.h,
                  width: 165.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    image: DecorationImage(
                      image: NetworkImage(item['productImage']),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                SizedBox(
                  height: 185.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['productName'] ?? 'N/A',
                        style: TextStyle(
                            color: hexToColor('#343434'),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      if (item['variation'] != 'default') ...[
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: hexToColor('#D0D0D0')),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            item['variation'] ?? 'N/A',
                            style: TextStyle(
                                color: hexToColor('#222230'),
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp),
                          ),
                        ),
                      ],
                      SizedBox(height: 20.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹$price',
                            style: TextStyle(
                              color: hexToColor('#343434'),
                              fontSize: 34.sp,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'M.R.P ₹$mrp',
                                style: TextStyle(
                                  color: hexToColor('#B9B9B9'),
                                  fontSize: 16.sp,
                                  decoration: discount > 0
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  decorationColor: hexToColor('#B9B9B9'),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              if (discount > 0)
                                Text(
                                  '$discount% OFF',
                                  style: TextStyle(
                                    color: hexToColor('#FF0000'),
                                    fontSize: 16.sp,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
