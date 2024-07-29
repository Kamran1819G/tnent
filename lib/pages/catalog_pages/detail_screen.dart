import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnennt/helpers/color_utils.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  DetailScreen({required this.order});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  void _cancelOrder() async {
    try {
      await FirebaseFirestore.instance.collection('Orders').where('orderId', isEqualTo: widget.order['orderId']).get().then((snapshot) {
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order cancelled successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel order: $e')),
      );
    }
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
              backgroundColor: WidgetStateProperty.all(
                Colors.grey[100],
              ),
              shape: WidgetStateProperty.all(
                CircleBorder(),
              ),
            ),
            icon: Icon(Icons.arrow_back_ios_new,
                color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails() {
    return Container(
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
                style: TextStyle(color: hexToColor('#343434'), fontSize: 24.sp),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Text(
                    'Order ID:',
                    style: TextStyle(color: hexToColor('#878787'), fontSize: 17.sp),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    widget.order['orderId'],
                    style: TextStyle(color: hexToColor('#A9A9A9'), fontSize: 17.sp),
                  ),
                ],
              ),
              SizedBox(height: 60.h),
              Text(
                '₹ ${widget.order['priceDetails']['price']}',
                style: TextStyle(color: hexToColor('#343434'), fontSize: 22.sp),
              ),
            ],
          ),
        ],
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
                      image: NetworkImage(widget.order['providedMiddleman']['image']),
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
                _buildAmountRow('Subtotal', widget.order['priceDetails']['price']),
                _buildAmountRow('MRP', widget.order['priceDetails']['mrp']),
                _buildAmountRow('Discount', '- ${widget.order['priceDetails']['discount']}'),
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
                _buildDetailRow('Payment Mode', widget.order['payment']['method']),
                _buildDetailRow('Payment Status', widget.order['payment']['status']),
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
      child: GestureDetector(
        onTap: _cancelOrder,
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
              'Cancel Order',
              style: TextStyle(color: Colors.white, fontFamily: 'Poppins' ,fontSize: 18.sp),
            ),
          ),
        ),
      ),
    );
  }
}