import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailScreen extends StatefulWidget {
  final String productId;
  final String variation;

  DetailScreen({
    Key? key,
    required this.productId,
    required this.variation,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isLoading = true;
  late ProductDetails productDetails;
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserId();
  }

  Future<void> fetchCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;
      fetchDetails();
    } else {
      setState(() {
        isLoading = false;
      });
      // Handle the case where there is no authenticated user
    }
  }

  Future<void> fetchDetails() async {
    try {
      productDetails = ProductDetails();
      await Future.wait([
        _fetchProductDetails(widget.productId, widget.variation),
        _fetchOrderDetails(currentUserId),
        _fetchUserDetails(currentUserId),
      ]);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching details: $e');
      // Handle the error, perhaps show an error message to the user
    }
  }

  Future<void> _fetchProductDetails(String productId, String variation) async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      productDetails.productImage = data['productImage'] ?? '';
      productDetails.productName = data['productName'] ?? '';

      var variations = data['variations'];
      if (variations is Map<String, dynamic> && variations.containsKey(variation)) {
        var selectedVariationData = variations[variation];
        if (selectedVariationData is Map<String, dynamic>) {
          productDetails.selectedVariation = variation;
          productDetails.variationDetails = VariationDetails(
            discount: selectedVariationData['discount'] ?? 0,
            mrp: selectedVariationData['mrp'] ?? 0,
            price: selectedVariationData['price'] ?? 0,
          );
        } else {
          print('Selected variation data is not a Map: $selectedVariationData');
        }
      } else {
        print('Variation not found: $variation');
      }
    }
  }

  Future<void> _fetchOrderDetails(String userId) async {
    QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
        .collection('Middleman_Orders')
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: widget.productId)
        .where('variation', isEqualTo: widget.variation)
        .limit(1)
        .get();

    if (orderSnapshot.docs.isNotEmpty) {
      Map<String, dynamic> orderData = orderSnapshot.docs.first.data() as Map<String, dynamic>;
      productDetails.orderDetails = OrderDetails(
        dropOffAddress: orderData['dropOffAddress'] ?? '',
        paymentMethod: orderData['paymentMethod'] ?? '',
        paymentStatus: orderData['paymentStatus'] ?? '',
      );
    }
  }

  Future<void> _fetchUserDetails(String userId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      productDetails.userDetails = UserDetails(
        name: userData['name'] ?? '',
        phone: userData['phone'] ?? '',
        address: userData['address'] ?? '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductInfo(),
                    SizedBox(height: 40.0),
                    _buildMiddlemanInfo(),
                    SizedBox(height: 40.0),
                    _buildAmountDetails(),
                    SizedBox(height: 40.0),
                    _buildPaymentDetails(),
                    SizedBox(height: 40.0),
                    _buildDeliveryDetails(),
                    SizedBox(height: 30.0),
                    _buildCancelOrderButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
                image: NetworkImage(productDetails.productImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productDetails.productName,
                style: TextStyle(
                  color: hexToColor('#343434'),
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Variation: ${productDetails.selectedVariation}',
                style: TextStyle(
                  color: hexToColor('#727272'),
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Text(
                    '₹${productDetails.variationDetails.price}',
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    '₹${productDetails.variationDetails.mrp}',
                    style: TextStyle(
                      color: hexToColor('#727272'),
                      fontSize: 14.0,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ],
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Provided Middlemen:',
                style: TextStyle(
                  color: hexToColor('#343434'),
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                'Mr. Kamran Khan',
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
                    '+91 8097905879',
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
    );
  }

  Widget _buildAmountDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amount Details:',
            style: TextStyle(
              color: hexToColor('#343434'),
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAmountRow('Subtotal', '₹ ${productDetails.variationDetails.mrp}'),
                _buildAmountRow('Discount', '- ₹ ${productDetails.variationDetails.mrp - productDetails.variationDetails.price}'),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15.0),
            height: 0.75,
            color: hexToColor('#2B2B2B'),
          ),
          _buildAmountRow('Total Amount', '₹ ${productDetails.variationDetails.price}', isBold: true),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, String amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? hexToColor('#343434') : hexToColor('#727272'),
            fontFamily: 'Poppins',
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontSize: isBold ? 16.0 : 14.0,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: isBold ? hexToColor('#343434') : hexToColor('#727272'),
            fontFamily: 'Poppins',
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontSize: isBold ? 16.0 : 14.0,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Details:',
            style: TextStyle(
              color: hexToColor('#343434'),
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPaymentRow('Payment Mode', productDetails.orderDetails.paymentMethod),
                _buildPaymentRow('Payment Status', productDetails.orderDetails.paymentStatus),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: hexToColor('#727272'),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: hexToColor('#727272'),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Details:',
            style: TextStyle(
              color: hexToColor('#343434'),
              fontSize: 16.0,
            ),
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
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  productDetails.orderDetails.dropOffAddress,
                  style: TextStyle(
                    color: hexToColor('#727272'),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelOrderButton() {
    return Center(
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
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetails{
  String productImage = '';
  String productName = '';
  String selectedVariation = '';
  late VariationDetails variationDetails;
  late OrderDetails orderDetails;
  late UserDetails userDetails;
}

class VariationDetails {
  final double discount;
  final double mrp;
  final double price;

  VariationDetails({
    required this.discount,
    required this.mrp,
    required this.price,
  });
}

class OrderDetails {
  final String dropOffAddress;
  final String paymentMethod;
  final String paymentStatus;

  OrderDetails({
    required this.dropOffAddress,
    required this.paymentMethod,
    required this.paymentStatus,
  });
}

class UserDetails {
  final String name;
  final String phone;
  final String address;

  UserDetails({
    required this.name,
    required this.phone,
    required this.address,
  });
}