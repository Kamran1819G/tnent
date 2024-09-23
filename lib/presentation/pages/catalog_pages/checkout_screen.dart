import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tnent/core/helpers/color_utils.dart';
import 'package:tnent/models/product_model.dart';
import 'package:tnent/models/store_model.dart';
import 'package:tnent/presentation/controllers/checkoutController.dart';
import 'package:tnent/presentation/pages/catalog_pages/purchase_screen.dart';
import 'package:tnent/presentation/pages/home_screen.dart';
import 'package:toastification/toastification.dart';
import '../../../core/helpers/snackbar_utils.dart';
import '../../../services/razorpay_service.dart';

class CheckoutScreen extends StatefulWidget {
  List<Map<String, dynamic>> selectedItems;

  CheckoutScreen({super.key, required this.selectedItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CheckoutController checkoutController = Get.put(CheckoutController());
  final TextEditingController _noteController = TextEditingController();
  Map<String, dynamic>? _userAddress;

  @override
  void initState() {
    super.initState();
    checkoutController.items.value = List.from(widget.selectedItems);
    _loadUserAddress();
    _noteController.addListener(_onNoteChanged);
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

  void _updateQuantity(int index, int newQuantity) {
    checkoutController.updateQuantity(index, newQuantity);
  }

  void _onNoteChanged() {
    checkoutController.updateNote(_noteController.text);
  }

  void _validateAndContinue() {
    if (_userAddress == null) {
      showSnackBar(context, 'Please add your address to continue');
      return;
    }

    // Check if any required field in the address is empty
    List<String> emptyFields = [];
    if (_userAddress!['name']?.isEmpty ?? true) emptyFields.add('Name');
    if (_userAddress!['phone']?.isEmpty ?? true) emptyFields.add('Phone');
    if (_userAddress!['addressLine1']?.isEmpty ?? true)
      emptyFields.add('Address Line 1');
    if (_userAddress!['zip']?.isEmpty ?? true) emptyFields.add('Pincode');
    if (_userAddress!['city']?.isEmpty ?? true) emptyFields.add('City');
    if (_userAddress!['state']?.isEmpty ?? true) emptyFields.add('State');

    if (emptyFields.isNotEmpty) {
      showSnackBar(context,
          'Please fill in the following fields: ${emptyFields.join(", ")}');
      return;
    }

    // If all validations pass, navigate to the summary screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryScreen(),
      ),
    );
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
                      checkoutController.clear();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
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
                                  border:
                                      Border.all(color: hexToColor('#E3E3E3')),
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
                SizedBox(height: 16.h),
                Card(
                  margin: EdgeInsets.all(24.w),
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Add Your Note: ',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextField(
                          controller: _noteController,
                          cursorHeight: 17,
                          style: const TextStyle(
                              fontFamily: 'Poppins', fontSize: 10),
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              counterStyle: TextStyle(
                                  fontFamily: 'Poppins', fontSize: 6)),
                          maxLines:
                              null, // Increase the max lines for a larger in
                          maxLength: 200,
                          cursorColor: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: checkoutController.items.length,
                  itemBuilder: (context, index) {
                    return CheckoutItemTile(
                      item: checkoutController.items[index],
                      onUpdateQuantity: (newQuantity) =>
                          _updateQuantity(index, newQuantity),
                      index: index,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                ],
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: _validateAndContinue,
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
  String? selectedPincode;

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _cityController;
  late TextEditingController _stateController;

  final List<String> pincodes = ['788710', '788711', '788712'];
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
    _cityController =
        TextEditingController(text: widget.existingAddress?['city'] ?? '');
    _stateController =
        TextEditingController(text: widget.existingAddress?['state'] ?? '');
    addressType = widget.existingAddress?['type'] ?? 'Home';
    selectedPincode = widget.existingAddress?['zip'];
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
        'zip': selectedPincode,
        'city': _cityController.text,
        'state': _stateController.text,
        'type': addressType,
      };

      // Check if any field is empty
      if (addressData.values.any((value) => value == null || value.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all required fields')),
        );
        return;
      }

      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .update({
          'address': addressData,
        });
        Navigator.pop(context, addressData);
      } catch (e) {
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
                        child: DropdownButtonFormField<String>(
                          value: selectedPincode,
                          decoration: InputDecoration(
                            labelText: 'Pincode',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: hexToColor('#2A2A2A')),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: hexToColor('#2A2A2A')),
                            ),
                          ),
                          items: [
                            DropdownMenuItem<String>(
                              value: null,
                              child: Text('select pincode'),
                            ),
                            ...pincodes.map((String pincode) {
                              return DropdownMenuItem<String>(
                                value: pincode,
                                child: Text(pincode),
                              );
                            }).toList(),
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPincode = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a pincode';
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
  final int index;

  const CheckoutItemTile({
    Key? key,
    required this.item,
    required this.onUpdateQuantity,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CheckoutController checkoutController =
        Get.find<CheckoutController>();

    return Obx(
      () => Card(
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
                    fit: BoxFit.cover,
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
                                decoration:
                                    item['variationDetails'].discount > 0
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
                          onPressed: () {
                            int newQuantity = item['quantity'] - 1;
                            if (newQuantity < 1) {
                              newQuantity = 1;
                            }
                            onUpdateQuantity(newQuantity);
                          },
                        ),
                        Text(
                          '${checkoutController.items[index]['quantity']}',
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
                          onPressed: () =>
                              onUpdateQuantity(item['quantity'] + 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(Map<String, dynamic>) onRemove;
  final bool showRemoveButton;

  const SummaryItemTile({
    Key? key,
    required this.item,
    required this.onRemove,
    required this.showRemoveButton,
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
              if (showRemoveButton)
                GestureDetector(
                  onTap: () => onRemove(item),
                  child: Text(
                    'Remove',
                    style: TextStyle(
                      color: hexToColor('#A9A9A9'),
                      fontSize: 17.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                    ),
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
                      fit: BoxFit.cover,
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
  SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late Map<String, StoreModel> _storeDetails = {};
  final CheckoutController checkoutController = Get.find<CheckoutController>();

  @override
  void initState() {
    super.initState();
    _fetchStoreDetails();
    _generateOrderIds();
  }

  Future<void> _fetchStoreDetails() async {
    for (var item in checkoutController.items) {
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
    for (var item in checkoutController.items) {
      String timestamp =
          DateTime.now().millisecondsSinceEpoch.toString().substring(12);
      String randomComponent =
          Random().nextInt(900000).toString().padLeft(3, '0');
      item['orderId'] = 'ORD${timestamp}$randomComponent';
    }
  }

  void _removeItem(Map<String, dynamic> item) {
    checkoutController.removeItem(item);
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
      children: checkoutController.items
          .map((item) => SummaryItemTile(
              item: item,
              onRemove: _removeItem,
              showRemoveButton: checkoutController.items.length > 1))
          .toList(),
    );
  }

  Widget _buildSummarySection() {
    double subtotal = 0;
    double totalMRP = 0;
    double totalDiscount = 0;

    for (var item in checkoutController.items) {
      double itemMRP = item['variationDetails'].mrp * item['quantity'];
      double itemPrice = item['variationDetails'].price * item['quantity'];
      double itemDiscount = itemMRP - itemPrice;

      totalMRP += itemMRP;
      subtotal += itemPrice;
      totalDiscount += itemDiscount;

    }

    double platformFee = PlatformFeeCalculator.calculateFee(subtotal);
    double deliveryCharge = checkoutController.deliveryCharge;
    double total = subtotal + platformFee + deliveryCharge;


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
          ...checkoutController.items.map((item) => _buildItemSummary(item)),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.h),
            height: 1.h,
            color: hexToColor('#E3E3E3'),
          ),
          _buildSummaryRow('Subtotal', subtotal),
          _buildSummaryRow('Total MRP', totalMRP),
          _buildSummaryRow('Total Discount', totalDiscount, isDiscount: true),
          _buildSummaryRow('Platform Fee', platformFee),
          _buildSummaryRow('Delivery Charge', deliveryCharge),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.h),
            height: 1.h,
            color: hexToColor('#E3E3E3'),
          ),
          _buildSummaryRow('Total', total, isBold: true),
        ],
      ),
    );
  }

  Widget _buildItemSummary(Map<String, dynamic> item) {
    double itemMRP = item['variationDetails'].mrp * item['quantity'];
    double itemPrice = item['variationDetails'].price * item['quantity'];
    double itemDiscount = itemMRP - itemPrice;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              item['productName'],
              style: TextStyle(
                color: hexToColor('#B9B9B9'),
                fontFamily: 'Gotham',
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹ ${itemPrice.toStringAsFixed(2)}',
                style: TextStyle(color: hexToColor('#606060'), fontSize: 18.sp),
              ),
              Text(
                'MRP: ₹ ${itemMRP.toStringAsFixed(2)}',
                style: TextStyle(color: hexToColor('#B9B9B9'), fontSize: 14.sp, decoration: TextDecoration.lineThrough),
              ),
              Text(
                'You save: ₹ ${itemDiscount.toStringAsFixed(2)}',
                style: TextStyle(color: hexToColor('#4CAF50'), fontSize: 14.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isDiscount = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: hexToColor('#343434'),
              fontSize: isBold ? 20.sp : 18.sp,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            isDiscount ? '- ₹ ${amount.toStringAsFixed(2)}' : '₹ ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isDiscount ? hexToColor('#4CAF50') : hexToColor('#343434'),
              fontSize: isBold ? 20.sp : 18.sp,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentOptionScreen(
                storeDetails: _storeDetails,
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
            'Pay ₹ ${checkoutController.totalAmountWithFee.toStringAsFixed(2)}',
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


class PaymentOptionScreen extends StatefulWidget {
  Map<String, StoreModel> storeDetails;

  PaymentOptionScreen({
    super.key,
    required this.storeDetails,
  });

  @override
  State<PaymentOptionScreen> createState() => _PaymentOptionScreenState();
}

class _PaymentOptionScreenState extends State<PaymentOptionScreen> {
  final CheckoutController checkoutController = Get.find<CheckoutController>();
  late RazorpayService razorpayService;

  @override
  void initState() {
    super.initState();
    razorpayService = RazorpayService();
    razorpayService.setPaymentCompletedCallback(_onPaymentCompleted);
    razorpayService.setPaymentFailedCallback(_onPaymentFailed);
  }

  @override
  void dispose() {
    // Dispose RazorpayService
    razorpayService.dispose();
    super.dispose();
  }

  void _onPaymentCompleted(PaymentSuccessResponse response) {
    _navigateToTransactionScreen(
        isOnlinePayment: true, paymentId: response.paymentId);
  }

  void _onPaymentFailed(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );
  }

  void _navigateToTransactionScreen(
      {required bool isOnlinePayment, String? paymentId}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionScreen(
          storeDetails: widget.storeDetails,
          isOnlinePayment: isOnlinePayment,
          paymentId: paymentId,
        ),
      ),
    );
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w),
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
                  _buildPaymentOption(
                    title: 'Online Payment',
                    subtitle: 'Pay securely online',
                    icon: Icons.payment,
                    onTap: () {
                      if (checkoutController.items.isNotEmpty) {
                        String storeId =
                            checkoutController.items.first['storeId'];
                        showSnackBarWithAction(
                          context,
                          text: 'Do you want to proceed with online payment?',
                          confirmBtnText: 'Continue',
                          buttonTextFontsize: 11,
                          cancelBtnText: 'Cancel',
                          quickAlertType: QuickAlertType.confirm,
                          action: () {
                            // Close the confirmation dialog
                            Navigator.of(context).pop();

                            // Show circular progress bar
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return WillPopScope(
                                  onWillPop: () async => false,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                            );
                            // Proceed with payment
                            razorpayService.openCheckout(
                              checkoutController.totalAmountWithFee,
                              context,
                              storeId,
                              checkoutController.items,
                              onSuccess: (PaymentSuccessResponse response) {
                                Navigator.of(context)
                                    .pop(); // Dismiss the progress indicator
                                _navigateToTransactionScreen(
                                    isOnlinePayment: true,
                                    paymentId: response.paymentId);
                              },
                              onError: (PaymentFailureResponse response) {
                                Navigator.of(context)
                                    .pop(); // Dismiss the progress indicator
                                _onPaymentFailed(response);
                              },
                            );
                          },
                        );
                      } else {
                        showSnackBar(
                          context,
                          'Your cart is empty',
                          toastificationType: ToastificationType.warning,
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20.h),
                  _buildPaymentOption(
                    title: 'Cash on Delivery',
                    subtitle: 'Pay at your doorstep',
                    icon: Icons.money,
                    onTap: () {
                      showSnackBarWithAction(
                        context,
                        text: 'Do you want to continue with Cash on Delivery?',
                        confirmBtnText: 'Continue 💵',
                        buttonTextFontsize: 11,
                        cancelBtnText: 'Cancel',
                        quickAlertType: QuickAlertType.confirm,
                        action: () {
                          _navigateToTransactionScreen(isOnlinePayment: false);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: hexToColor('#E0E0E0')),
          borderRadius: BorderRadius.circular(12.r),
        ),
        leading: Icon(icon, size: 25.sp),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Gotham',
                fontWeight: FontWeight.w800,
                fontSize: 22.sp,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: hexToColor('#6F6F6F'),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TransactionScreen extends StatefulWidget {
  Map<String, StoreModel> storeDetails;
  final bool isOnlinePayment;
  final String? paymentId;

  TransactionScreen({
    Key? key,
    required this.storeDetails,
    required this.isOnlinePayment,
    this.paymentId,
  }) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late ConfettiController _confettiController;
  final CheckoutController checkoutController = Get.find<CheckoutController>();
  ScreenshotController screenshotController = ScreenshotController();

  bool isGreeting = false;
  late Map<String, dynamic> _userAddress;
  bool _isLoading = true;
  bool _isRemovingProduct = false;
  String _productIdToRemove = '';
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _userAddress = await _loadUserAddress();
    _isLoading = false;
    makeIsGreetingTrue();
    await processOrder(checkoutController.items);
    setState(() {});
    await sendOrderNotification();
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

  final String _digits = '0123456789';
  final _rnd = Random();

  String _getRandomNumericCode() => String.fromCharCodes(Iterable.generate(
      5, (_) => _digits.codeUnitAt(_rnd.nextInt(_digits.length))));

  Future<void> processOrder(List<Map<String, dynamic>> items) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      double subtotal = 0;
      for (var item in items) {
        subtotal += item['variationDetails'].price * item['quantity'];
      }

      double platformFee = PlatformFeeCalculator.calculateFee(subtotal);
      double deliveryCharge = checkoutController.deliveryCharge;

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
          'note': checkoutController.note.value,
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
            'method':
                widget.isOnlinePayment ? 'Online Payment' : 'Cash on Delivery',
            'status': widget.isOnlinePayment ? 'Paid' : 'Pending',
            'paymentId': widget.paymentId,
            'platformFee': platformFee,
            'deliveryCharge': deliveryCharge,
          },
          'isOrderNew': true,
          'isOnlinePayment': widget.isOnlinePayment,
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
    } catch (e) {
      print('Error processing order: $e');
      // Handle error
    }
  }

  void _startProductRemoval() {
    if (checkoutController.items.isNotEmpty) {
      setState(() {
        _isRemovingProduct = true;
        _productIdToRemove = checkoutController.items.first['productId'];
      });

      // Simulate a delay before removing the product
      Future.delayed(const Duration(seconds: 2), () {
        _removeProductFromCart(_productIdToRemove);
      });
    }
  }

  void _removeProductFromCart(String productId) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('Users').doc(userId);
      DocumentSnapshot userDoc = await userRef.get();
      List<dynamic> currentCart = userDoc.get('cart') ?? [];
      currentCart.removeWhere((item) => item['productId'] == productId);
      await userRef.update({'cart': currentCart});
      setState(() {
        checkoutController.items
            .removeWhere((item) => item['productId'] == productId);
        _isRemovingProduct = false;
      });
      if (checkoutController.items.isNotEmpty) {
        _startProductRemoval();
      }
    } catch (e) {
      print('Error removing product from cart: $e');
      setState(() {
        _isRemovingProduct = false;
      });
    }
  }

  Future<void> sendOrderNotification() async {
    final firestore = FirebaseFirestore.instance;

    for (var item in checkoutController.items) {
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
          'paymentMethod':
              widget.isOnlinePayment ? 'Online Payment' : 'Cash on Delivery',
          'paymentStatus': widget.isOnlinePayment ? 'Paid' : 'Pending',
        },
        'timestamp': FieldValue.serverTimestamp(),
        'IsUnRead': true,
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

  void _navigateToHomeScreen() {
    checkoutController.clear();
    _startProductRemoval();
    Get.offAll(() => const HomeScreen());
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  void _startFadeIn() {
    // Delay before starting the fade-in
    Future.delayed(const Duration(milliseconds: 2900), () {
      setState(() {
        _opacity = 1.0; // Fade in
      });
    });
  }

  Future<void> _captureAndSaveImage() async {
    try {
      // Capture the screenshot
      final Uint8List? imageBytes = await screenshotController.capture();

      if (imageBytes != null) {
        // Get the external storage directory (Pictures folder)
        final directory =
            Directory('/storage/emulated/0/Pictures'); // Or use DCIM folder

        if (!(await directory.exists())) {
          await directory.create(
              recursive: true); // Create folder if it doesn't exist
        }

        // Create a unique filename with timestamp
        final String fileName =
            'transaction_receipt_${DateTime.now().millisecondsSinceEpoch}.png';

        // Create the file path
        final String filePath = '${directory.path}/$fileName';

        // Write the file
        final File file = File(filePath);
        await file.writeAsBytes(imageBytes);

        // Show a success message to the user
        showSnackBar(context, 'Receipt saved to: $filePath');
      }
    } catch (e) {
      print('Error saving image: $e');
      showSnackBar(context, 'Failed to save receipt');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_isRemovingProduct) {}
    if (isGreeting) {
      return _buildGreetingScreen();
    }
    if (_userAddress == null) {
      return const Scaffold(
        body: Center(
          child: Text('Error: User address not found'),
        ),
      );
    }
    return _buildTransactionScreen();
  }

  Widget _buildGreetingScreen() {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
      ),
    );
  }

  Widget _buildTransactionScreen() {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          _navigateToHomeScreen();
        },
        child: Scaffold(
          body: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 2900),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 100.h,
                      margin: EdgeInsets.only(top: 20.h),
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(const PurchaseScreen());
                            },
                            child: CircleAvatar(
                              radius: 40.w,
                              backgroundColor: Colors.grey[100],
                              child: Image.asset('assets/icons/track_order.png',
                                  height: 34.h, width: 34.w),
                            ),
                          ),
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
                            onPressed: () => _navigateToHomeScreen(),
                          ),
                        ],
                      ),
                    ),
                    Screenshot(
                      controller: screenshotController,
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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20.w),
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
                                          margin: EdgeInsets.symmetric(
                                              vertical: 30.h),
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
                                            Obx(() => Text(
                                                  '₹ ${checkoutController.totalAmountWithFee.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    color:
                                                        hexToColor('#343434'),
                                                    fontSize: 34.sp,
                                                  ),
                                                )),
                                          ],
                                        ),
                                        SizedBox(height: 50.h),
                                        Container(
                                          height: 125.h,
                                          width: 505.w,
                                          decoration: BoxDecoration(
                                            color: hexToColor('#FFFFFF'),
                                            borderRadius:
                                                BorderRadius.circular(25.r),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                widget.isOnlinePayment
                                                    ? 'Online Payment'
                                                    : 'Cash on Delivery',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 28.sp,
                                                  fontFamily: 'Gotham',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(width: 24.w),
                                              GestureDetector(
                                                onTap: _captureAndSaveImage,
                                                child: Image.asset(
                                                    'assets/icons/download.png',
                                                    height: 25.h),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 225.h),
                                        Row(
                                          children: [
                                            Obx(
                                              () => Column(
                                                children: checkoutController
                                                    .items
                                                    .map(
                                                      (item) => Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
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
                                                            SizedBox(
                                                                width: 8.w),
                                                            Text(
                                                              item['orderId'],
                                                              style: TextStyle(
                                                                color: hexToColor(
                                                                    '#A9A9A9'),
                                                                fontSize: 24.sp,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                                height: 95.h,
                                                width: 200.w,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: hexToColor(
                                                          '#094446')),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.r),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    widget.isOnlinePayment
                                                        ? 'PAID'
                                                        : 'UNPAID',
                                                    style: TextStyle(
                                                      color:
                                                          hexToColor('#094446'),
                                                      fontSize: 32.sp,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
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
          ),
        ));
  }
}
