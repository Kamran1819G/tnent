import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tnennt/helpers/color_utils.dart';

class TrackOrderScreen extends StatefulWidget {
  String productImage;
  String productName;
  int productPrice;

  TrackOrderScreen({
    required this.productImage,
    required this.productName,
    required this.productPrice,
  });

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
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
                        icon:
                            Icon(Icons.arrow_back_ios_new, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
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
                        image: AssetImage(widget.productImage),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.productName,
                        style: TextStyle(
                            color: hexToColor('#343434'),
                            fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
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
                            '123456',
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
                        '₹ ${widget.productPrice}',
                        style: TextStyle(
                            color: hexToColor('#343434'),
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 50.0),
            OrderStatusWidget(
              status: [
                OrderStatus(
                  title: 'Order Placed',
                  description: 'Order was placed by Kunal Deb',
                  time: '12:13 pm',
                ),
                OrderStatus(
                  title: 'Confirmed',
                  description: 'Order was Confirmed by Tnennt.corp',
                  time: '12:43 pm',
                ),
                OrderStatus(
                  title: 'Dispatched',
                  description:
                      'Provided Middlemen picked the item from the Store',
                  time: '12:43 pm',
                ),
                OrderStatus(
                  title: 'Delivered',
                  description: 'Item is delivered to Kunal Deb',
                  time: '12:43 pm',
                ),
              ],
            ),
            Spacer(),
            Container(
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
                        'Mr. Kamran Khan',
                        style: TextStyle(
                            color: hexToColor('#727272'),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0),
                      ),
                      SizedBox(height: 1.0),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: hexToColor('#727272'),
                            size: 14,
                          ),
                          Text(
                            '+91 8097905879',
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
                        image: AssetImage('assets/profile_image.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(
                status.isError ? Icons.cancel : CupertinoIcons.checkmark_alt_circle_fill,
                color: status.isError ? Colors.red : Theme.of(context).primaryColor,
              ),
              if (!isLast)
                Container(
                  height: 60,
                  width: 3,
                  color: Theme.of(context).primaryColor,
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
                Text(
                  status.description,
                  style: TextStyle(
                    color: hexToColor('#A9A9A9'),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
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
  final String description;
  final String time;
  final bool isError;

  OrderStatus({
    required this.title,
    required this.description,
    required this.time,
    this.isError = false,
  });
}
