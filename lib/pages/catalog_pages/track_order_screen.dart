import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../helpers/color_utils.dart';

class TrackOrderScreen extends StatefulWidget {
  final String productId;
  final String variation;

  const TrackOrderScreen({
    Key? key,
    required this.productId,
    required this.variation,
  }) : super(key: key);

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  bool isLoading = true;
  String productImage = '';
  String productName = '';
  int productPrice = 0;
  String orderId = '';
  List<OrderStatus> orderStatuses = [];
  String middlemanName = '';
  String middlemanPhone = '';
  String middlemanImageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final orderDoc = await FirebaseFirestore.instance
            .collection('Orders')
            .where('userid', isEqualTo: user.uid)
            .where('items', arrayContains: {
          'productId': widget.productId,
          'variation': widget.variation,
        })
            .limit(1)
            .get();

        if (orderDoc.docs.isNotEmpty) {
          final orderData = orderDoc.docs.first.data();
          orderId = orderData['orderId'] ?? '';

          // Fetch product details
          final productDoc = await FirebaseFirestore.instance
              .collection('products')
              .doc(widget.productId)
              .get();
          final productData = productDoc.data();

          if (productData != null) {
            setState(() {
              productName = productData['name'] ?? 'Unknown Product';
              final imageUrls = productData['imageUrls'] as List<dynamic>? ?? [];
              productImage = imageUrls.isNotEmpty ? imageUrls[0] : '';
              final items = orderData['items'] as List<dynamic>? ?? [];
              final item = items.firstWhere(
                    (item) => item['productId'] == widget.productId && item['variation'] == widget.variation,
                orElse: () => {},
              );
              productPrice = (item['price'] as num?)?.toInt() ?? 0;
            });
          }

          // Create order statuses based on the status map
          final statusMap = orderData['status'] as Map<String, dynamic>? ?? {};
          orderStatuses = [
            OrderStatus(
              title: 'Ordered',
              description: 'Your order has been placed',
              time: (statusMap['ordered'] as Timestamp?)?.toDate().toString() ?? '',
            ),
            OrderStatus(
              title: 'Delivered',
              description: 'Your order has been delivered',
              time: (statusMap['delivered'] as Timestamp?)?.toDate().toString() ?? '',
              isError: statusMap['delivered'] == null,
            ),
          ];

          // Middleman details are not present in the new schema
          // You might want to remove or modify this part
          middlemanName = 'Not available';
          middlemanPhone = 'N/A';
          middlemanImageUrl = '';
        }
      }
    } catch (e) {
      print('Error fetching order details: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            _buildAppBar(),
            _buildProductInfo(),
            SizedBox(height: 50.0),
            OrderStatusWidget(status: orderStatuses),
            Spacer(),
            _buildMiddlemanInfo(),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
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
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
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
                image: NetworkImage(productImage),
                fit: BoxFit.cover,
                onError: (_, __) => AssetImage('assets/placeholder_image.png'),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: TextStyle(color: hexToColor('#343434'), fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      'Order ID:',
                      style: TextStyle(color: hexToColor('#878787'), fontSize: 14.0),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      orderId,
                      style: TextStyle(
                        color: hexToColor('#A9A9A9'),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.0),
                Text(
                  '₹ $productPrice',
                  style: TextStyle(color: hexToColor('#343434'), fontSize: 18.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiddlemanInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Provided Middlemen:',
                  style: TextStyle(color: hexToColor('#343434'), fontSize: 16.0),
                ),
                SizedBox(height: 15.0),
                Text(
                  middlemanName,
                  style: TextStyle(
                    color: hexToColor('#727272'),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                  ),
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
                      middlemanPhone,
                      style: TextStyle(
                        color: hexToColor('#727272'),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              image: DecorationImage(
                image: middlemanImageUrl.isNotEmpty
                    ? NetworkImage(middlemanImageUrl)
                    : AssetImage('assets/default_profile_image.png') as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
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
      padding: EdgeInsets.symmetric(horizontal: 12.0),
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