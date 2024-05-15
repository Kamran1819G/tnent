import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../../helpers/color_utils.dart';

class StoreSettingsScreen extends StatefulWidget {
  String? storeName;
  String? storeCategory;
  String? storePhoneNumber;
  String? storeEmail;
  String? storeLocation;
  String? storeUPI;

  StoreSettingsScreen({
    this.storeName,
    this.storeCategory,
    this.storePhoneNumber,
    this.storeEmail,
    this.storeLocation,
    this.storeUPI,
  });

  @override
  State<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {
  File? storeImage;
  String storeCategory = "Grocery";
  TextEditingController storeNameController =
      TextEditingController(text: "Jain Brothers");
  TextEditingController storePhoneNumberController =
      TextEditingController(text: "9876543210");
  TextEditingController storeEmailController =
      TextEditingController(text: "jainbrother@tnennt.com");
  TextEditingController storeLocationController =
      TextEditingController(text: "Bengaluru");
  TextEditingController storeUPIController =
      TextEditingController(text: "worldsxtreme2910@upi");

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        storeImage = File(image.path);
      });
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
                  : Image.asset(
                      'assets/jain_brothers.png',
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
                Icon(Icons.web_rounded,
                    color: Theme.of(context).primaryColor, size: 16),
                SizedBox(width: 5),
                Text(
                  "jainbrother.tnennt.store",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w600,
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
                          color: hexToColor("#545454"),
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
                                  color: hexToColor("#545454"),
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
                                  value: widget.storeCategory,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      widget.storeCategory = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'Grocery',
                                    'Electronics',
                                    'Clothing',
                                    'Footwear',
                                    'Stationary',
                                    'Others'
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
                                  color: hexToColor("#545454"),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
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
                        "E Mail",
                        style: TextStyle(
                          color: hexToColor("#545454"),
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
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Location",
                        style: TextStyle(
                          color: hexToColor("#545454"),
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
                            prefixIcon: Icon(
                              CupertinoIcons.globe,
                            ),
                            prefixIconColor: Theme.of(context).primaryColor,
                            suffixIcon: Icon(
                              Icons.arrow_forward_ios,
                            ),
                            suffixIconColor: Theme.of(context).primaryColor,
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
                        "UPI",
                        style: TextStyle(
                          color: hexToColor("#545454"),
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
                            prefixIcon: Icon(
                              Icons.credit_card,
                            ),
                            prefixIconColor: Theme.of(context).primaryColor,
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
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: hexToColor('#2D332F'),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 18),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Gotham',
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Done', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
