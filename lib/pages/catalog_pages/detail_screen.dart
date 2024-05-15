import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tnennt/helpers/color_utils.dart';

class DetailScreen extends StatefulWidget {
  String productImage;
  String productName;
  int productPrice;

  DetailScreen({
    required this.productImage,
    required this.productName,
    required this.productPrice,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
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
                        'Details'.toUpperCase(),
                        style: TextStyle(
                          color: hexToColor('#1E1E1E'),
                          fontWeight: FontWeight.w900,
                          fontSize: 24.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        ' •',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                    fontWeight: FontWeight.w900,
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
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14.0),
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    '123456',
                                    style: TextStyle(
                                        color: hexToColor('#A9A9A9'),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14.0),
                                  ),
                                ],
                              ),
                              SizedBox(height: 50.0),
                              Text(
                                '₹ ${widget.productPrice}',
                                style: TextStyle(
                                    color: hexToColor('#343434'),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.0),
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
                                    fontWeight: FontWeight.w900,
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
                    SizedBox(height: 40.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amount Details:',
                            style: TextStyle(
                                color: hexToColor('#343434'),
                                fontWeight: FontWeight.w900,
                                fontSize: 16.0),
                          ),
                          SizedBox(height: 15.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Subtotal',
                                      style: TextStyle(
                                          color: hexToColor('#727272'),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0),
                                    ),
                                    Text(
                                      '₹ 999.00',
                                      style: TextStyle(
                                          color: hexToColor('#727272'),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Middlemen Charges',
                                      style: TextStyle(
                                          color: hexToColor('#727272'),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0),
                                    ),
                                    Text(
                                      '₹ 100.00',
                                      style: TextStyle(
                                          color: hexToColor('#727272'),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Discount',
                                      style: TextStyle(
                                          color: hexToColor('#727272'),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0),
                                    ),
                                    Text(
                                      '- ₹ 50.00',
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
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 15.0),
                            height: 0.75,
                            color: hexToColor('#2B2B2B'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount',
                                style: TextStyle(
                                    color: hexToColor('#343434'),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16.0),
                              ),
                              Text(
                                '₹ 1049.00',
                                style: TextStyle(
                                    color: hexToColor('#838383'),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Details:',
                            style: TextStyle(
                                color: hexToColor('#343434'),
                                fontWeight: FontWeight.w900,
                                fontSize: 16.0),
                          ),
                          SizedBox(height: 15.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Payment Mode',
                                      style: TextStyle(
                                          color: hexToColor('#727272'),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0),
                                    ),
                                    Text(
                                      'UPI Payment',
                                      style: TextStyle(
                                          color: hexToColor('#727272'),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Payment Status',
                                      style: TextStyle(
                                          color: hexToColor('#727272'),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0),
                                    ),
                                    Text(
                                      'Paid',
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
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Details:',
                            style: TextStyle(
                                color: hexToColor('#343434'),
                                fontWeight: FontWeight.w900,
                                fontSize: 16.0),
                          ),
                          SizedBox(height: 15.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shipping Address',
                                  style: TextStyle(
                                      color: hexToColor('#2D332F'),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.0),
                                ),
                                SizedBox(height: 5.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mr. Kamran Khan',
                                      style: TextStyle(
                                          color: hexToColor('#727272'),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0),
                                    ),
                                    Text(
                                      'Flat No. 505, Ammar Residency,',
                                      style: TextStyle(
                                          color: hexToColor('#727272'),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0),
                                    ),
                                    Text(
                                      'Plot No 21, Sector 9, Taloja Phase 1,',
                                      style: TextStyle(
                                          color: hexToColor('#727272'),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0),
                                    ),
                                    Text(
                                      'Navi Mumbai - 410208, Maharashtra',
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
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Center(
                      child: Container(
                        height: 50,
                        width: 150,
                        margin: EdgeInsets.symmetric(vertical: 15.0),
                        decoration: BoxDecoration(
                          color: hexToColor('#2B2B2B'),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel Order',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 12.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

