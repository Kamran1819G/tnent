import 'dart:io';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:tnent/core/helpers/color_utils.dart';
import 'package:tnent/models/product_model.dart';
import 'package:tnent/models/store_model.dart';
import 'package:tnent/presentation/pages/home_screen.dart';
import '../../../core/helpers/snackbar_utils.dart';

class CheckoutScreen extends StatefulWidget {
  List<Map<String, dynamic>> selectedItems;

  CheckoutScreen({super.key, required this.selectedItems});

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
              height: 100.h,
              margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Checkout'.toUpperCase(),
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
                          color: hexToColor('#FF0000'),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.grey[100],
                      ),
                      shape: MaterialStateProperty.all(
                        const CircleBorder(),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            if (_userAddress == null)
              Card(
                margin: EdgeInsets.all(24.w),
                color: Colors.white,
                surfaceTintColor: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No Address Added',
                        style: TextStyle(
                          color: hexToColor('#2D332F'),
                          fontSize: 28.sp,
                        ),
                      ),
                      SizedBox(height: 24.h),
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
                            height: 85.h,
                            width: 545.w,
                            margin: EdgeInsets.symmetric(vertical: 22.h),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            child: Text(
                              'Add Your Address',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.sp),
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
                margin: EdgeInsets.all(24.w),
                color: Colors.white,
                surfaceTintColor: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(24.w),
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
                              fontSize: 32.sp,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 8.h),
                            height: 55.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            child: Text(
                              _userAddress!['type'],
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.sp,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: 325.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_userAddress!['addressLine1']},',
                              style: TextStyle(
                                color: hexToColor('#727272'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 18.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              _userAddress!['addressLine2'],
                              style: TextStyle(
                                color: hexToColor('#727272'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 18.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '${_userAddress!['city']}, ${_userAddress!['state']} ${_userAddress!['zip']}',
                              style: TextStyle(
                                color: hexToColor('#727272'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Text(
                            'Mobile:',
                            style: TextStyle(
                              color: hexToColor('#727272'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 18.sp,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            _userAddress!['phone'],
                            style: TextStyle(
                              color: hexToColor('#2D332F'),
                              fontSize: 18.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 35.h),
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
                            height: 85.h,
                            width: 545.w,
                            margin: EdgeInsets.symmetric(vertical: 22.h),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: hexToColor('#E3E3E3')),
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            child: Center(
                              child: Text(
                                'Change Your Address',
                                style: TextStyle(
                                    color: hexToColor('#343434'),
                                    fontSize: 16.sp),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 24.h),
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
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount:',
                    style: TextStyle(fontSize: 26.sp),
                  ),
                  Text(
                    '₹${_totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 26.sp, color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  if (_userAddress == null) {
                    showSnackBar(
                        context, 'Please add your address to continue');

                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SummaryScreen(items: _items),
                    ),
                  );
                },
                child: Container(
                  height: 95.h,
                  width: 470.w,
                  margin: EdgeInsets.symmetric(vertical: 22.h),
                  decoration: BoxDecoration(
                    color: hexToColor('#2B2B2B'),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Gotham',
                          fontSize: 25.sp),
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

  ChangeAddressScreen({super.key, this.existingAddress});

  @override
  State<ChangeAddressScreen> createState() => _ChangeAddressScreenState();
}

class _ChangeAddressScreenState extends State<ChangeAddressScreen> {
  final _formKey = GlobalKey<FormState>();
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

    if (_formKey.currentState?.validate() ?? false) {
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

        showSnackBar(context, 'Failed to save address: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 100.h,
                margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Checkout'.toUpperCase(),
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
                            color: hexToColor('#FF0000'),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.grey[100],
                        ),
                        shape: MaterialStateProperty.all(
                          const CircleBorder(),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 22.w),
                        width: 460.w,
                        child: _buildTextFormField(
                          controller: _nameController,
                          labelText: 'Name',
                          hintText: 'Enter Name',
                          prefixIcon: Icons.person_outline,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 50.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 22.w),
                        width: 460.w,
                        child: _buildTextFormField(
                          controller: _phoneController,
                          labelText: 'Mobile Number',
                          hintText: 'XXXXX-XXXXX',
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mobile Number is required';
                            }
                            if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                              return 'Enter a valid mobile number';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 50.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 22.w),
                        width: 460.w,
                        child: _buildTextFormField(
                          controller: _addressLine1Controller,
                          labelText: 'Flat/ Housing No./ Building/ Apartment',
                          hintText: 'Address Line 1',
                          prefixIcon: Icons.location_on_outlined,
                          keyboardType: TextInputType.streetAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Address Line 1 is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 50.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 22.w),
                        width: 460.w,
                        child: _buildTextFormField(
                          controller: _addressLine2Controller,
                          labelText: 'Area/ Street/ Sector',
                          hintText: 'Address Line 2',
                          prefixIcon: Icons.location_on_outlined,
                          keyboardType: TextInputType.streetAddress,
                        ),
                      ),
                      SizedBox(height: 50.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 22.w),
                        width: 340.w,
                        child: _buildTextFormField(
                          controller: _zipController,
                          labelText: 'Pincode',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Pincode is required';
                            }
                            if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
                              return 'Enter a valid pincode';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 50.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 22.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 280.w,
                              child: _buildTextFormField(
                                controller: _cityController,
                                labelText: 'City',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'City is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 300.w,
                              child: _buildTextFormField(
                                controller: _stateController,
                                labelText: 'State',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'State is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.h),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        width: 300.w,
                        child: Row(
                          children: [
                            _buildAddressType('Home'),
                            const SizedBox(width: 10.0),
                            _buildAddressType('Office'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: _saveAddress,
                  child: Container(
                    height: 95.h,
                    width: 470.w,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 22.h),
                    decoration: BoxDecoration(
                      color: hexToColor('#2B2B2B'),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Text(
                      'Confirm Address',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Gotham',
                          fontSize: 25.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        height: 55.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: hexToColor('#343434')),
          color: isSelected ? hexToColor('#343434') : Colors.white,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Text(
          type,
          style: TextStyle(
              color: isSelected ? Colors.white : hexToColor('#343434'),
              fontSize: 18.sp),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    String? labelText,
    String? hintText,
    IconData? prefixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
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
      validator: validator,
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
      margin: EdgeInsets.all(16.w),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Container(
        width: 600.w,
        height: 250.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 185.h,
              width: 165.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                image: DecorationImage(
                  image: NetworkImage(item['productImage']),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(width: 20.w),
            SizedBox(
              height: 185.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['productName'],
                    style: TextStyle(
                        color: hexToColor('#343434'),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  if (item['variation'] != 'default') ...[
                    SizedBox(height: 12.h),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: hexToColor('#D0D0D0')),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        item['variation'],
                        style: TextStyle(
                            color: hexToColor('#222230'),
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹${item['variationDetails'].price}',
                        style: TextStyle(
                          color: hexToColor('#343434'),
                          fontSize: 34.sp,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'M.R.P ₹${item['variationDetails'].mrp}',
                            style: TextStyle(
                              color: hexToColor('#B9B9B9'),
                              fontSize: 16.sp,
                              decoration: item['variationDetails'].discount > 0
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              decorationColor: hexToColor('#B9B9B9'),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          if (item['variationDetails'].discount > 0)
                            Text(
                              '${item['variationDetails'].discount}% OFF',
                              style: TextStyle(
                                color: hexToColor('#FF0000'),
                                fontSize: 16.sp,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Quantity'.toUpperCase(),
                  style: TextStyle(
                      color: hexToColor('#222230'),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 6.h),
                Container(
                  height: 45.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: hexToColor('#D0D0D0')),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        iconSize: 14.sp,
                        onPressed: () => onUpdateQuantity(item['quantity'] - 1),
                      ),
                      Text(
                        '${item['quantity']}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          color: hexToColor('#222230'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        iconSize: 14.sp,
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
      color: Colors.white,
      surfaceTintColor: Colors.white,
      margin: EdgeInsets.all(16.w),
      child: Container(
        width: 600.w,
        height: 250.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              // Text(
              //   'Order ID: ${item['orderId']}',
              //   style: TextStyle(
              //     color: hexToColor('#A9A9A9'),
              //     fontSize: 17.sp,
              //     fontFamily: 'Poppins',
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              Text(
                '  Remove',
                style: TextStyle(
                  color: hexToColor('#A9A9A9'),
                  fontSize: 17.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 185.h,
                  width: 165.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    image: DecorationImage(
                      image: NetworkImage(item['productImage']),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                SizedBox(
                  height: 185.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['productName'],
                        style: TextStyle(
                            color: hexToColor('#343434'),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      if (item['variation'] != 'default') ...[
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: hexToColor('#D0D0D0')),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            item['variation'],
                            style: TextStyle(
                                color: hexToColor('#222230'),
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp),
                          ),
                        ),
                      ],
                      SizedBox(height: 20.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${item['variationDetails'].price}',
                            style: TextStyle(
                              color: hexToColor('#343434'),
                              fontSize: 34.sp,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'M.R.P ₹${item['variationDetails'].mrp}',
                                style: TextStyle(
                                  color: hexToColor('#B9B9B9'),
                                  fontSize: 16.sp,
                                  decoration:
                                      item['variationDetails'].discount > 0
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                  decorationColor: hexToColor('#B9B9B9'),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              if (item['variationDetails'].discount > 0)
                                Text(
                                  '${item['variationDetails'].discount}% OFF',
                                  style: TextStyle(
                                    color: hexToColor('#FF0000'),
                                    fontSize: 16.sp,
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
          ],
        ),
      ),
    );
  }
}

class SummaryScreen extends StatefulWidget {
  List<Map<String, dynamic>> items;

  SummaryScreen({super.key, required this.items});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late Map<String, StoreModel> _storeDetails = {};
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
      String timestamp =
          DateTime.now().millisecondsSinceEpoch.toString().substring(12);
      String randomComponent =
          Random().nextInt(900000).toString().padLeft(3, '0');
      item['orderId'] = 'ORD${timestamp}$randomComponent';
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
                    const SizedBox(height: 20),
                    _buildProductSection(),
                    const SizedBox(height: 20),
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
      height: 100.h,
      margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          Row(
            children: [
              Text(
                'Summary'.toUpperCase(),
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
                  color: hexToColor('#FF0000'),
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.grey[100],
              ),
              shape: MaterialStateProperty.all(
                const CircleBorder(),
              ),
            ),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
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
          padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                height: 80.h,
                width: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  image: DecorationImage(
                    image: NetworkImage(store.logoUrl),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 25.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(children: [
                    Image.asset(
                      'assets/icons/globe.png',
                      width: 14.w,
                    ),
                    SizedBox(width: 6.h),
                    Text(
                      '${store.storeDomain}.tnent.com',
                      style: TextStyle(
                        color: hexToColor('#A9A9A9'),
                        fontSize: 14.sp,
                      ),
                    ),
                  ])
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
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: TextStyle(color: hexToColor('#343434'), fontSize: 24.sp),
          ),
          const SizedBox(height: 20.0),
          ...widget.items.map((item) => _buildItemSummary(item)),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.h),
            height: 1.h,
            color: hexToColor('#E3E3E3'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(color: hexToColor('#343434'), fontSize: 30.sp),
              ),
              Text(
                '₹ ${_totalAmount.toStringAsFixed(2)}',
                style: TextStyle(color: hexToColor('#343434'), fontSize: 30.sp),
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
              fontSize: 18.sp,
            ),
          ),
          Text(
            '₹ ${(item['variationDetails'].price * item['quantity']).toStringAsFixed(2)}',
            style: TextStyle(color: hexToColor('#606060'), fontSize: 18.sp),
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
                totalAmount: _totalAmount,
              ),
            ),
          );
        },
        child: Container(
          height: 95.h,
          width: 600.w,
          margin: EdgeInsets.symmetric(vertical: 22.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Text(
            'Pay ₹ ${_totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
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
  double totalAmount;

  PaymentOptionScreen({
    super.key,
    required this.items,
    required this.storeDetails,
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
              height: 100.h,
              margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Checkout'.toUpperCase(),
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
                          color: hexToColor('#FF0000'),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.grey[100],
                      ),
                      shape: MaterialStateProperty.all(
                        const CircleBorder(),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100.h),
                    Text(
                      'Select Payment Option',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w800,
                        fontSize: 24.sp,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    ExpansionTile(
                      key: const Key('upi'),
                      initiallyExpanded: expandedTile == ExpandedTile.upi,
                      onExpansionChanged: (expanded) {
                        setState(() {
                          expandedTile =
                              expanded ? ExpandedTile.upi : ExpandedTile.none;
                        });
                      },
                      collapsedShape: RoundedRectangleBorder(
                        side: BorderSide(color: hexToColor('#E0E0E0')),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: hexToColor('#E0E0E0')),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      leading: Icon(
                        Icons.phone_android,
                        size: 25.sp,
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
                              fontSize: 22.sp,
                            ),
                          ),
                          Text(
                            'Pay by an UPI app',
                            style: TextStyle(
                              color: hexToColor('#6F6F6F'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            ),
                          )
                        ],
                      ),
                      children: [
                        ListTile(
                          leading: Container(
                            width: 60.w,
                            height: 35.h,
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: hexToColor('#E0E0E0')),
                              borderRadius: BorderRadius.circular(8.r),
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
                              fontSize: 16.sp,
                            ),
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Container(
                            width: 60.w,
                            height: 35.h,
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: hexToColor('#E0E0E0')),
                              borderRadius: BorderRadius.circular(8.r),
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
                              fontSize: 16.sp,
                            ),
                          ),
                          onTap: () {},
                        ),
                        ExpansionTile(
                          key: const Key('other_upi'),
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
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          leading: Container(
                            width: 60.w,
                            height: 35.h,
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: hexToColor('#E0E0E0')),
                              borderRadius: BorderRadius.circular(8.r),
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
                              fontSize: 16.sp,
                            ),
                          ),
                          trailing: Text('ADD',
                              style: TextStyle(
                                color: hexToColor('#4B8284'),
                                fontFamily: 'Poppins',
                                fontSize: 16.sp,
                              )),
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 35.w, vertical: 15.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 415.w,
                                        height: 55.h,
                                        child: TextField(
                                          style: TextStyle(
                                            color: hexToColor('#2A2A2A'),
                                            fontFamily: 'Gotham',
                                            fontSize: 14,
                                          ),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              borderSide: BorderSide(
                                                color: hexToColor('#E0E0E0'),
                                                width: 1.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      CircleAvatar(
                                        radius: 22.w,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 20.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Your UPI ID will be encrypted and in 100% safe with us',
                                    style: TextStyle(
                                      color: hexToColor('#6F6F6F'),
                                      fontFamily: 'Poppins',
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    ExpansionTile(
                      key: const Key('card'),
                      initiallyExpanded: expandedTile == ExpandedTile.card,
                      onExpansionChanged: (expanded) {
                        setState(() {
                          expandedTile =
                              expanded ? ExpandedTile.card : ExpandedTile.none;
                        });
                      },
                      collapsedShape: RoundedRectangleBorder(
                        side: BorderSide(color: hexToColor('#E0E0E0')),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: hexToColor('#E0E0E0')),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      leading: Icon(
                        Icons.credit_card,
                        size: 25.sp,
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
                              fontSize: 22.sp,
                            ),
                          ),
                          Text(
                            'Visa, Mastercard, Rupay & more',
                            style: TextStyle(
                              color: hexToColor('#6F6F6F'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            ),
                          )
                        ],
                      ),
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 415.w,
                                height: 55.h,
                                child: TextField(
                                  style: TextStyle(
                                    color: hexToColor('#2A2A2A'),
                                    fontFamily: 'Gotham',
                                    fontSize: 18.sp,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Card Number',
                                    hintStyle: TextStyle(
                                      color: hexToColor('#6F6F6F'),
                                      fontFamily: 'Poppins',
                                      fontSize: 15.sp,
                                    ),
                                    border: OutlineInputBorder(
                                      gapPadding: 0,
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(
                                        color: hexToColor('#E0E0E0'),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 200.w,
                                    height: 55.h,
                                    child: TextField(
                                      style: TextStyle(
                                        color: hexToColor('#2A2A2A'),
                                        fontFamily: 'Gotham',
                                        fontSize: 18.sp,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Expiry(MM/YY)',
                                        hintStyle: TextStyle(
                                          color: hexToColor('#6F6F6F'),
                                          fontFamily: 'Poppins',
                                          fontSize: 15.sp,
                                        ),
                                        border: OutlineInputBorder(
                                          gapPadding: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          borderSide: BorderSide(
                                            color: hexToColor('#E0E0E0'),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  SizedBox(
                                    width: 200.w,
                                    height: 55.h,
                                    child: TextField(
                                      style: TextStyle(
                                        color: hexToColor('#2A2A2A'),
                                        fontFamily: 'Gotham',
                                        fontSize: 18.sp,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'CVV',
                                        hintStyle: TextStyle(
                                          color: hexToColor('#6F6F6F'),
                                          fontFamily: 'Poppins',
                                          fontSize: 15.sp,
                                        ),
                                        border: OutlineInputBorder(
                                          gapPadding: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
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
                                  height: 65.h,
                                  width: 500.w,
                                  margin: EdgeInsets.symmetric(vertical: 18.h),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(18.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Pay ₹ ${widget.totalAmount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 24.sp,
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
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () {
                        showSnackBarWithAction(
                          context,
                          text:
                              'Do you want to continue with Cash on Delivery?',
                          confirmBtnText: 'Continue 💵',
                          buttonTextFontsize: 11,
                          cancelBtnText: 'Cancel',
                          quickAlertType: QuickAlertType.confirm,
                          action: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionScreen(
                                  storeDetails: widget.storeDetails,
                                  totalAmount: widget.totalAmount,
                                  items: widget.items, // Add this line
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: hexToColor('#E0E0E0')),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        leading: Icon(
                          Icons.money,
                          size: 25.sp,
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
                                fontSize: 22.sp,
                              ),
                            ),
                            Text(
                              'Pay at your doorstep',
                              style: TextStyle(
                                color: hexToColor('#6F6F6F'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                              ),
                            )
                          ],
                        ),
                        trailing: const SizedBox(),
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

class TransactionScreen extends StatefulWidget {
  Map<String, StoreModel> storeDetails;
  double totalAmount;
  List<Map<String, dynamic>> items;

  TransactionScreen({
    super.key,
    required this.storeDetails,
    required this.totalAmount,
    required this.items,
  });

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late ConfettiController _confettiController;

  GlobalKey _globalKey = GlobalKey();
  bool isGreeting = false;
  late Map<String, dynamic> _userAddress;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _userAddress = await _loadUserAddress();
    /*processOrder();*/
    _isLoading = false;
    makeIsGreetingTrue();
    processOrder(widget.items);

    setState(() {});

    sendOrderNotification();
  }

  final user = FirebaseAuth.instance.currentUser!;
  void makeIsGreetingTrue() {
    isGreeting = true;
    _confettiController.play();
    Future.delayed(const Duration(seconds: 2, milliseconds: 500), () {
      isGreeting = false;
      setState(() {});
    });
    _startFadeIn();
  }

  Future<Map<String, dynamic>> _loadUserAddress() async {
    final userData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final address = userData.data()?['address'];
    if (address == null || address is! Map<String, dynamic>) {
      throw Exception('User address is missing or invalid');
    }

    return address;
  }

  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final _rnd = Random();

  String _getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> _sendOrderNotificationToStoreOwner(
      List<Map<String, dynamic>> items) async {
    for (var item in items) {
      double totalPrice = item['variationDetails'].price * item['quantity'];
      String orderId = item['orderId'];
      String storeId = item['storeId'];

      await NotificationSender.sendOrderNotificationToStoreOwner(
        orderId: orderId,
        storeId: storeId,
        productImage: item['productImage'],
        productName: item['productName'],
        price: totalPrice.toString(),
      );
    }
  }

  Future<void> processOrder(List<Map<String, dynamic>> items) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var item in items) {
        String pickupCode = _getRandomString(5);
        DocumentReference orderRef =
            FirebaseFirestore.instance.collection('Orders').doc();
        Map<String, dynamic> orderData = {
          'orderId': item['orderId'],
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'storeId': item['storeId'],
          'productId': item['productId'],
          'productName': item['productName'],
          'productImage': item['productImage'],
          'variation': item['variation'],
          'priceDetails': {
            'price': item['variationDetails'].price,
            'mrp': item['variationDetails'].mrp,
            'discount': item['variationDetails'].discount,
          },
          'quantity': item['quantity'],
          'status': {
            'ordered': {
              'timestamp': FieldValue.serverTimestamp(),
              'message': 'Order was placed',
            },
          },
          'orderAt': FieldValue.serverTimestamp(),
          'shippingAddress': await _loadUserAddress(),
          'pickupCode': pickupCode,
          'providedMiddleman': {},
          'payment': {
            'method': 'Cash on Delivery',
            'status': 'Pending',
          },
        };

        batch.set(orderRef, orderData);

        // Update stock quantity
        DocumentReference productRef = FirebaseFirestore.instance
            .collection('products')
            .doc(item['productId']);

        ProductModel product =
            ProductModel.fromFirestore(await productRef.get());

        bool isRestaurantCafeBakery = ['Restaurants', 'Cafes', 'Bakeries']
            .contains(product.productCategory);

        if (!isRestaurantCafeBakery) {
          batch.update(productRef, {
            'variations.${item['variation']}.stockQuantity':
                FieldValue.increment(-item['quantity'])
          });
        }
      }

      await batch.commit();

      // Send order notification to the store owner
      await _sendOrderNotificationToStoreOwner(items);
    } catch (e) {
      // Handle error
    }
  }

  /* Future<void> _loadUserAddress() async {
    final userData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    final address = userData.data()?['address'];
    if (address == null || !(address is Map<String, dynamic>)) {
      throw Exception('User address is missing or invalid');
    }

    setState(() {
      _userAddress = address;
    });
  }*/

  /*String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
*/
  /*Future<void> processOrder() async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var item in widget.items) {
        String pickupCode = getRandomString(5);
        DocumentReference orderRef =
            FirebaseFirestore.instance.collection('Orders').doc();
        Map<String, dynamic> orderData = {
          'orderId': item['orderId'],
          'userId': user.uid,
          'storeId': item['storeId'],
          'productId': item['productId'],
          'productName': item['productName'],
          'productImage': item['productImage'],
          'variation': item['variation'],
          'priceDetails': {
            'price': item['variationDetails'].price,
            'mrp': item['variationDetails'].mrp,
            'discount': item['variationDetails'].discount,
          },
          'quantity': item['quantity'],
          'status': {
            'ordered': {
              'timestamp': FieldValue.serverTimestamp(),
              'message': 'Order was placed',
            },
          },
          'orderAt': FieldValue.serverTimestamp(),
          'shippingAddress': _userAddress,
          'pickupCode': pickupCode,
          'providedMiddleman': {},
          'payment': {
            'method': 'Cash on Delivery',
            'status': 'Pending',
          },
        };

        batch.set(orderRef, orderData);

        // Update stock quantity
        DocumentReference productRef = FirebaseFirestore.instance
            .collection('products')
            .doc(item['productId']);

        batch.update(productRef, {
          'variations.${item['variation']}.stockQuantity':
              FieldValue.increment(-item['quantity'])
        });
      }

      await batch.commit();

      showSnackBar(context, 'Order placed successfully and stock updated');
    } catch (e) {
      showSnackBar(context, 'Error sending order data: $e');
    }
  }*/

  Future<void> sendOrderNotification() async {
    final firestore = FirebaseFirestore.instance;

    for (var item in widget.items) {
      // Calculate total price
      double totalPrice = item['variationDetails'].price * item['quantity'];

      // Store the notification in Firestore
      await firestore
          .collection('Users')
          .doc(user.uid)
          .collection('notifications')
          .add({
        'title': 'Order Placed',
        'body': 'Your order #${item['orderId']} has been placed successfully.',
        'data': {
          'type': 'general',
          'status': 'orderplaced',
          'productImage': item['productImage'],
          'productName': item['productName'],
          'price': totalPrice.toString(),
          'orderId': item['orderId'],
        },
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show local notification
      String bigPicturePath = await _downloadAndSaveFile(
          item['productImage'], 'orderImage_${item['orderId']}');

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'user_order_channel',
          title: 'Order Placed',
          body: 'Your order #${item['orderId']} has been placed successfully.',
          bigPicture: 'file://$bigPicturePath',
          notificationLayout: NotificationLayout.BigPicture,
          payload: {
            'orderId': item['orderId'].toString(),
            'productName': item['productName'].toString(),
          },
        ),
      );
    }
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
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

  double _opacity = 0.0;
  void _startFadeIn() {
    // Delay before starting the fade-in
    Future.delayed(const Duration(milliseconds: 2900), () {
      setState(() {
        _opacity = 1.0; // Fade in
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (isGreeting) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // _buildStoreRegistrationPageHeader(
              //     context, _pageController, _currentPageIndex),
              SizedBox(height: 100.h),
              Stack(
                alignment: Alignment.center,
                children: [
                  ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: [Theme.of(context).primaryColor],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.r),
                    child: Image.asset(
                      'assets/congratulation.png',
                      width: 425.w,
                      height: 340.h,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 200.h),
              SizedBox(
                width: 430.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Congratulations!',
                      style: TextStyle(
                        color: hexToColor('#2A2A2A'),
                        fontWeight: FontWeight.w500,
                        fontSize: 42.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Your Order has been placed',
                      style: TextStyle(
                        color: hexToColor('#636363'),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 28.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 300.h),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Hurray! Now we recommend you to',
                    style: TextStyle(
                      color: hexToColor('#636363'),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 17.sp,
                    ),
                  ),
                  Text(
                    'Join Our Tnent Community',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 17.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    if (_userAddress == null) {
      return const Scaffold(
        body: Center(
          child: Text('Error: User address not found'),
        ),
      );
    }
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 2900),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 100.h,
                margin: EdgeInsets.only(top: 20.h),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Colors.grey[100],
                        ),
                        shape: WidgetStateProperty.all(
                          const CircleBorder(),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.black),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
              RepaintBoundary(
                key: _globalKey,
                child: Stack(
                  children: [
                    Container(
                      height: 1150.h,
                      width: 680.w,
                      margin: EdgeInsets.symmetric(horizontal: 30.w),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/transaction_bg.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.0, 0.0),
                      child: Container(
                        margin: EdgeInsets.all(12.w),
                        child: CircleAvatar(
                          radius: 65.w,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Icon(Icons.check,
                              color: Colors.white, size: 45.sp),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.0, 0.0),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 175.h),
                            Text(
                              'Thank You!',
                              style: TextStyle(
                                color: hexToColor('#1E1E1E'),
                                fontSize: 36.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Your transaction is successful',
                              style: TextStyle(
                                color: hexToColor('#8E8E8E'),
                                fontFamily: 'Gotham',
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 50.h),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
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
                                          fontSize: 27.sp,
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd MMM yyyy')
                                            .format(DateTime.now()),
                                        style: TextStyle(
                                          color: hexToColor('#333333'),
                                          fontSize: 27.sp,
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Time:',
                                        style: TextStyle(
                                          color: hexToColor('#979797'),
                                          fontSize: 27.sp,
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('hh:mm a')
                                            .format(DateTime.now()),
                                        style: TextStyle(
                                          color: hexToColor('#333333'),
                                          fontSize: 27.sp,
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'To:',
                                        style: TextStyle(
                                          color: hexToColor('#979797'),
                                          fontSize: 27.sp,
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        _userAddress['name'],
                                        style: TextStyle(
                                          color: hexToColor('#333333'),
                                          fontSize: 27.sp,
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 2.h,
                                    margin:
                                        EdgeInsets.symmetric(vertical: 30.h),
                                    decoration: BoxDecoration(
                                      color: hexToColor('#E0E0E0'),
                                      borderRadius:
                                          BorderRadius.circular(100.r),
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
                                          fontSize: 34.sp,
                                        ),
                                      ),
                                      Text(
                                        '₹ ${widget.totalAmount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: hexToColor('#343434'),
                                          fontSize: 34.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 50.h),
                                  Container(
                                    height: 125.h,
                                    width: 505.w,
                                    decoration: BoxDecoration(
                                      color: hexToColor('#FFFFFF'),
                                      borderRadius: BorderRadius.circular(25.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Cash on Delivery',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 28.sp,
                                            fontFamily: 'Gotham',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 225.h),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: widget.items
                                            .map(
                                              (item) => Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.h),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Order ID:',
                                                      style: TextStyle(
                                                        color: hexToColor(
                                                            '#2D332F'),
                                                        fontSize: 24.sp,
                                                      ),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Text(
                                                      item['orderId'],
                                                      style: TextStyle(
                                                        color: hexToColor(
                                                            '#A9A9A9'),
                                                        fontSize: 24.sp,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      const Spacer(),
                                      Container(
                                          height: 95.h,
                                          width: 200.w,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: hexToColor('#094446')),
                                            borderRadius:
                                                BorderRadius.circular(25.r),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Unpaid'.toUpperCase(),
                                              style: TextStyle(
                                                color: hexToColor('#094446'),
                                                fontSize: 32.sp,
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
      ),
    );
  }
}

class NotificationSender {
  static Future<void> sendOrderNotificationToStoreOwner({
    required String orderId,
    required String storeId,
    required String productImage,
    required String productName,
    required String price,
  }) async {
    final firestore = FirebaseFirestore.instance;

    final storeDoc = await firestore.collection('Stores').doc(storeId).get();
    final ownerId = storeDoc.data()?['ownerId'];

    final userDoc = await firestore.collection('Users').doc(ownerId).get();
    final fcmToken = userDoc.data()?['fcmToken'];

    if (fcmToken != null) {
      final message = {
        'token': fcmToken,
        'notification': {
          'title': 'New Order Received',
          'body': 'You have received a new order #$orderId.',
        },
        'data': {
          'orderId': orderId,
          'storeId': storeId,
          'acceptAction': 'accept',
          'rejectAction': 'reject',
        },
      };

      await FirebaseMessaging.instance.sendMessage();
      debugPrint('Order notification sent successfully to the store owner');
    } else {
      debugPrint('No FCM token for the store owner: $ownerId');
    }
  }
}
