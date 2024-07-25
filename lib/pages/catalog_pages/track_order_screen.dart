import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:tnennt/helpers/color_utils.dart';

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
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Row(
            children: [
              Text(
                'Track Order'.toUpperCase(),
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
                  color: hexToColor('#42FF00'),
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
    );
  }

  Widget _buildOrderDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 125,
            width: 125,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(order['productImage']),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order['productName'],
                style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 16.0),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Text(
                    'Order ID:',
                    style: TextStyle(
                        color: hexToColor('#878787'),
                        fontSize: 14.0),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    order['orderId'],
                    style: TextStyle(
                        color: hexToColor('#A9A9A9'),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0),
                  ),
                ],
              ),
              SizedBox(height: 50.0),
              Text(
                '₹ ${order['priceDetails']['price']}',
                style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 18.0),
              ),
            ],
          ),
        ],
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
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Provided Middlemen:',
                style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 16.0),
              ),
              SizedBox(height: 15.0),
              Text(
                middleman['name'] ?? 'Not assigned yet',
                style: TextStyle(
                    color: hexToColor('#727272'),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0),
              ),
              SizedBox(height: 1.0),
              if (middleman['phone'] != null)
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: hexToColor('#727272'),
                      size: 14,
                    ),
                    Text(
                      middleman['phone'],
                      style: TextStyle(
                          color: hexToColor('#727272'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0),
                    ),
                  ],
                ),
            ],
          ),
          Spacer(),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
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
    return DateFormat('jm').format((timestamp as Timestamp).toDate()); // Placeholder
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

  const OrderStatusItem({Key? key, required this.status, this.isLast = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status.time.isNotEmpty;
    final Color timelineColor = isCompleted ? Theme.of(context).primaryColor : Colors.grey;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(
                isCompleted ? CupertinoIcons.checkmark_alt_circle_fill : Icons.radio_button_unchecked,
                color: timelineColor,
              ),
              if (!isLast)
                Container(
                  height: 60,
                  width: 3,
                  color: timelineColor,
                ),
            ],
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.title,
                  style: TextStyle(
                    color: hexToColor('#727272'),
                    fontSize: 14,
                  ),
                ),
                if (status.time.isNotEmpty) ...[
                  SizedBox(height: 4),
                  Row(
                    children:[
                      Text(
                        'Time: ',
                        style: TextStyle(
                          color: hexToColor('#343434'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        status.time,
                        style: TextStyle(
                          color: hexToColor('#949494'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
                if(status.description.isNotEmpty) ...[
                  SizedBox(height: 4),
                  Text(
                    status.description,
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
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