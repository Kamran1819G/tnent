import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnent/helpers/color_utils.dart';

enum NotificationType { cancelled, delivered, refunded, orderplaced }

class OrderUpdateNotification extends StatelessWidget {
  final NotificationType type;
  final String? name;
  final String? productImage;
  final String? productName;
  final String orderId;
  final String time;
  final double? price;

  const OrderUpdateNotification({
    required this.type,
    this.name,
    this.productImage,
    this.productName,
    required this.orderId,
    required this.time,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData iconData;
    String statusText;
    Color backgroundColor;

    switch (type) {
      case NotificationType.orderplaced:
        statusText = 'Order Placed';
        statusColor = Theme.of(context).primaryColor;
        iconData = Icons.shopping_cart;
        backgroundColor = Theme.of(context).primaryColor;
        break;
      case NotificationType.refunded:
        statusText = 'Refunded';
        statusColor = hexToColor('#FF0000');
        iconData = Icons.money_off;
        backgroundColor = hexToColor('#FF0000');
        break;
      case NotificationType.cancelled:
        statusText = 'Cancelled';
        statusColor = hexToColor('#FF0000');
        iconData = Icons.not_interested;
        backgroundColor = hexToColor('#FF0000');
        break;
      case NotificationType.delivered:
        statusText = 'Delivered';
        statusColor = Theme.of(context).primaryColor;
        iconData = Icons.thumb_up;
        backgroundColor = Theme.of(context).primaryColor;
        break;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: hexToColor('#8F8F8F'), width: 1.0),
          borderRadius: BorderRadius.circular(12.r),
        ),
        leading: productImage != null
            ? Container(
          height: 125.h,
          width: 112.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: Image.network(
              productImage!,
              fit: BoxFit.fill,
            ),
          ),
        )
            : null,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: statusColor,
                  ),
                ),
                Spacer(),
                Text(
                  "${time}",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: hexToColor('#747474'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Order ID:',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: hexToColor('#343434'),
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  '#${orderId}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    color: hexToColor('#343434'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
          ],
        ),
        subtitle: (type == NotificationType.delivered ||
            type == NotificationType.cancelled ||
            type == NotificationType.refunded)
            ? Text(
          type == NotificationType.delivered
              ? name != null
              ? 'Item delivered to $name'
              : 'Item delivered'
              : (type == NotificationType.refunded
              ? 'Item refunded'
              : (type == NotificationType.cancelled
              ? 'Item cancelled'
              : '')),
          style: TextStyle(
            color: hexToColor('#343434'),
            fontFamily: 'Poppins',
            fontSize: 18.sp,
          ),
        )
            : Row(
          children: [
            Text(
              productName!,
              style: TextStyle(
                color: hexToColor('#343434'),
                fontSize: 17.sp,
              ),
            ),
            Spacer(),
            Container(
              padding:
              EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: hexToColor('#343434'),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '₹${price}',
                style: TextStyle(
                  color: hexToColor('#838383'),
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
        trailing: (type == NotificationType.delivered ||
            type == NotificationType.cancelled ||
            type == NotificationType.refunded)
            ? Container(
          height: 50.h,
          width: 50.w,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            iconData,
            color: Colors.white,
            size: 23.sp,
          ),
        )
            : null,
      ),
    );
  }
}