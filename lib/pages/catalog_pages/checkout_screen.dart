import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/models/store_model.dart';
import 'package:tnennt/pages/catalog_pages/store_coupon_screen.dart';

class CheckoutScreen extends StatefulWidget {
  List<Map<String, dynamic>> selectedItems;

  CheckoutScreen({required this.selectedItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late List<Map<String, dynamic>> _items;
  double _totalAmount = 0.0;
  Map<String, dynamic>? _userAddress;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.selectedItems);
    _calculateTotalAmount();
    _loadUserAddress();
  }

  Future<void> _loadUserAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();
    setState(() {
      _userAddress = userData.data()?['address'];
    });
  }

  void _calculateTotalAmount() {
    _totalAmount = _items.fold(
        0,
            (sum, item) =>
        sum + (item['variationDetails'].price * item['quantity']));
  }

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity > 0) {
        _items[index]['quantity'] = newQuantity;
      } else {
        _items.removeAt(index);
      }
      _calculateTotalAmount();
    });
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
                          fontSize: 24.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        ' •',
                        style: TextStyle(
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
            if (_userAddress == null)
              Card(
                margin: EdgeInsets.all(16.0),
                color: Colors.white,
                surfaceTintColor: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No Address Added',
                        style: TextStyle(
                          color: hexToColor('#2D332F'),
                          fontSize: 22.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeAddressScreen(),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                _userAddress = result;
                              });
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 300,
                            margin: EdgeInsets.symmetric(vertical: 15.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: Center(
                              child: Text(
                                'Add Your Address',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_userAddress != null)
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
                            _userAddress!['name'],
                            style: TextStyle(
                              color: hexToColor('#2D332F'),
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
                              _userAddress!['type'],
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
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
                              '${_userAddress!['addressLine1']},',
                              style: TextStyle(
                                color: hexToColor('#727272'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              _userAddress!['addressLine2'],
                              style: TextStyle(
                                color: hexToColor('#727272'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              '${_userAddress!['city']}, ${_userAddress!['state']} ${_userAddress!['zip']}',
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
                            _userAddress!['phone'],
                            style: TextStyle(
                              color: hexToColor('#2D332F'),
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.0),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeAddressScreen(
                                    existingAddress: _userAddress),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                _userAddress = result;
                              });
                            }
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
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return CheckoutItemTile(
                    item: _items[index],
                    onUpdateQuantity: (newQuantity) =>
                        _updateQuantity(index, newQuantity),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹${_totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SummaryScreen(items: _items),
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
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
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

class ChangeAddressScreen extends StatefulWidget {
  final Map<String, dynamic>? existingAddress;

  ChangeAddressScreen({this.existingAddress});

  @override
  State<ChangeAddressScreen> createState() => _ChangeAddressScreenState();
}

class _ChangeAddressScreenState extends State<ChangeAddressScreen> {
  String addressType = 'Home';

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
    _nameController =
        TextEditingController(text: widget.existingAddress?['name'] ?? '');
    _phoneController =
        TextEditingController(text: widget.existingAddress?['phone'] ?? '');
    _addressLine1Controller = TextEditingController(
        text: widget.existingAddress?['addressLine1'] ?? '');
    _addressLine2Controller = TextEditingController(
        text: widget.existingAddress?['addressLine2'] ?? '');
    _zipController =
        TextEditingController(text: widget.existingAddress?['zip'] ?? '');
    _cityController =
        TextEditingController(text: widget.existingAddress?['city'] ?? '');
    _stateController =
        TextEditingController(text: widget.existingAddress?['state'] ?? '');
    addressType = widget.existingAddress?['type'] ?? 'Home';
  }

  Future<void> _saveAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final addressData = {
      'name': _nameController.text,
      'phone': _phoneController.text,
      'addressLine1': _addressLine1Controller.text,
      'addressLine2': _addressLine2Controller.text,
      'zip': _zipController.text,
      'city': _cityController.text,
      'state': _stateController.text,
      'type': addressType,
    };

    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .update({
        'address': addressData,
      });
      Navigator.pop(context, addressData);
    } catch (e) {
      // Handle error (show a snackbar, for example)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save address: $e')),
      );
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
                  Row(
                    children: [
                      Text(
                        'Checkout'.toUpperCase(),
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.0),
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
              child: GestureDetector(
                onTap: _saveAddress,
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
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
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

  Widget _buildAddressType(String type) {
    bool isSelected = addressType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          addressType = isSelected ? '' : type;
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

class CheckoutItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(int) onUpdateQuantity;

  const CheckoutItemTile({
    Key? key,
    required this.item,
    required this.onUpdateQuantity,
  }) : super(key: key);

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
                  image: NetworkImage(item['productImage']),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['productName'],
                  style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400),
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
                    item['variation'],
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
                    Text(
                      '₹${item['variationDetails'].price}',
                      style: TextStyle(
                        color: hexToColor('#343434'),
                        fontSize: 22,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'M.R.P ₹${item['variationDetails'].mrp}',
                          style: TextStyle(
                            color: hexToColor('#B9B9B9'),
                            fontSize: 10,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: hexToColor('#B9B9B9'),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          '${item['variationDetails'].discount}% OFF',
                          style: TextStyle(
                            color: hexToColor('#FF0000'),
                            fontSize: 10,
                          ),
                        ),
                      ],
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
                      fontWeight: FontWeight.w400),
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
                        onPressed: () => onUpdateQuantity(item['quantity'] - 1),
                      ),
                      Text(
                        '${item['quantity']}',
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
                        onPressed: () => onUpdateQuantity(item['quantity'] + 1),
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

class SummaryItemTile extends StatelessWidget {
  final Map<String, dynamic> item;

  const SummaryItemTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
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
                  image: NetworkImage(item['productImage']),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['productName'],
                  style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400),
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
                    item['variation'],
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
                    Text(
                      '₹${item['variationDetails'].price}',
                      style: TextStyle(
                        color: hexToColor('#343434'),
                        fontSize: 22,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'M.R.P ₹${item['variationDetails'].mrp}',
                          style: TextStyle(
                            color: hexToColor('#B9B9B9'),
                            fontSize: 10,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: hexToColor('#B9B9B9'),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          '${item['variationDetails'].discount}% OFF',
                          style: TextStyle(
                            color: hexToColor('#FF0000'),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
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
  final List<Map<String, dynamic>> items;

  SummaryScreen({required this.items});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late Map<String, StoreModel> _storeDetails = {};
  late Map<String, String> _orderIds = {};
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchStoreDetails();
    _generateOrderIds();
    _calculateTotalAmount();
  }

  Future<void> _fetchStoreDetails() async {
    for (var item in widget.items) {
      String storeId = item['storeId'];
      if (!_storeDetails.containsKey(storeId)) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('Stores')
            .doc(storeId)
            .get();
        _storeDetails[storeId] = StoreModel.fromFirestore(doc);
      }
    }
    setState(() {});
  }

  void _generateOrderIds() {
    for (var item in widget.items) {
      String storeId = item['storeId'];
      if (!_orderIds.containsKey(storeId)) {
        _orderIds[storeId] = 'ORD${Random().nextInt(900000) + 100000}';
      }
    }
  }

  void _calculateTotalAmount() {
    _totalAmount = widget.items.fold(
        0,
            (sum, item) =>
        sum + (item['variationDetails'].price * item['quantity']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildStoreSection(),
                    SizedBox(height: 20),
                    _buildProductSection(),
                    SizedBox(height: 20),
                    _buildSummarySection(),
                  ],
                ),
              ),
            ),
            _buildPayButton(),
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
                'Summary'.toUpperCase(),
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
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreSection() {
    return Column(
      children: _storeDetails.entries.map((entry) {
        String storeId = entry.key;
        StoreModel store = entry.value;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  image: DecorationImage(
                    image: NetworkImage(store.logoUrl),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Row(children: [
                    Image.asset(
                      'assets/icons/globe.png',
                      width: 8,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      store.website,
                      style: TextStyle(
                        color: hexToColor('#A9A9A9'),
                        fontSize: 10.0,
                      ),
                    ),
                  ])
                ],
              ),
              Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Order ID:',
                    style: TextStyle(
                      color: hexToColor('#2D332F'),
                      fontSize: 12.0,
                    ),
                  ),
                  SizedBox(width: 4.0),
                  Text(
                    _orderIds[storeId]!,
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
        );
      }).toList(),
    );
  }

  Widget _buildProductSection() {
    return Column(
      children:
      widget.items.map((item) => SummaryItemTile(item: item)).toList(),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: TextStyle(color: hexToColor('#343434'), fontSize: 18.0),
          ),
          SizedBox(height: 20.0),
          ...widget.items.map((item) => _buildItemSummary(item)),
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
                style: TextStyle(color: hexToColor('#343434'), fontSize: 22.0),
              ),
              Text(
                '₹ ${_totalAmount.toStringAsFixed(2)}',
                style: TextStyle(color: hexToColor('#343434'), fontSize: 22.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemSummary(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item['productName'],
            style: TextStyle(
              color: hexToColor('#B9B9B9'),
              fontFamily: 'Gotham',
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          Text(
            '₹ ${(item['variationDetails'].price * item['quantity']).toStringAsFixed(2)}',
            style: TextStyle(color: hexToColor('#606060'), fontSize: 14.0),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentOptionScreen(
                items: widget.items,
                storeDetails: _storeDetails,
                orderIds: _orderIds,
                totalAmount: _totalAmount,
              ),
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
              'Pay ₹ ${_totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum ExpandedTile { none, upi, otherUpi, card }

class PaymentOptionScreen extends StatefulWidget {
  List<Map<String, dynamic>> items;
  Map<String, StoreModel> storeDetails;
  Map<String, String> orderIds;
  double totalAmount;

  PaymentOptionScreen({
    required this.items,
    required this.storeDetails,
    required this.orderIds,
    required this.totalAmount,
  });

  @override
  State<PaymentOptionScreen> createState() => _PaymentOptionScreenState();
}

class _PaymentOptionScreenState extends State<PaymentOptionScreen> {
  ExpandedTile expandedTile = ExpandedTile.none;

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
                          fontSize: 24.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        ' •',
                        style: TextStyle(
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
            /*ProductDetails(
              productImage: 'assets/product_image.png',
              productName: 'Nikon Camera',
              productPrice: '200',
            ),
            SizedBox(height: 50.0),*/
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Text(
                      'Select Payment Option',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w800,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    ExpansionTile(
                      key: Key('upi'),
                      initiallyExpanded: expandedTile == ExpandedTile.upi,
                      onExpansionChanged: (expanded) {
                        setState(() {
                          expandedTile =
                          expanded ? ExpandedTile.upi : ExpandedTile.none;
                        });
                      },
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
                              fontWeight: FontWeight.w800,
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
                              fontSize: 12.0,
                            ),
                          ),
                          onTap: () {},
                        ),
                        ExpansionTile(
                          key: Key('other_upi'),
                          initiallyExpanded:
                          expandedTile == ExpandedTile.otherUpi,
                          onExpansionChanged: (expanded) {
                            setState(() {
                              expandedTile = expanded
                                  ? ExpandedTile.otherUpi
                                  : ExpandedTile.upi;
                            });
                          },
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
                              fontSize: 12.0,
                            ),
                          ),
                          trailing: Text('ADD',
                              style: TextStyle(
                                color: hexToColor('#4B8284'),
                                fontFamily: 'Poppins',
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
                                      ),
                                      decoration: InputDecoration(
                                        helperText:
                                        'Your UPI ID will be encrypted and in 100% safe with us',
                                        helperStyle: TextStyle(
                                          color: hexToColor('#6F6F6F'),
                                          fontFamily: 'Poppins',
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
                    SizedBox(height: 16.0),
                    ExpansionTile(
                      key: Key('card'),
                      initiallyExpanded: expandedTile == ExpandedTile.card,
                      onExpansionChanged: (expanded) {
                        setState(() {
                          expandedTile =
                          expanded ? ExpandedTile.card : ExpandedTile.none;
                        });
                      },
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
                              fontWeight: FontWeight.w800,
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
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Card Number',
                                    hintStyle: TextStyle(
                                      color: hexToColor('#6F6F6F'),
                                      fontFamily: 'Poppins',
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
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Expiry(MM/YY)',
                                        hintStyle: TextStyle(
                                          color: hexToColor('#6F6F6F'),
                                          fontFamily: 'Poppins',
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
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'CVV',
                                        hintStyle: TextStyle(
                                          color: hexToColor('#6F6F6F'),
                                          fontFamily: 'Poppins',
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
                                      'Pay ₹ ${widget.totalAmount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.white,
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
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionScreen(
                              storeDetails: widget.storeDetails,
                              orderIds: widget.orderIds,
                              totalAmount: widget.totalAmount,
                              items: widget.items,  // Add this line
                            ),
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
                                fontWeight: FontWeight.w800,
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

class TransactionScreen extends StatefulWidget
{
  Map<String, StoreModel> storeDetails;
  Map<String, String> orderIds;
  double totalAmount;
  List<Map<String, dynamic>> items;  // Add this line

  TransactionScreen({
    required this.storeDetails,
    required this.orderIds,
    required this.totalAmount,
    required this.items,  // Add this line
  });

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  GlobalKey _globalKey = GlobalKey();
  Map<String, dynamic>? _userAddress;

  @override
  void initState() {
    super.initState();
    _loadUserAddress();
    _sendOrderToFirestore();
    ///_sendOrderToMiddleman();
  }

  Future<void> _loadUserAddress() async
  {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();
    setState(() {
      _userAddress = userData.data()?['address'];
    });
  }

  Future<void> _sendOrderToFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      for (var entry in widget.storeDetails.entries) {
        String storeId = entry.key;

        Map<String, dynamic> orderData = {
          "address": _userAddress,
          "date": Timestamp.now(),
          "email": user.email,
          "orderId": widget.orderIds[storeId],
          "status": {
            "delivered": null,
            "ordered": Timestamp.now(),
          },
          "storeId": storeId,
          "totalAmount": widget.totalAmount,
          "userid": user.uid,
          "time": Timestamp.now(),
        };

        await FirebaseFirestore.instance.collection('Orders').add(orderData);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending order data: $e')),
      );
    }
  }

  Future<Uint8List?> _capturePng() async {
    try
    {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    }
    catch (e)
    {
      print(e);
      return null;
    }
  }

  /*Future<void> _sendOrderToMiddleman() async {
    try {
      print("Starting to send order to middleman");
      for (var entry in widget.storeDetails.entries) {
        String storeId = entry.key;
        StoreModel store = entry.value;

        Map<String, dynamic> order = {
          "DropOfAddress": "${_userAddress?['addressLine1']}, ${_userAddress?['addressLine2']}, ${_userAddress?['city']}, ${_userAddress?['state']} ${_userAddress?['zip']}",
          "OrderTotal": widget.totalAmount,
          "PickUpAddress": store.address,
          "StoreLogo": store.logoUrl,
          "StoreName": store.name,
          "deliveryId": widget.orderIds[storeId],
          "items": widget.items.where((item) => item['storeId'] == storeId).map((item) => {
            "name": item['productName'],
            "price": item['variationDetails'].price,
            "quantity": item['quantity'],
          }).toList(),
          "paymentMethod": "Cash on Delivery"
        };

        print("Attempting to send order: $order");
        await FirebaseFirestore.instance.collection('middleman_orders').add(order);
        print("Order sent successfully");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order sent to middleman_orders successfully')),
      );
    } catch (e) {
      print("Error sending order to middleman: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending order: $e')),
      );
    }
  }*/


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

                      /*if (imageBytes != null) {
                        final result = await ImageGallerySaver.saveImage(
                          Uint8List.fromList(imageBytes),
                        );
                        print(result);
                      }*/
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
                          SizedBox(
                              height:
                              MediaQuery.of(context).size.height * 0.05),
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
                                      _userAddress!['name'],
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
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      '₹ ${widget.totalAmount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: hexToColor('#343434'),
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.0),
                                Container(
                                  height:
                                  MediaQuery.of(context).size.height * 0.1,
                                  decoration: BoxDecoration(
                                    color: hexToColor('#FFFFFF'),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.1),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        ...widget.orderIds.entries.map((entry) =>
                                            Row(
                                              children: [
                                                Text(
                                                  'Order ID:',
                                                  style: TextStyle(
                                                    color: hexToColor('#2D332F'),
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  entry.value,
                                                  style: TextStyle(
                                                    color: hexToColor('#A9A9A9'),
                                                    fontSize: 18.0,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),).toList(),
                                      ],
                                    ),
                                    Spacer(),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: hexToColor('#094446')),
                                          borderRadius:
                                          BorderRadius.circular(12.0),
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
                                        ))
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
