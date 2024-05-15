import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/screens/store_owner_screens/create_coupon_screen.dart';
import 'package:tnennt/screens/store_owner_screens/payments_screen.dart';

class OrderAndPaysScreen extends StatefulWidget {
  const OrderAndPaysScreen({super.key});

  @override
  State<OrderAndPaysScreen> createState() => _OrderAndPaysScreenState();
}

class _OrderAndPaysScreenState extends State<OrderAndPaysScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Orders & Pays'.toUpperCase(),
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
                        Text(
                          'Orders, Payments & Coupons',
                          style: TextStyle(
                            color: hexToColor('#9C9C9C'),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Gotham',
                            fontSize: 14.0,
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
                          icon: Icon(Icons.arrow_back_ios_new,
                              color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentsScreen()),
                    );
                  },
                  child: Container(
                    width: 200.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: hexToColor('#F3F3F3'),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.currency_rupee,
                                color: Colors.black)),
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Payments',
                                style: TextStyle(
                                  color: hexToColor('#272822'),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0,
                                )),
                            Text(
                              'My Earnings',
                              style: TextStyle(
                                color: hexToColor('#838383'),
                                fontFamily: 'Poppins',
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateCouponScreen()));
                  },
                  child: Container(
                    width: 200.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: hexToColor('#F3F3F3'),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.percent, color: Colors.black)),
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
                            Text('My Coupons',
                                style: TextStyle(
                                  color: hexToColor('#838383'),
                                  fontFamily: 'Poppins',
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ]),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Orders',
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontWeight: FontWeight.w900,
                    fontSize: 18.0,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Ongoing Orders
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrdersScreen(orderType: 'Ongoing'),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: hexToColor('#F3F3F3'),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '100',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            'Ongoing Orders',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Products that are out for delivery',
                            style: TextStyle(
                              color: hexToColor('#9B9B9B'),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: hexToColor('#9B9B9B'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Delivered Orders
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OrdersScreen(orderType: 'Delivered'),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: hexToColor('#F3F3F3'),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '100',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            'Delivered Orders',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Products that are delivered to the customer',
                            style: TextStyle(
                              color: hexToColor('#9B9B9B'),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: hexToColor('#9B9B9B'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Cancelled Orders
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OrdersScreen(orderType: 'Cancelled'),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: hexToColor('#F3F3F3'),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '100',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            'Cancelled Orders',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Products that are not delivered ',
                            style: TextStyle(
                              color: hexToColor('#9B9B9B'),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: hexToColor('#9B9B9B'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Orders Matrix',
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontWeight: FontWeight.w900,
                    fontSize: 18.0,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: hexToColor('#AFAFAF')),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Confirmed Orders',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: hexToColor('#272822'),
                              ),
                            ),
                            Text(
                              'Total confirmed order from your store',
                              style: TextStyle(
                                color: hexToColor('#B0B0B0'),
                                fontSize: 8,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '400',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              'Numbers',
                              style: TextStyle(
                                color: hexToColor('#B0B0B0'),
                                fontSize: 8,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '₹',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: hexToColor('#272822'),
                                  ),
                                ),
                                Text(
                                  '400k',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Amount',
                              style: TextStyle(
                                color: hexToColor('#B0B0B0'),
                                fontSize: 8,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cancelled Orders',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: hexToColor('#272822'),
                              ),
                            ),
                            Text(
                              'Total cancelled order from your store',
                              style: TextStyle(
                                color: hexToColor('#B0B0B0'),
                                fontSize: 8,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '80',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              'Numbers',
                              style: TextStyle(
                                color: hexToColor('#B0B0B0'),
                                fontSize: 8,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '₹',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: hexToColor('#272822'),
                                  ),
                                ),
                                Text(
                                  '80k',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Amount',
                              style: TextStyle(
                                color: hexToColor('#B0B0B0'),
                                fontSize: 8,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500,
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
        ),
      ),
    );
  }
}

class OrdersScreen extends StatefulWidget {
  String orderType;

  OrdersScreen({super.key, required this.orderType});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Orders'.toUpperCase(),
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
                      Text(
                        'My Orders',
                        style: TextStyle(
                          color: hexToColor('#9C9C9C'),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gotham',
                          fontSize: 14.0,
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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.orderType} Orders',
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontWeight: FontWeight.w900,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    '5',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: (widget.orderType == 'Ongoing')
                  ? ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) => OrderCard(
                        productName: 'Nikon Camera',
                        productImage: 'assets/product_image.png',
                        orderId: '123456',
                        productPrice: 1000,
                        uniqueCode: 'HFJ98',
                        orderStatus: OrderStatus.Ongoing,
                        middlemanName: 'Mr. Kamran Khan',
                        middlemanPhone: '1234567890',
                        deliveryAddress: 'Taloja Phase 1, Navi Mumbai',
                      ),
                    )
                  : (widget.orderType == 'Delivered')
                      ? ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) => OrderCard(
                            productName: 'Nikon Camera',
                            productImage: 'assets/product_image.png',
                            orderId: '123456',
                            productPrice: 1000,
                            uniqueCode: 'HFJ98',
                            orderStatus: OrderStatus.Delivered,
                            middlemanName: 'Mr. Kamran Khan',
                            middlemanPhone: '1234567890',
                            deliveryAddress: 'Taloja Phase 1, Navi Mumbai',
                          ),
                        )
                      : ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) => OrderCard(
                            productName: 'Nikon Camera',
                            productImage: 'assets/product_image.png',
                            orderId: '123456',
                            productPrice: 1000,
                            orderStatus: OrderStatus.Cancelled,
                            middlemanName: 'Mr. Kamran Khan',
                            middlemanPhone: '1234567890',
                            cancelReason:
                                'Customer not available at the address',
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

enum OrderStatus { Ongoing, Delivered, Cancelled }

class OrderCard extends StatelessWidget {
  String productName;
  String productImage;
  String orderId;
  double productPrice;
  String? uniqueCode;
  OrderStatus orderStatus;
  String middlemanName;
  String middlemanPhone;
  String? deliveryAddress;
  String? cancelReason;

  OrderCard({
    required this.productName,
    required this.productImage,
    required this.orderId,
    required this.productPrice,
    this.uniqueCode,
    required this.orderStatus,
    required this.middlemanName,
    required this.middlemanPhone,
    this.deliveryAddress,
    this.cancelReason,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: hexToColor('#8F8F8F')),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: AssetImage(productImage),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontWeight: FontWeight.w900,
                      fontSize: 12.0,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Order ID:',
                        style: TextStyle(
                          color: hexToColor('#878787'),
                          fontWeight: FontWeight.w500,
                          fontSize: 10.0,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        orderId,
                        style: TextStyle(
                          color: hexToColor('#A9A9A9'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    '₹$productPrice',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Provided Middleman',
                    style: TextStyle(
                      color: hexToColor('#2D332F'),
                      fontWeight: FontWeight.w900,
                      fontSize: 12.0,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    middlemanName,
                    style: TextStyle(
                      color: hexToColor('#878787'),
                      fontWeight: FontWeight.w500,
                      fontSize: 10.0,
                    ),
                  ),
                  Text(
                    middlemanPhone,
                    style: TextStyle(
                      color: hexToColor('#878787'),
                      fontWeight: FontWeight.w500,
                      fontSize: 10.0,
                    ),
                  ),
                  SizedBox(height: 15),
                  if (orderStatus == OrderStatus.Ongoing)
                    Text(
                      '$uniqueCode',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 22.0,
                      ),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          if (orderStatus == OrderStatus.Ongoing ||
              orderStatus == OrderStatus.Delivered)
            Row(
              children: [
                Text(
                  "Delivery Address:",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 10.0,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  deliveryAddress ?? 'Not Available',
                  style: TextStyle(
                    color: hexToColor('#878787'),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          if (orderStatus == OrderStatus.Cancelled)
            Row(
              children: [
                Text(
                  "Cancel Reason:",
                  style: TextStyle(
                    color: hexToColor('#FF0000'),
                    fontWeight: FontWeight.w900,
                    fontSize: 10.0,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  cancelReason ?? 'Not Available',
                  style: TextStyle(
                    color: hexToColor('#878787'),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
