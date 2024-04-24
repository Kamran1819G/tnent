import 'package:flutter/material.dart';
import 'package:tnennt/helpers/color_utils.dart';

enum NotificationType { cancelled, delivered, refunded, orderplaced }

class OrderUpdateNotification extends StatelessWidget {
  final NotificationType type;
  final String? name;
  final String? productImage;
  final String? productName;
  final String orderID;
  final String time;
  final double? price;

  const OrderUpdateNotification({
    required this.type,
    this.name,
    this.productImage,
    this.productName,
    required this.orderID,
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: hexToColor('#8F8F8F'), width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        leading: productImage != null
            ? Container(
                height: 75,
                width: 75,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    productImage!,
                    fit: BoxFit.cover, // or BoxFit.fill
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
                    fontSize: 16.0,
                    color: statusColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  "(${time})",
                  style: TextStyle(
                    fontSize: 8.0,
                    color: hexToColor('#747474'),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Order ID:',
                  style: TextStyle(
                    fontSize: 10.0,
                    color: hexToColor('#343434'),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(width: 4.0),
                Text(
                  '#${orderID}',
                  style: TextStyle(
                    fontSize: 10.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: hexToColor('#343434'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
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
                  fontWeight: FontWeight.w500,
                  fontSize: 12.0,
                ),
              )
            : Row(
                children: [
                  Text(
                    productName!,
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontWeight: FontWeight.w900,
                      fontSize: 12.0,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: hexToColor('#343434'),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      '₹${price}',
                      style: TextStyle(
                        color: hexToColor('#838383'),
                        fontWeight: FontWeight.w900,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ],
              ),
        trailing: (type == NotificationType.delivered ||
                type == NotificationType.cancelled ||
                type == NotificationType.refunded)
            ? Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  iconData,
                  color: Colors.white,
                  size: 20.0,
                ),
              )
            : null,
      ),
    );
  }
}
