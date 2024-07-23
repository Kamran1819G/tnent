import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tnennt/models/store_model.dart';

import '../../helpers/color_utils.dart';

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
    Reference ref = storage.ref().child('store_logos/${widget.store.storeId}.jpg');
    UploadTask uploadTask = ref.putFile(storeImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    uploadedImageUrl = await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> updateStoreDetails() async {
    setState(() {
      isSaving = true;
    });
    final storeDoc = FirebaseFirestore.instance.collection('Stores').doc(widget.store.storeId);
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
      'logoUrl': uploadedImageUrl.isNotEmpty ? uploadedImageUrl : widget.store.logoUrl,
    });
    setState(() {
      isSaving = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Store details updated successfully'),
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
                            'Settings'.toUpperCase(),
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
                        'Store Settings',
                        style: TextStyle(
                          color: hexToColor('#9C9C9C'),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gotham',
                          fontSize: 12.0,
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
            ),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
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
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                pickImage();
              },
              child: Text(
                "Change Image",
                style: TextStyle(
                  color: hexToColor("#757575"),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/globe.png',
                  width: 12,
                  height: 12,
                ),
                SizedBox(width: 5),
                Text(
                  widget.store.website,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Store Name",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextField(
                          controller: storeNameController,
                          style: TextStyle(
                            color: hexToColor("#6A6A6A"),
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: hexToColor("#848484"),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Category",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: DropdownButtonFormField(
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: hexToColor("#848484"),
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                                    'Clothing',
                                    'Grocery',
                                    'Electronics',
                                    'Restaurant',
                                    'Book Store',
                                    'Bakery',
                                    'Beauty Apparel',
                                    'Cafe',
                                    'Florist',
                                    'Footwear',
                                    'Accessories',
                                    'Stationary',
                                    'Eyewear',
                                    'Watch',
                                    'Sports'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          color: hexToColor("#6A6A6A"),
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w500,
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
                              Text(
                                "Phone Number",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.40,
                                child: TextField(
                                  controller: storePhoneNumberController,
                                  style: TextStyle(
                                    color: hexToColor("#6A6A6A"),
                                    fontFamily: 'Gotham',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                      SizedBox(height: 20),
                      Text(
                        "Email Address",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextField(
                          controller: storeEmailController,
                          style: TextStyle(
                            color: hexToColor("#6A6A6A"),
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: hexToColor("#848484"),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Store Location",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextField(
                          controller: storeLocationController,
                          style: TextStyle(
                            color: hexToColor("#6A6A6A"),
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: hexToColor("#848484"),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Store UPI",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextField(
                          controller: storeUPIController,
                          style: TextStyle(
                            color: hexToColor("#6A6A6A"),
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
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
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: CupertinoButton(
                color: Theme.of(context).primaryColor,
                disabledColor: Colors.grey,
                onPressed: isChanged ? () {
                  updateStoreDetails();
                } : null,
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
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
