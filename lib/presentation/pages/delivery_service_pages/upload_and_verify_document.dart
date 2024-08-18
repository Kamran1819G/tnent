import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tnent/presentation/pages/delivery_service_pages/set_pickup_date_time.dart';
import '../../../core/helpers/color_utils.dart';

class UploadAndVerifyDocument extends StatefulWidget {
  const UploadAndVerifyDocument({Key? key}) : super(key: key);

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
      setState(() {
        if (type == 'aadhaar') {
          _aadhaarImage = File(image.path);
        } else {
          _passportImage = File(image.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AppBarWidget(),
            _TabBarWidget(tabController: _tabController),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _AadhaarFormWidget(
                    aadhaarImage: _aadhaarImage,
                    pickImage: pickImage,
                  ),
                  _PassportFormWidget(
                    passportImage: _passportImage,
                    pickImage: pickImage,
                  ),
                ],
              ),
            ),
            _SubmitButtonWidget(),
          ],
        ),
      ),
    );
  }
}

class _AppBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Stack(
        children: [
          // Background Image
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
          // Logo and Back Button
          Container(
            height: 75,
            padding: EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                Image.asset('assets/black_tnent_logo.png',
                    width: 30, height: 30),
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
          // Title
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
    );
  }
}

class _TabBarWidget extends StatelessWidget {
  final TabController tabController;

  const _TabBarWidget({Key? key, required this.tabController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: TabBar(
        controller: tabController,
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
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: hexToColor('#343434'), width: 1.0),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Text("Aadhaar"),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: hexToColor('#343434'), width: 1.0),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Text("Passport"),
          ),
        ],
      ),
    );
  }
}

class _AadhaarFormWidget extends StatelessWidget {
  final File? aadhaarImage;
  final Function(String) pickImage;

  const _AadhaarFormWidget({
    Key? key,
    required this.aadhaarImage,
    required this.pickImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              'Submit your Aadhaar card details below',
              style: TextStyle(
                color: hexToColor('#2A2A2A'),
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            // Aadhaar form fields (e.g., Date of Birth, ID Proof)
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
            // Add more Aadhaar form fields as needed
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
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
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
                if (aadhaarImage == null)
                  GestureDetector(
                    onTap: () {
                      pickImage('aadhaar');
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
                if (aadhaarImage != null)
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
                              image: FileImage(aadhaarImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              // Remove the Aadhaar image
                              // by setting it to null
                              pickImage('aadhaar');
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
                if (aadhaarImage == null)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      '(Add an image of your Aadhaar so that we could verify it’s you)',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: hexToColor('#636363'),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

class _PassportFormWidget extends StatelessWidget {
  final File? passportImage;
  final Function(String) pickImage;

  const _PassportFormWidget({
    Key? key,
    required this.passportImage,
    required this.pickImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            // Passport form fields (e.g., Date of Issue, Date of Expiry, ID Proof)
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
            // Add more Passport form fields as needed
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
              keyboardType: TextInputType.none,
            ),
            SizedBox(height: 20),
            Text(
              "Add Passport Image",
              style: TextStyle(
                color: hexToColor("#545454"),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (passportImage == null)
                  GestureDetector(
                    onTap: () {
                      pickImage('passport');
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
                if (passportImage != null)
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
                              image: FileImage(passportImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              // Remove the Passport image
                              // by setting it to null
                              pickImage('passport');
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
                if (passportImage == null)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      '(Add an image of your Passport so that we could verify it’s you)',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: hexToColor('#636363'),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

class _SubmitButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
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
            Text('Next Process', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
