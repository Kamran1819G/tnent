import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnent/helpers/color_utils.dart';
import 'package:tnent/screens/coming_soon.dart';
import 'package:tnent/screens/store_owner_screens/create_coupon_screen.dart';
import 'package:tnent/screens/store_owner_screens/payments_screen.dart';

class OrderAndPaysScreen extends StatefulWidget {
  final String storeId;

  OrderAndPaysScreen({required this.storeId});

  @override
  State<OrderAndPaysScreen> createState() => _OrderAndPaysScreenState();
}

class _OrderAndPaysScreenState extends State<OrderAndPaysScreen> {
  List<QueryDocumentSnapshot> allOrders = [];
  int ongoingOrdersCount = 0;
  int deliveredOrdersCount = 0;
  int cancelledOrdersCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final ordersRef = FirebaseFirestore.instance.collection('Orders');
    final snapshot =
        await ordersRef.where('storeId', isEqualTo: widget.storeId).get();

    setState(() {
      allOrders = snapshot.docs;
      _updateOrderCounts();
    });
  }

  void _updateOrderCounts() {
    ongoingOrdersCount = allOrders.where((doc) {
      final status = doc['status'] as Map<String, dynamic>;
      return status['ordered'] != null &&
          status.containsKey('delivered') == false &&
          status.containsKey('cancelled') == false;
    }).length;

    deliveredOrdersCount = allOrders.where((doc) {
      final status = doc['status'] as Map<String, dynamic>;
      return status['delivered'] != null;
    }).length;

    cancelledOrdersCount = allOrders.where((doc) {
      final status = doc['status'] as Map<String, dynamic>;
      return status['cancelled'] != null;
    }).length;
  }

  List<QueryDocumentSnapshot> _filterOrders(String status) {
    return allOrders.where((doc) {
      final orderStatus = doc['status'] as Map<String, dynamic>;
      switch (status) {
        case 'ongoing':
          return orderStatus['ordered'] != null &&
              orderStatus.containsKey('delivered') == false &&
              orderStatus.containsKey('cancelled') == false;
        case 'delivered':
          return orderStatus['delivered'] != null;
        case 'cancelled':
          return orderStatus['cancelled'] != null;
        default:
          return false;
      }
    }).toList();
  }

  void _navigateToOrdersScreen(String orderType) {
    final filteredOrders = _filterOrders(orderType.toLowerCase());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OrdersScreen(orderType: orderType, orders: filteredOrders),
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
                height: 100.h,
                margin: EdgeInsets.only(top: 20.h),
                padding: EdgeInsets.symmetric(horizontal: 16.h),
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
                                fontSize: 35.sp,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              ' •',
                              style: TextStyle(
                                fontSize: 35.sp,
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
                            fontSize: 20.sp,
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
              ),
              SizedBox(height: 30.h),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentsScreen()),
                    );
                  },
                  child: Container(
                    height: 105.h,
                    width: 280.w,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: hexToColor('#F3F3F3'),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                            radius: 44.r,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.currency_rupee,
                                color: Colors.black)),
                        SizedBox(width: 20.w),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Payments',
                                style: TextStyle(
                                  color: hexToColor('#272822'),
                                  fontSize: 19.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                )),
                            SizedBox(height: 8.h),
                            Text(
                              'My Earnings',
                              style: TextStyle(
                                color: hexToColor('#838383'),
                                fontFamily: 'Gotham',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateCouponScreen()));
                  },
                  child: Container(
                    height: 105.h,
                    width: 280.w,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: hexToColor('#F3F3F3'),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                            radius: 44.w,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.percent, color: Colors.black)),
                        SizedBox(width: 20.w),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Coupons',
                                style: TextStyle(
                                  color: hexToColor('#272822'),
                                  fontSize: 19.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                )),
                            SizedBox(height: 8.h),
                            Text('My Coupons',
                                style: TextStyle(
                                  color: hexToColor('#838383'),
                                  fontFamily: 'Gotham',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ]),
              SizedBox(height: 50.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 19.w),
                child: Text(
                  'Orders',
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 26.sp,
                  ),
                ),
              ),

              SizedBox(height: 30.h),
              // Ongoing Orders
              GestureDetector(
                onTap: () => _navigateToOrdersScreen('Ongoing'),
                child: _buildOrderCard(
                  'Ongoing Orders',
                  'Products that are out for delivery',
                  ongoingOrdersCount,
                ),
              ),
              SizedBox(height: 20.h),
              // Delivered Orders
              GestureDetector(
                onTap: () => _navigateToOrdersScreen('Delivered'),
                child: _buildOrderCard(
                  'Delivered Orders',
                  'Products that are delivered to the customer',
                  deliveredOrdersCount,
                ),
              ),
              SizedBox(height: 20.h),
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
                  fontSize: 30.sp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                subtitle,
                style: TextStyle(
                  color: hexToColor('#9B9B9B'),
                  fontSize: 17.sp,
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
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  final String orderType;
  final List<QueryDocumentSnapshot> orders;

  OrdersScreen({required this.orderType, required this.orders});

  @override
  Widget build(BuildContext context) {
    // Filter orders to remove any invalid or incomplete documents
    final validOrders = orders.where((doc) {
      final data = doc.data() as Map<String, dynamic>?;

      // Ensure the required fields exist and are valid
      return data != null &&
          data.containsKey('productName') &&
          data.containsKey('productImage') &&
          data.containsKey('orderId') &&
          data.containsKey('quantity') &&
          data.containsKey('priceDetails') &&
          data['priceDetails'].containsKey('price') &&
          data.containsKey('status');
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: 50.h),
            _buildOrderSummary(context, validOrders),
            SizedBox(height: 30.h),
            Expanded(
              child: ListView.builder(
                itemCount: validOrders.length,
                itemBuilder: (context, index) {
                  final order =
                      validOrders[index].data() as Map<String, dynamic>;
                  return OrderCard(
                    productName: order['productName'],
                    productImage: order['productImage'],
                    orderId: order['orderId'],
                    productQuantity: order['quantity'],
                    productPrice: order['priceDetails']['price'],
                    uniqueCode: order['pickupCode'],
                    orderStatus: _getOrderStatus(order),
                    middleman: order['providedMiddleman'] ?? {},
                    shippingAddress:
                        order['shippingAddress'] as Map<String, dynamic>?,
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 100.h,
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 16.h),
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
                      fontSize: 35.sp,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    ' •',
                    style: TextStyle(
                      fontSize: 35.sp,
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
                  fontSize: 20.sp,
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

  Widget _buildOrderSummary(
      BuildContext context, List<QueryDocumentSnapshot> validOrders) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$orderType Orders',
            style: TextStyle(
              color: hexToColor('#343434'),
              fontSize: 27.sp,
            ),
          ),
          Text(
            '${validOrders.length}',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 27.sp,
            ),
          ),
        ],
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
  final int productQuantity;
  final double productPrice;
  final String? uniqueCode;
  final OrderStatus orderStatus;
  final Map<String, dynamic> middleman;
  final Map<String, dynamic>? shippingAddress;
  final String? cancelReason;

  OrderCard({
    required this.productName,
    required this.productImage,
    required this.orderId,
    required this.productQuantity,
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
          padding: EdgeInsets.all(12.w),
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            border: Border.all(color: hexToColor('#8F8F8F')),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 125.h,
                    width: 112.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      image: DecorationImage(
                        image: NetworkImage(productImage),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName,
                          style: TextStyle(
                            color: hexToColor('#343434'),
                            fontSize: 17.sp,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Order ID:',
                              style: TextStyle(
                                color: hexToColor('#878787'),
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              orderId,
                              style: TextStyle(
                                color: hexToColor('#A9A9A9'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Quantity:',
                              style: TextStyle(
                                color: hexToColor('#878787'),
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              '$productQuantity',
                              style: TextStyle(
                                color: hexToColor('#A9A9A9'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          '₹${(productPrice * productQuantity).toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16.sp,
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
                          fontSize: 17.sp,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        middleman['name'] ?? 'Yet to assign',
                        style: TextStyle(
                          color: hexToColor('#878787'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        middleman['phone'] ?? 'Yet to assign',
                        style: TextStyle(
                          color: hexToColor('#878787'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      if (orderStatus == OrderStatus.Ongoing)
                        Text(
                          '$uniqueCode',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 30.sp,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              if (orderStatus == OrderStatus.Ongoing ||
                  orderStatus == OrderStatus.Delivered)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivery Address:",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        _formatShippingAddress(),
                        style: TextStyle(
                          color: hexToColor('#878787'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
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
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        cancelReason ?? 'Not Available',
                        style: TextStyle(
                          color: hexToColor('#878787'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
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

  String _formatShippingAddress() {
    if (shippingAddress == null) {
      return 'Not Available';
    }
    final city = shippingAddress!['city'] ?? '';
    final zip = shippingAddress!['zip'] ?? '';
    final state = shippingAddress!['state'] ?? '';
    return [city, zip, state].where((e) => e.isNotEmpty).join(', ');
  }
}
