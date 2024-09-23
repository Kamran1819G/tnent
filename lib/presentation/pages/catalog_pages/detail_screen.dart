import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tnent/core/helpers/color_utils.dart';
import 'package:tnent/models/product_model.dart';
import 'package:tnent/presentation/pages/product_detail_screen.dart';

import '../../../core/helpers/snackbar_utils.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  DetailScreen({required this.order});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool get isOrderCancelled => widget.order['status']?['cancelled'] != null;

  bool get canCancelOrder {
    final status = widget.order['status'];
    return !isOrderCancelled &&
        !(status?['accepted']?['message'] == 'Order accepted by middleman');
  }

  void _cancelOrder() async {
    if (isOrderCancelled) return; // Do nothing if already cancelled
    if (!canCancelOrder) {
      _showCannotCancelDialog();
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('Orders')
          .where('orderId', isEqualTo: widget.order['orderId'])
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          doc.reference.update({
            'status.cancelled': {
              'timestamp': Timestamp.now(),
              'message': 'Order was cancelled',
            },
          });
        });
      });

      setState(() {
        widget.order['status']['cancelled'] = {
          'timestamp': Timestamp.now(),
          'message': 'Order was cancelled',
        };
      });

      await _sendCancellationNotification();

      showSnackBar(context, 'Order cancelled successfully');
    } catch (e) {
      showSnackBar(context, 'Failed to cancel order: $e');
    }
  }


  Future<void> _sendCancellationNotification() async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;

    // Store the notification in Firestore
    await firestore
        .collection('Users')
        .doc(user.uid)
        .collection('notifications')
        .add({
      'title': 'Order Cancelled',
      'body': 'Your order #${widget.order['orderId']} has been cancelled.',
      'data': {
        'type': 'general',
        'status': 'cancelled',
        'productImage': widget.order['productImage'],
        'productName': widget.order['productName'],
        'price': widget.order['priceDetails']['price'].toString(),
        'orderId': widget.order['orderId'],
      },
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Show local notification
    String bigPicturePath = await _downloadAndSaveFile(
        widget.order['productImage'],
        'cancelledOrderImage_${widget.order['orderId']}');

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 11,
        channelKey: 'user_order_channel',
        title: 'Order Cancelled',
        body: 'Your order #${widget.order['orderId']} has been cancelled.',
        bigPicture: 'file://$bigPicturePath',
        notificationLayout: NotificationLayout.BigPicture,
        payload: {
          'orderId': widget.order['orderId'],
          'productName': widget.order['productName'],
        },
      ),
    );
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
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

  void _showCannotCancelDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cannot Cancel Order'),
          content: Text('This order has already been accepted by the middleman and cannot be cancelled.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductDetails(),
                    SizedBox(height: 40.0),
                    if (widget.order['providedMiddleman'] != null &&
                        widget.order['providedMiddleman'].isNotEmpty)
                      _buildProvidedMiddleman(),
                    SizedBox(height: 40.0),
                    _buildAmountDetails(),
                    SizedBox(height: 40.0),
                    _buildPaymentDetails(),
                    SizedBox(height: 40.0),
                    _buildDeliveryDetails(),
                    SizedBox(height: 30.0),
                    _buildCancelOrderButton(),
                  ],
                ),
              ),
            ),
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
                'Details'.toUpperCase(),
                style: TextStyle(
                  color: hexToColor('#1E1E1E'),
                  fontSize: 35.sp,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                ' •',
                style: TextStyle(
                  fontSize: 34.sp,
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

  Widget _buildProductDetails() {
    return GestureDetector(
      onTap: () => _fetchProductAndNavigate(widget.order['productId']),
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
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(widget.order['productImage']),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.order['productName'],
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
                    SizedBox(width: 8.0),
                    Text(
                      widget.order['orderId'],
                      style: TextStyle(
                          color: hexToColor('#A9A9A9'), fontSize: 17.sp),
                    ),
                  ],
                ),
                SizedBox(height: 60.h),
                Text(
                  '₹ ${widget.order['priceDetails']['price']}',
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

  Widget _buildProvidedMiddleman() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Provided Middlemen:',
            style: TextStyle(color: hexToColor('#343434'), fontSize: 24.sp),
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.order['providedMiddleman']['name'] ?? '',
                    style: TextStyle(
                      color: hexToColor('#727272'),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: hexToColor('#727272'),
                        size: 20.sp,
                      ),
                      Text(
                        widget.order['providedMiddleman']['phone'] ?? '',
                        style: TextStyle(
                          color: hexToColor('#727272'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              if (widget.order['providedMiddleman']['image'] != null)
                Container(
                  width: 70.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.r),
                    image: DecorationImage(
                      image: NetworkImage(
                          widget.order['providedMiddleman']['image']),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }



  Widget _buildAmountDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amount Details:',
            style: TextStyle(color: hexToColor('#343434'), fontSize: 24.sp),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [

                _buildAmountRow('MRP', widget.order['priceDetails']['mrp']),
                _buildAmountRow('Discount',
                    '- ${widget.order['priceDetails']['discount']}'),
                _buildAmountRow(
                    'Subtotal', widget.order['priceDetails']['price']),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16.h),
            height: 1.h,
            color: hexToColor('#2B2B2B'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(color: hexToColor('#343434'), fontSize: 24.sp),
              ),
              Text(
                '₹ ${widget.order['priceDetails']['price']}',
                style: TextStyle(color: hexToColor('#838383'), fontSize: 24.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, dynamic value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: hexToColor('#727272'),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 20.sp,
          ),
        ),
        Text(
          '₹ $value',
          style: TextStyle(
            color: hexToColor('#727272'),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 20.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Details:',
            style: TextStyle(color: hexToColor('#343434'), fontSize: 24.sp),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                _buildDetailRow(
                    'Payment Mode', widget.order['payment']['method']),
                _buildDetailRow(
                    'Payment Status', widget.order['payment']['status']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Details:',
            style: TextStyle(color: hexToColor('#343434'), fontSize: 16.0),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shipping Address',
                  style: TextStyle(
                    color: hexToColor('#2D332F'),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(widget.order['shippingAddress']['name'] ?? '',
                    style: _addressTextStyle()),
                Text(widget.order['shippingAddress']['addressLine1'] ?? '',
                    style: _addressTextStyle()),
                Text(widget.order['shippingAddress']['addressLine2'] ?? '',
                    style: _addressTextStyle()),
                Text(
                  '${widget.order['shippingAddress']['city'] ?? ''}, ${widget.order['shippingAddress']['state'] ?? ''} - ${widget.order['shippingAddress']['zip'] ?? ''}',
                  style: _addressTextStyle(),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.phone,
                      color: hexToColor('#727272'),
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '${widget.order['shippingAddress']['phone'] ?? ''}',
                      style: _addressTextStyle(),
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

  TextStyle _addressTextStyle() {
    return TextStyle(
      color: hexToColor('#727272'),
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      fontSize: 20.sp,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: _addressTextStyle()),
        Text(value, style: _addressTextStyle()),
      ],
    );
  }

  Widget _buildCancelOrderButton() {
    return Center(
      child: Opacity(
        opacity: isOrderCancelled ? 0.5 : 1.0,
        child: GestureDetector(
          onTap: isOrderCancelled ? null : _cancelOrder,
          child: Container(
            height: 75.h,
            width: 200.w,
            margin: EdgeInsets.symmetric(vertical: 15.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: hexToColor('#2B2B2B'),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: Text(
                isOrderCancelled ? 'Order Cancelled' : 'Cancel Order',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Poppins', fontSize: 18.sp),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
