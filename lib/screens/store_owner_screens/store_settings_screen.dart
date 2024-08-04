import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tnent/models/store_model.dart';

import '../../helpers/color_utils.dart';
import '../../helpers/snackbar_utils.dart';

class StoreSettingsScreen extends StatefulWidget {
  final StoreModel store;

  StoreSettingsScreen({required this.store});

  @override
  State<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {
  File? storeImage;
  late TextEditingController storeNameController;
  late TextEditingController storePhoneNumberController;
  late TextEditingController storeEmailController;
  late TextEditingController storeLocationController;
  late TextEditingController storeUPIController;
  late String selectedCategory;

  late String initialStoreName;
  late String initialStorePhone;
  late String initialStoreEmail;
  late String initialStoreLocation;
  late String initialStoreUPI;
  late String initialSelectedCategory;
  String uploadedImageUrl = '';

  bool isChanged = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    initialStoreName = widget.store.name;
    initialStorePhone = widget.store.phone;
    initialStoreEmail = widget.store.email;
    initialStoreLocation = widget.store.location;
    initialStoreUPI = widget.store.upiId;
    initialSelectedCategory = widget.store.category;

    storeNameController = TextEditingController(text: initialStoreName);
    storePhoneNumberController = TextEditingController(text: initialStorePhone);
    storeEmailController = TextEditingController(text: initialStoreEmail);
    storeLocationController = TextEditingController(text: initialStoreLocation);
    storeUPIController = TextEditingController(text: initialStoreUPI);
    selectedCategory = initialSelectedCategory;

    storeNameController.addListener(_checkForChanges);
    storePhoneNumberController.addListener(_checkForChanges);
    storeEmailController.addListener(_checkForChanges);
    storeLocationController.addListener(_checkForChanges);
    storeUPIController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    setState(() {
      isChanged = storeNameController.text != initialStoreName ||
          storePhoneNumberController.text != initialStorePhone ||
          storeEmailController.text != initialStoreEmail ||
          storeLocationController.text != initialStoreLocation ||
          storeUPIController.text != initialStoreUPI ||
          selectedCategory != initialSelectedCategory ||
          storeImage != null;
    });
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        storeImage = File(image.path);
        _checkForChanges();
      });
    }
  }

  Future<void> uploadImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
        storage.ref().child('store_logos/${widget.store.storeId}.jpg');
    UploadTask uploadTask = ref.putFile(storeImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    uploadedImageUrl = await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> updateStoreDetails() async {
    setState(() {
      isSaving = true;
    });
    final storeDoc = FirebaseFirestore.instance
        .collection('Stores')
        .doc(widget.store.storeId);
    if (storeImage != null) {
      await uploadImage();
    }
    await storeDoc.update({
      'name': storeNameController.text,
      'phone': storePhoneNumberController.text,
      'email': storeEmailController.text,
      'location': storeLocationController.text,
      'upiId': storeUPIController.text,
      'category': selectedCategory,
      'logoUrl':
          uploadedImageUrl.isNotEmpty ? uploadedImageUrl : widget.store.logoUrl,
    });
    setState(() {
      isSaving = false;
      isChanged = false;
    });
    Navigator.of(context).pop();

    showSnackBar(context, 'Store details updated successfully');
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Settings'.toUpperCase(),
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
                        'Store Settings',
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
                      backgroundColor: WidgetStateProperty.all(
                        Colors.grey[100],
                      ),
                      shape: WidgetStateProperty.all(
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
            Container(
              height: 115.h,
              width: 115.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17.r),
              ),
              child: (storeImage != null)
                  ? Image.file(
                      storeImage!,
                      fit: BoxFit.fill,
                    )
                  : Image.network(
                      widget.store.logoUrl,
                      fit: BoxFit.fill,
                    ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () async {
                pickImage();
              },
              child: Text(
                "Change Logo",
                style: TextStyle(
                  color: hexToColor("#757575"),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 22.sp,
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/globe.png',
                  width: 16.w,
                  height: 16.h,
                ),
                const SizedBox(width: 5),
                Text(
                  widget.store.website,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50.h),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 23.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Store Name",
                        style: TextStyle(
                          fontSize: 23.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: 580.w,
                        height: 90.h,
                        child: TextField(
                          controller: storeNameController,
                          style: TextStyle(
                            color: hexToColor("#6A6A6A"),
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                            fontSize: 22.sp,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(19.r),
                              borderSide: BorderSide(
                                color: hexToColor("#848484"),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Category",
                                style: TextStyle(
                                  fontSize: 23.sp,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              SizedBox(
                                width: 280.w,
                                height: 90.h,
                                child: DropdownButtonFormField(
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: hexToColor("#848484"),
                                    size: 20.sp,
                                  ),
                                  style: TextStyle(
                                    color: hexToColor("#6A6A6A"),
                                    fontFamily: 'Gotham',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22.sp,
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(19.r),
                                      borderSide: BorderSide(
                                        color: hexToColor("#848484"),
                                      ),
                                    ),
                                  ),
                                  value: selectedCategory,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCategory = newValue!;
                                      _checkForChanges();
                                    });
                                  },
                                  items: <String>[
                                    "Clothings",
                                    "Electronics",
                                    "Restaurants",
                                    "Books",
                                    "Bakeries",
                                    "Beauty Apparels",
                                    "Cafes",
                                    "Florists",
                                    "Footwears",
                                    "Accessories",
                                    "Stationeries",
                                    "Eyewears",
                                    "Watches",
                                    "Musicals",
                                    "Sports"
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          color: hexToColor("#6A6A6A"),
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 22.sp,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Phone Number",
                                style: TextStyle(
                                  fontSize: 23.sp,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              SizedBox(
                                width: 280.w,
                                height: 90.h,
                                child: TextField(
                                  controller: storePhoneNumberController,
                                  style: TextStyle(
                                    color: hexToColor("#6A6A6A"),
                                    fontFamily: 'Gotham',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22.sp,
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(19.r),
                                      borderSide: BorderSide(
                                        color: hexToColor("#848484"),
                                      ),
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        "Email Address",
                        style: TextStyle(
                          fontSize: 23.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: 580.w,
                        height: 90.h,
                        child: TextField(
                          controller: storeEmailController,
                          style: TextStyle(
                            color: hexToColor("#6A6A6A"),
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                            fontSize: 22.sp,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(19.r),
                              borderSide: BorderSide(
                                color: hexToColor("#848484"),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        "Store Location",
                        style: TextStyle(
                          fontSize: 23.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: 580.w,
                        height: 90.h,
                        child: TextField(
                          controller: storeLocationController,
                          style: TextStyle(
                            color: hexToColor("#6A6A6A"),
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                            fontSize: 22.sp,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(19.r),
                              borderSide: BorderSide(
                                color: hexToColor("#848484"),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        "Store UPI",
                        style: TextStyle(
                          fontSize: 23.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: 580.w,
                        child: TextField(
                          controller: storeUPIController,
                          style: TextStyle(
                            color: hexToColor("#6A6A6A"),
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                            fontSize: 22.sp,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(19.r),
                              borderSide: BorderSide(
                                color: hexToColor("#848484"),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: isChanged
                    ? () {
                        updateStoreDetails();
                      }
                    : null,
                child: Container(
                  width: 470.w,
                  height: 100.h,
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isChanged
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.sp,
                      fontFamily: 'Gotham',
                      fontWeight: FontWeight.w500,
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
