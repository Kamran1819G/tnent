import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tnent/core/helpers/color_utils.dart';
import 'package:tnent/models/product_model.dart';
import 'package:tnent/presentation/pages/product_detail_screen.dart';

class TrackOrderScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const TrackOrderScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildOrderDetails(),
            SizedBox(height: 50.0),
            _buildOrderStatus(context),
            Spacer(),
            if (order['providedMiddleman'] != null &&
                order['providedMiddleman'].isNotEmpty)
              _buildProvidedMiddlemen(),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 100.h,
      margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          Row(
            children: [
              Text(
                'Track Order'.toUpperCase(),
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
    );
  }

  Widget _buildOrderDetails() {
    return GestureDetector(
      onTap: () => _fetchProductAndNavigate(order['productId']),
      child: Container(
        height: 175.h,
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: 175.h,
              width: 165.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                image: DecorationImage(
                  image: NetworkImage(order['productImage']),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order['productName'],
                  style:
                      TextStyle(color: hexToColor('#343434'), fontSize: 24.sp),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Text(
                      'Order ID:',
                      style: TextStyle(
                          color: hexToColor('#878787'), fontSize: 17.sp),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      order['orderId'],
                      style: TextStyle(
                          color: hexToColor('#A9A9A9'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 17.sp),
                    ),
                  ],
                ),
                SizedBox(height: 60.h),
                Text(
                  '₹ ${order['priceDetails']['price']}',
                  style:
                      TextStyle(color: hexToColor('#343434'), fontSize: 22.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatus(BuildContext context) {
    List<OrderStatus> statuses = [];

    order['status'].forEach((key, value) {
      statuses.add(OrderStatus(
        title: key.substring(0, 1).toUpperCase() + key.substring(1),
        description: value['message'] ?? '',
        time: _formatTimestamp(value['timestamp']),
      ));
    });

    return OrderStatusWidget(status: statuses);
  }

  Widget _buildProvidedMiddlemen() {
    final middleman = order['providedMiddleman'];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Provided Middlemen:',
                style: TextStyle(color: hexToColor('#343434'), fontSize: 24.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                middleman['name'] ?? 'Not assigned yet',
                style: TextStyle(
                    color: hexToColor('#727272'),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp),
              ),
              SizedBox(height: 2.h),
              if (middleman['phone'] != null)
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: hexToColor('#727272'),
                      size: 20.sp,
                    ),
                    Text(
                      middleman['phone'],
                      style: TextStyle(
                          color: hexToColor('#727272'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp),
                    ),
                  ],
                ),
            ],
          ),
          Spacer(),
          Container(
            width: 70.w,
            height: 70.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.r),
              image: DecorationImage(
                image: NetworkImage(middleman['photo'] ?? ''),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';
    // Implement your timestamp formatting logic here
    return DateFormat('jm')
        .format((timestamp as Timestamp).toDate()); // Placeholder
  }
}

Future<void> _fetchProductAndNavigate(String productId) async {
  try {
    final DocumentSnapshot<Map<String, dynamic>> prodcutDoc =
        await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .get();

    if (!prodcutDoc.exists) {
      print('Product document not found for ID: $productId');
      return;
    }

    final ProductModel product = ProductModel.fromFirestore(prodcutDoc);

    Get.to(() => ProductDetailScreen(product: product));
  } catch (e) {
    print("Failed to fetch order");
  }
}

class OrderStatusWidget extends StatelessWidget {
  final List<OrderStatus> status;

  const OrderStatusWidget({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: status.asMap().entries.map((entry) {
        final index = entry.key;
        final isLast = index == status.length - 1;
        return OrderStatusItem(status: entry.value, isLast: isLast);
      }).toList(),
    );
  }
}

class OrderStatusItem extends StatelessWidget {
  final OrderStatus status;
  final bool isLast;

  const OrderStatusItem({Key? key, required this.status, this.isLast = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status.time.isNotEmpty;
    final Color timelineColor =
        isCompleted ? Theme.of(context).primaryColor : Colors.grey;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(
                isCompleted
                    ? CupertinoIcons.checkmark_alt_circle_fill
                    : Icons.radio_button_unchecked,
                color: timelineColor,
              ),
              if (!isLast)
                Container(
                  height: 70.h,
                  width: 4.sp,
                  color: timelineColor,
                ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.title,
                  style: TextStyle(
                    color: hexToColor('#727272'),
                    fontSize: 20.sp,
                  ),
                ),
                if (status.time.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        'Time: ',
                        style: TextStyle(
                          color: hexToColor('#343434'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        status.time,
                        style: TextStyle(
                          color: hexToColor('#949494'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ],
                if (status.description.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    status.description,
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderStatus {
  final String title;
  String description;
  final String time;

  OrderStatus({
    required this.title,
    this.description = '',
    required this.time,
  });
}
