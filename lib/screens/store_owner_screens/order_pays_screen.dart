import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/screens/coming_soon.dart';
import 'package:tnennt/screens/store_owner_screens/create_coupon_screen.dart';
import 'package:tnennt/screens/store_owner_screens/payments_screen.dart';

class OrderAndPaysScreen extends StatefulWidget {
  final String storeId;

  OrderAndPaysScreen({required this.storeId});

  @override
  State<OrderAndPaysScreen> createState() => _OrderAndPaysScreenState();
}

class _OrderAndPaysScreenState extends State<OrderAndPaysScreen> {
  int ongoingOrdersCount = 0;
  int deliveredOrdersCount = 0;
  int cancelledOrdersCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchOrderCounts();
  }

  Future<void> _fetchOrderCounts() async {
    final ordersRef = FirebaseFirestore.instance.collection('Orders');

    // Query for ongoing orders
    final ongoingSnapshot = await ordersRef
        .where('storeId', isEqualTo: widget.storeId)
        .where('status.ordered', isNull: false)
        .get();

    // Query for delivered orders
    final deliveredSnapshot = await ordersRef
        .where('storeId', isEqualTo: widget.storeId)
        .where('status.delivered', isNull: false)
        .get();

    // Query for cancelled orders
    final cancelledSnapshot = await ordersRef
        .where('storeId', isEqualTo: widget.storeId)
        .where('status.cancelled', isNull: false)
        .get();

    print('Ongoing Orders: ${ongoingSnapshot.docs.length}');
    print('Delivered Orders: ${deliveredSnapshot.docs.length}');
    print('Cancelled Orders: ${cancelledSnapshot.docs.length}');

    setState(() {
      ongoingOrdersCount = ongoingSnapshot.docs.length;
      deliveredOrdersCount = deliveredSnapshot.docs.length;
      cancelledOrdersCount = cancelledSnapshot.docs.length;
    });
  }

  Future<List<QueryDocumentSnapshot>> _fetchOrders(String status) async {
    final ordersRef = FirebaseFirestore.instance.collection('Orders');
    QuerySnapshot querySnapshot;

    switch (status) {
      case 'ordered':
        querySnapshot = await ordersRef
            .where('storeId', isEqualTo: widget.storeId)
            .where('status.ordered', isNull: false)
            .get();
        break;
      case 'delivered':
        querySnapshot = await ordersRef
            .where('storeId', isEqualTo: widget.storeId)
            .where('status.delivered', isNull: false)
            .get();
        break;
      case 'cancelled':
        querySnapshot = await ordersRef
            .where('storeId', isEqualTo: widget.storeId)
            .where('status.cancelled', isNull: false)
            .get();
        break;
      default:
        throw ArgumentError('Invalid status: $status');
    }

    return querySnapshot.docs;
  }

  void _navigateToOrdersScreen(String orderType) async {
    final orders = await _fetchOrders(orderType.toLowerCase() == 'ongoing'
        ? 'ordered'
        : orderType.toLowerCase() == 'delivered'
            ? 'delivered'
            : 'cancelled');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrdersScreen(orderType: orderType, orders: orders),
      ),
    );
  }

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
                    width: 180.0,
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
                    // CreateCouponScreen();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ComingSoon()));
                  },
                  child: Container(
                    width: 180.0,
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
                    fontSize: 18.0,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _navigateToOrdersScreen('Ongoing'),
                child: _buildOrderCard(
                  'Ongoing Orders',
                  'Products that are out for delivery',
                  ongoingOrdersCount,
                ),
              ),
              SizedBox(height: 10),
              // Delivered Orders
              GestureDetector(
                onTap: () => _navigateToOrdersScreen('Delivered'),
                child: _buildOrderCard(
                  'Delivered Orders',
                  'Products that are delivered to the customer',
                  deliveredOrdersCount,
                ),
              ),
              SizedBox(height: 10),
              // Cancelled Orders
              GestureDetector(
                onTap: () => _navigateToOrdersScreen('Cancelled'),
                child: _buildOrderCard(
                  'Cancelled Orders',
                  'Products that are not delivered',
                  cancelledOrdersCount,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(String title, String subtitle, int count) {
    return Container(
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
                '$count',
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  color: hexToColor('#9B9B9B'),
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.arrow_forward_ios,
              color: hexToColor('#9B9B9B'),
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  String orderType;
  List<QueryDocumentSnapshot> orders;

  OrdersScreen({required this.orderType, required this.orders});

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
                    '$orderType Orders',
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    '${orders.length}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index].data() as Map<String, dynamic>;
                  return OrderCard(
                    productName: order['productName'],
                    productImage: order['productImage'],
                    orderId: order['orderId'],
                    productPrice: order['priceDetails']['price'],
                    uniqueCode: order['pickupCode'],
                    orderStatus: _getOrderStatus(order),
                    middleman: order['providedMiddleman'],
                    shippingAddress: '${order['shippingAddress']['city']}, ${order['shippingAddress']['zip']}, ${order['shippingAddress']['state']}',
                    cancelReason: order['status']['cancelled']?['message'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  OrderStatus _getOrderStatus(Map<String, dynamic> order) {
    if (order['status']['cancelled'] != null) {
      return OrderStatus.Cancelled;
    } else if (order['status']['delivered'] != null) {
      return OrderStatus.Delivered;
    } else {
      return OrderStatus.Ongoing;
    }
  }
}

enum OrderStatus { Ongoing, Delivered, Cancelled }

class OrderCard extends StatelessWidget {
  final String productName;
  final String productImage;
  final String orderId;
  final double productPrice;
  final String? uniqueCode;
  final OrderStatus orderStatus;
  final Map<String, dynamic> middleman;
  final String? shippingAddress;
  final String? cancelReason;

  OrderCard({
    required this.productName,
    required this.productImage,
    required this.orderId,
    required this.productPrice,
    this.uniqueCode,
    required this.orderStatus,
    required this.middleman,
    this.shippingAddress,
    this.cancelReason,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
                        image: NetworkImage(productImage),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName,
                          style: TextStyle(
                            color: hexToColor('#343434'),
                            fontSize: 14.0,
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
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Provided Middleman',
                          style: TextStyle(
                            color: hexToColor('#2D332F'),
                            fontSize: 10.0,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(height: 6),
                        Text(
                          middleman['name'] ?? 'Yet to assign',
                          style: TextStyle(
                            color: hexToColor('#878787'),
                            fontWeight: FontWeight.w500,
                            fontSize: 10.0,
                          ),
                        ),
                        Text(
                          middleman['phone'] ?? 'Yet to assign',
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
                              color: Theme
                                  .of(context)
                                  .primaryColor,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Delivery Address:",
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        fontSize: 10.0,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      shippingAddress ?? 'Not Available',
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
                        fontSize: 10.0,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        cancelReason ?? 'Not Available',
                        style: TextStyle(
                          color: hexToColor('#878787'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
