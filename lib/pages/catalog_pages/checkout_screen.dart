import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:tnennt/helpers/color_utils.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
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
                        'Checkout'.toUpperCase(),
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
                          color: hexToColor('#FF0000'),
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
            Card(
              margin: EdgeInsets.all(16.0),
              color: Colors.white,
              surfaceTintColor: Colors.white,
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kamran Khan',
                          style: TextStyle(
                            color: hexToColor('#2D332F'),
                            fontWeight: FontWeight.w900,
                            fontSize: 22.0,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Text(
                            'Home',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 12.0,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Flat No. 505 Ammar Residency,',
                            style: TextStyle(
                              color: hexToColor('#727272'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Plot No 21 Sector 9 Taloja Phase 1',
                            style: TextStyle(
                              color: hexToColor('#727272'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Navi Mumbai, Maharashtra 410208',
                            style: TextStyle(
                              color: hexToColor('#727272'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Text(
                          'Mobile:',
                          style: TextStyle(
                            color: hexToColor('#727272'),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '1234567890',
                          style: TextStyle(
                            color: hexToColor('#2D332F'),
                            fontWeight: FontWeight.w900,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.0),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeAddressScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          width: 300,
                          margin: EdgeInsets.symmetric(vertical: 15.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: hexToColor('#E3E3E3')),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Center(
                            child: Text(
                              'Change Your Address',
                              style: TextStyle(
                                  color: hexToColor('#343434'),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ProductDetails(
              productImage: 'assets/product_image.png',
              productName: 'Nikon Camera',
              productPrice: '200',
            ),
            Spacer(),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SummaryScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: 250,
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  decoration: BoxDecoration(
                    color: hexToColor('#2B2B2B'),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetails extends StatefulWidget {
  String productImage;
  String productName;
  String productPrice;

  ProductDetails({
    required this.productImage,
    required this.productName,
    required this.productPrice,
  });

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                image: DecorationImage(
                  image: AssetImage(widget.productImage),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productName,
                  style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 8.0),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: hexToColor('#D0D0D0')),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    'XS',
                    style: TextStyle(
                        color: hexToColor('#222230'),
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w500,
                        fontSize: 10.0),
                  ),
                ),
                SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '₹${widget.productPrice}',
                          style: TextStyle(
                            color: hexToColor('#343434'),
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          '10% Discount',
                          style: TextStyle(
                            color: hexToColor('#FF0000'),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'M.R.P \$${widget.productPrice}',
                      style: TextStyle(
                        color: hexToColor('#B9B9B9'),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: hexToColor('#B9B9B9'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Quantity'.toUpperCase(),
                  style: TextStyle(
                      color: hexToColor('#222230'),
                      fontSize: 10.0,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4.0),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: hexToColor('#D0D0D0')),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        iconSize: 12,
                        onPressed: decrementQuantity,
                      ),
                      Text(
                        '$quantity',
                        style: TextStyle(
                          fontSize: 10.0,
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          color: hexToColor('#222230'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        iconSize: 12,
                        onPressed: incrementQuantity,
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

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
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
                        'Checkout'.toUpperCase(),
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
                          color: hexToColor('#FF0000'),
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
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      image: DecorationImage(
                        image: AssetImage('assets/jain_brothers.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jain Brothers',
                        style: TextStyle(
                          color: hexToColor('#343434'),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Row(children: [
                        Icon(
                          Icons.web,
                          color: Theme.of(context).primaryColor,
                          size: 12.0,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          'www.jainbrothers.com',
                          style: TextStyle(
                            color: hexToColor('#A9A9A9'),
                            fontSize: 10.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ])
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        'Order ID:',
                        style: TextStyle(
                          color: hexToColor('#2D332F'),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        '123456',
                        style: TextStyle(
                          color: hexToColor('#A9A9A9'),
                          fontSize: 12.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ProductDetails(
                      productImage: 'assets/product_image.png',
                      productName: 'Nikon Camera',
                      productPrice: '200',
                    ),
                    SizedBox(height: 8.0),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Provided Middlemen:',
                                      style: TextStyle(
                                        color: hexToColor('#2D332F'),
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      'Kamran Khan',
                                      style: TextStyle(
                                        color: hexToColor('#727272'),
                                        fontSize: 12.0,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
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
                                      image: AssetImage(
                                          'assets/profile_image.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              children: [
                                Icon(Icons.fire_truck,
                                    color: Theme.of(context).primaryColor),
                                SizedBox(width: 8.0),
                                Text(
                                  'Delivery in 45 min',
                                  style: TextStyle(
                                    color: hexToColor('#9B9B9B'),
                                    fontSize: 12.0,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 200.0,
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: hexToColor('#E3E3E3')),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: hexToColor('#F3F3F3'),
                                child: Icon(
                                  Icons.discount_outlined,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Coupons',
                                      style: TextStyle(
                                        color: hexToColor('#272822'),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.0,
                                      )),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      'View All Coupons',
                                      style: TextStyle(
                                        color: hexToColor('#838383'),
                                        fontFamily: 'Poppins',
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 75,
                          width: 200.0,
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: hexToColor('#E3E3E3')),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Enter Code:',
                                style: TextStyle(
                                  color: hexToColor('#272822'),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Summary',
                            style: TextStyle(
                                color: hexToColor('#343434'),
                                fontWeight: FontWeight.w900,
                                fontSize: 18.0),
                          ),
                          SizedBox(height: 20.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Subtotal',
                                      style: TextStyle(
                                          color: hexToColor('#B9B9B9'),
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0),
                                    ),
                                    Text(
                                      '₹ 150.00',
                                      style: TextStyle(
                                          color: hexToColor('#606060'),
                                          fontSize: 14.0),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Middlemen Charges',
                                      style: TextStyle(
                                          color: hexToColor('#B9B9B9'),
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0),
                                    ),
                                    Text(
                                      '₹ 100.00',
                                      style: TextStyle(
                                          color: hexToColor('#606060'),
                                          fontSize: 14.0),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Discount',
                                      style: TextStyle(
                                          color: hexToColor('#B9B9B9'),
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0),
                                    ),
                                    Text(
                                      '₹ 50.00',
                                      style: TextStyle(
                                          color: hexToColor('#FF0000'),
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
                            color: hexToColor('#E3E3E3'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                    color: hexToColor('#343434'),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 22.0),
                              ),
                              Text(
                                '₹ 200.00',
                                style: TextStyle(
                                    color: hexToColor('#343434'),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 22.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentOptionScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: 300,
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Text(
                      'Pay ₹ 200',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentOptionScreen extends StatefulWidget {
  const PaymentOptionScreen({super.key});

  @override
  State<PaymentOptionScreen> createState() => _PaymentOptionScreenState();
}

class _PaymentOptionScreenState extends State<PaymentOptionScreen> {
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
                        'Checkout'.toUpperCase(),
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
                          color: hexToColor('#FF0000'),
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
            ProductDetails(
              productImage: 'assets/product_image.png',
              productName: 'Nikon Camera',
              productPrice: '200',
            ),
            SizedBox(height: 50.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Payment Option',
                      style: TextStyle(
                        color: hexToColor('#343434'),
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ExpansionTile(
                      collapsedShape: RoundedRectangleBorder(
                        side: BorderSide(color: hexToColor('#E0E0E0')),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: hexToColor('#E0E0E0')),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      leading: Icon(
                        Icons.phone_android,
                        size: 20,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'UPI',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Gotham',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            'Pay by an UPI app',
                            style: TextStyle(
                              color: hexToColor('#6F6F6F'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                          )
                        ],
                      ),
                      children: [
                        ListTile(
                          leading: Container(
                            width: 50,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: hexToColor('#E0E0E0')),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Image.asset(
                              'assets/Google_Pay_Logo.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          title: Text(
                            'Google Pay',
                            style: TextStyle(
                              color: hexToColor('#343434'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                            ),
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Container(
                            width: 50,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: hexToColor('#E0E0E0')),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Image.asset(
                              'assets/Apple_Pay_Logo.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          title: Text(
                            'Apple Pay',
                            style: TextStyle(
                              color: hexToColor('#343434'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                            ),
                          ),
                          onTap: () {},
                        ),
                        ExpansionTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          leading: Container(
                            width: 50,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: hexToColor('#E0E0E0')),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Image.asset(
                              'assets/BHIM_Logo.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          title: Text(
                            'Other UPI ID',
                            style: TextStyle(
                              color: hexToColor('#343434'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                            ),
                          ),
                          trailing: Text('ADD',
                              style: TextStyle(
                                color: hexToColor('#4B8284'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                              )),
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 15.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    height: 65,
                                    child: TextField(
                                      style: TextStyle(
                                        color: hexToColor('#2A2A2A'),
                                        fontFamily: 'Gotham',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                      ),
                                      decoration: InputDecoration(
                                        helperText:
                                            'Your UPI ID will be encrypted and in 100% safe with us',
                                        helperStyle: TextStyle(
                                          color: hexToColor('#6F6F6F'),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 8.0,
                                        ),
                                        border: OutlineInputBorder(
                                          gapPadding: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: BorderSide(
                                            color: hexToColor('#E0E0E0'),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    ExpansionTile(
                      collapsedShape: RoundedRectangleBorder(
                        side: BorderSide(color: hexToColor('#E0E0E0')),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: hexToColor('#E0E0E0')),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      leading: Icon(
                        Icons.credit_card,
                        size: 20,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Credit/Debit Card',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Gotham',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            'Visa, Mastercard, Rupay & more',
                            style: TextStyle(
                              color: hexToColor('#6F6F6F'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                          )
                        ],
                      ),
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                height: 50,
                                child: TextField(
                                  style: TextStyle(
                                    color: hexToColor('#2A2A2A'),
                                    fontFamily: 'Gotham',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Card Number',
                                    hintStyle: TextStyle(
                                      color: hexToColor('#6F6F6F'),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                    ),
                                    border: OutlineInputBorder(
                                      gapPadding: 0.0,
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                        color: hexToColor('#E0E0E0'),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    height: 50,
                                    child: TextField(
                                      style: TextStyle(
                                        color: hexToColor('#2A2A2A'),
                                        fontFamily: 'Gotham',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Expiry(MM/YY)',
                                        hintStyle: TextStyle(
                                          color: hexToColor('#6F6F6F'),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0,
                                        ),
                                        border: OutlineInputBorder(
                                          gapPadding: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: BorderSide(
                                            color: hexToColor('#E0E0E0'),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    height: 50,
                                    child: TextField(
                                      style: TextStyle(
                                        color: hexToColor('#2A2A2A'),
                                        fontFamily: 'Gotham',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'CVV',
                                        hintStyle: TextStyle(
                                          color: hexToColor('#6F6F6F'),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0,
                                        ),
                                        border: OutlineInputBorder(
                                          gapPadding: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: BorderSide(
                                            color: hexToColor('#E0E0E0'),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Center(
                                child: Container(
                                  height: 50,
                                  width: 300,
                                  margin: EdgeInsets.symmetric(vertical: 15.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Pay ₹ 200',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionScreen(),
                          ),
                        );
                      },
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: hexToColor('#E0E0E0')),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        leading: Icon(
                          Icons.money,
                          size: 20,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cash on Delivery',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              'Pay at your doorstep',
                              style: TextStyle(
                                color: hexToColor('#6F6F6F'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0,
                              ),
                            )
                          ],
                        ),
                        trailing: SizedBox(),
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

class ChangeAddressScreen extends StatefulWidget {
  const ChangeAddressScreen({super.key});

  @override
  State<ChangeAddressScreen> createState() => _ChangeAddressScreenState();
}

class _ChangeAddressScreenState extends State<ChangeAddressScreen> {
  String AddressType = 'Home';

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _zipController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressLine1Controller = TextEditingController();
    _addressLine2Controller = TextEditingController();
    _zipController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
  }

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
                        'Checkout'.toUpperCase(),
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
                          color: hexToColor('#FF0000'),
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
            SizedBox(height: 30.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: _buildTextField(
                        controller: _nameController,
                        labelText: 'Name',
                        hintText: 'Enter Name',
                        prefixIcon: Icons.person_outline,
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    SizedBox(height: 35),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: _buildTextField(
                        controller: _phoneController,
                        labelText: 'Mobile Number',
                        hintText: 'XXXXX-XXXXX',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    SizedBox(height: 35),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: _buildTextField(
                        controller: _addressLine1Controller,
                        labelText: 'Flat/ Housing No./ Building/ Apartment',
                        hintText: 'Address Line 1',
                        prefixIcon: Icons.location_on_outlined,
                        keyboardType: TextInputType.streetAddress,
                      ),
                    ),
                    SizedBox(height: 35),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: _buildTextField(
                        controller: _addressLine2Controller,
                        labelText: 'Area/ Street/ Sector',
                        hintText: 'Address Line 2',
                        prefixIcon: Icons.location_on_outlined,
                        keyboardType: TextInputType.streetAddress,
                      ),
                    ),
                    SizedBox(height: 35),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: _buildTextField(
                        controller: _zipController,
                        labelText: 'Pincode',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(height: 35),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: _buildTextField(
                              controller: _cityController,
                              labelText: 'City',
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: _buildTextField(
                              controller: _stateController,
                              labelText: 'State',
                              keyboardType: TextInputType.name,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 35),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          _buildAddressType('Home'),
                          SizedBox(width: 10.0),
                          _buildAddressType('Office'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                height: 50,
                width: 250,
                margin: EdgeInsets.symmetric(vertical: 15.0),
                decoration: BoxDecoration(
                  color: hexToColor('#2B2B2B'),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Center(
                  child: Text(
                    'Confirm Address',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressType(String type) {
    bool isSelected = AddressType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          AddressType = isSelected ? '' : type;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        decoration: BoxDecoration(
          border: Border.all(color: hexToColor('#343434')),
          color: isSelected ? hexToColor('#343434') : Colors.white,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Center(
          child: Text(
            type,
            style: TextStyle(
                color: isSelected ? Colors.white : hexToColor('#343434'),
                fontWeight: FontWeight.w900,
                fontSize: 12.0),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? labelText,
    String? hintText,
    IconData? prefixIcon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: hexToColor('#2A2A2A'),
        fontFamily: 'Gotham',
        fontSize: 14,
        fontWeight: FontWeight.w900,
      ),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        prefixIconColor: Theme.of(context).primaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: hexToColor('#2A2A2A')),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: hexToColor('#2A2A2A')),
        ),
      ),
      keyboardType: keyboardType,
    );
  }
}

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  GlobalKey _globalKey = GlobalKey();

  Future<Uint8List?> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print(e);
      return null;
    }
  }

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
                  IconButton(
                    onPressed: () async {
                      Uint8List? imageBytes = await _capturePng();

                      if (imageBytes != null) {
                        final result = await ImageGallerySaver.saveImage(
                          Uint8List.fromList(imageBytes),
                        );
                        print(result);
                      }
                    },
                    icon: Icon(
                      Icons.file_download_outlined,
                      color: Colors.black,
                      size: 30.0,
                    ),
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
            RepaintBoundary(
              key: _globalKey,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/transaction_bg.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.0, 0.0),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Icon(Icons.check, color: Colors.white, size: 40.0),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.125,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        children: [
                          Text(
                            'Thank You!',
                            style: TextStyle(
                              color: hexToColor('#1E1E1E'),
                              fontSize: 24.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Your transaction is successful',
                            style: TextStyle(
                              color: hexToColor('#8E8E8E'),
                              fontFamily: 'Gotham',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Date:',
                                      style: TextStyle(
                                        color: hexToColor('#979797'),
                                        fontSize: 20.0,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      '15 May 2024',
                                      style: TextStyle(
                                        color: hexToColor('#333333'),
                                        fontSize: 20.0,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Time:',
                                      style: TextStyle(
                                        color: hexToColor('#979797'),
                                        fontSize: 20.0,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      '02:30 AM',
                                      style: TextStyle(
                                        color: hexToColor('#333333'),
                                        fontSize: 20.0,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'To:',
                                      style: TextStyle(
                                        color: hexToColor('#979797'),
                                        fontSize: 20.0,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      'Kamran Khan',
                                      style: TextStyle(
                                        color: hexToColor('#333333'),
                                        fontSize: 20.0,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 2,
                                  margin: EdgeInsets.symmetric(vertical: 20.0),
                                  decoration: BoxDecoration(
                                    color: hexToColor('#E0E0E0'),
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                        color: hexToColor('#343434'),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      '₹ 200.00',
                                      style: TextStyle(
                                        color: hexToColor('#343434'),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.0),
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.1,
                                  decoration: BoxDecoration(
                                    color: hexToColor('#FFFFFF'),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Cash on Delivery',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 25.0),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                                Row(
                                  children: [
                                    Text(
                                      'Order ID:',
                                      style: TextStyle(
                                        color: hexToColor('#2D332F'),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      '123456',
                                      style: TextStyle(
                                        color: hexToColor('#A9A9A9'),
                                        fontSize: 20.0,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: hexToColor('#094446')),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Unpaid'.toUpperCase(),
                                          style: TextStyle(
                                            color: hexToColor('#094446'),
                                            fontSize: 20.0,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
