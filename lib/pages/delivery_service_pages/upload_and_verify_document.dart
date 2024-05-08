import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tnennt/pages/delivery_service_pages/set_pickup_date_time.dart';

import '../../helpers/color_utils.dart';

class UploadAndVerifyDocument extends StatefulWidget {
  const UploadAndVerifyDocument({super.key});

  @override
  State<UploadAndVerifyDocument> createState() =>
      _UploadAndVerifyDocumentState();
}

class _UploadAndVerifyDocumentState extends State<UploadAndVerifyDocument>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  File? _aadhaarImage;
  File? _passportImage;

  Future<void> pickImage(String type) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (type == 'aadhaar') {
        setState(() {
          _aadhaarImage = File(image.path);
        });
      } else {
        setState(() {
          _passportImage = File(image.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/delivery_service_bg_1.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  height: 75,
                  padding: EdgeInsets.only(left: 16, right: 8),
                  child: Row(
                    children: [
                      Image.asset('assets/black_tnennt_logo.png',
                          width: 30, height: 30),
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
                Container(
                  alignment: Alignment(0, 0.1),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Text(
                    'Upload Your Documents For Verification',
                    style: TextStyle(
                      color: hexToColor('#2A2A2A'),
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              unselectedLabelColor: hexToColor('#737373'),
              labelColor: Colors.white,
              indicator: BoxDecoration(
                color: hexToColor('#343434'),
                borderRadius: BorderRadius.circular(50),
              ),
              labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
              labelStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w900,
              ),
              indicatorSize: TabBarIndicatorSize.label,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              dividerColor: Colors.transparent,
              tabs: <Widget>[
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: hexToColor('#343434'), width: 1.0),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Text(
                    "Aadhaar",
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: hexToColor('#343434'), width: 1.0),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Text(
                    "Passport",
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload your documents?',
                          style: TextStyle(
                            color: hexToColor('#2A2A2A'),
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Submit your aadhaar card details below',
                          style: TextStyle(
                            color: hexToColor('#2A2A2A'),
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Date of Birth",
                          style: TextStyle(
                            color: hexToColor("#545454"),
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'DD-MM-YYYY',
                            hintStyle: TextStyle(
                              color: hexToColor("#D0D0D0"),
                              fontSize: 14,
                            ),
                            suffixIcon: Icon(Icons.calendar_month_outlined),
                            suffixIconColor: Theme.of(context).primaryColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: hexToColor("#848484"),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.datetime,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "ID Proof",
                          style: TextStyle(
                            color: hexToColor("#545454"),
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter 12 digit Aadhaar number',
                            hintStyle: TextStyle(
                              color: hexToColor("#D0D0D0"),
                              fontSize: 14,
                            ),
                            suffixIcon: Icon(Icons.credit_card_outlined),
                            suffixIconColor: Theme.of(context).primaryColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: hexToColor("#848484"),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.datetime,
                        ),
                        SizedBox(height: 40),
                        Text(
                          "Add Aadhaar Image",
                          style: TextStyle(
                            color: hexToColor("#545454"),
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  pickImage('aadhaar');
                                });
                              },
                              child: Container(
                                height: 75,
                                width: 75,
                                decoration: BoxDecoration(
                                  border: Border.all(color: hexToColor('#848484')),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.image_rounded,
                                    size: 40,
                                    color: hexToColor('#545454'),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            if(_aadhaarImage != null)
                              SizedBox(
                                height: 75,
                                child: Stack(
                                      children: [
                                        Container(
                                          width: 75,
                                          margin: const EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: hexToColor('#848484')),
                                            borderRadius: BorderRadius.circular(12),
                                            image: DecorationImage(
                                              image: FileImage(_aadhaarImage!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _aadhaarImage = null;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red,
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              ),
                            if (_aadhaarImage == null)
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Expanded(
                                  child: Text(
                                    '(Add an image of your aadhaar so that we could verify it’s you)',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      color: hexToColor('#636363'),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload your documents?',
                          style: TextStyle(
                            color: hexToColor('#2A2A2A'),
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Submit your passport details below',
                          style: TextStyle(
                            color: hexToColor('#2A2A2A'),
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date of Issue",
                                    style: TextStyle(
                                      color: hexToColor("#545454"),
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'DD-MM-YYYY',
                                      hintStyle: TextStyle(
                                        color: hexToColor("#D0D0D0"),
                                        fontSize: 14,
                                      ),
                                      suffixIcon: Icon(Icons.calendar_month_outlined),
                                      suffixIconColor: Theme.of(context).primaryColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: hexToColor("#848484"),
                                        ),
                                      ),
                                    ),
                                    keyboardType: TextInputType.datetime,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date of Expiry",
                                    style: TextStyle(
                                      color: hexToColor("#545454"),
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'DD-MM-YYYY',
                                      hintStyle: TextStyle(
                                        color: hexToColor("#D0D0D0"),
                                        fontSize: 14,
                                      ),
                                      suffixIcon: Icon(Icons.calendar_month_outlined),
                                      suffixIconColor: Theme.of(context).primaryColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: hexToColor("#848484"),
                                        ),
                                      ),
                                    ),
                                    keyboardType: TextInputType.datetime,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          "ID Proof",
                          style: TextStyle(
                            color: hexToColor("#545454"),
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter your passport number',
                            hintStyle: TextStyle(
                              color: hexToColor("#D0D0D0"),
                              fontSize: 14,
                            ),
                            suffixIcon: Icon(Icons.credit_card_outlined),
                            suffixIconColor: Theme.of(context).primaryColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: hexToColor("#848484"),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.datetime,
                        ),
                        SizedBox(height: 40),
                        Text(
                          "Add passport image",
                          style: TextStyle(
                            color: hexToColor("#545454"),
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  pickImage('passport');
                                });
                              },
                              child: Container(
                                height: 75,
                                width: 75,
                                decoration: BoxDecoration(
                                  border: Border.all(color: hexToColor('#848484')),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.image_rounded,
                                    size: 40,
                                    color: hexToColor('#545454'),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            if(_aadhaarImage != null)
                              SizedBox(
                                height: 75,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 75,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: hexToColor('#848484')),
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: FileImage(_aadhaarImage!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _aadhaarImage = null;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_aadhaarImage == null)
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Expanded(
                                  child: Text(
                                    '(Add an image of your passport so that we could verify it’s you)',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      color: hexToColor('#636363'),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SetPickupDateTime(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: hexToColor('#2D332F'),
                // Set the button color to black
                foregroundColor: Colors.white,
                // Set the text color to white
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 18),
                // Set the padding
                textStyle: TextStyle(
                  fontSize: 16, // Set the text size
                  fontFamily: 'Gotham',
                  fontWeight: FontWeight.w500, // Set the text weight
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      100), // Set the button corner radius
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Next Process', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ));
  }
}
