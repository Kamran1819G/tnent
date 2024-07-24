import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tnennt/models/user_model.dart';
import 'package:tnennt/services/firebase/firebase_auth_service.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/widget_tree.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class UserRegistration extends StatefulWidget {
  UserRegistration({Key? key}) : super(key: key);

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  PageController _pageController = PageController();
  late ConfettiController _confettiController;
  int currentPage = 0;
  bool value = false;
  bool isButtonEnabled = false;
  late UserModel _userModel;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  final _otpControllers = List.generate(4, (_) => TextEditingController());
  final _focusNodes = List.generate(4, (_) => FocusNode());

  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 5));
    _initializeUserModel();
  }

  void _initializeUserModel() {
    _userModel = UserModel(
      uid: user.uid,
      email: user.email ?? '',
      firstName: '',
      lastName: '',
    );
  }

  Future<void> addUserDetails() async {
    try {
      final updatedUser = _userModel.copyWith(
        phoneNumber: _phoneController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        location: _locationController.text,
        registered: true,
        lastUpdated: Timestamp.now(),
      );

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(updatedUser.uid)
          .set(updatedUser.toFirestore());

      setState(() {
        _userModel = updatedUser;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Error: $e',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  bool _validateFields() {
    switch (currentPage) {
      case 0:
        // Validate phone number
        return _phoneController.text.length == 10;
      case 1:
        // Validate OTP
        return _otpControllers
            .every((controller) => controller.text.isNotEmpty);
      case 2:
        // Validate first name and last name
        return _firstNameController.text.isNotEmpty &&
            _lastNameController.text.isNotEmpty;
      case 3:
        // Validate location
        return _locationController.text.isNotEmpty;
      default:
        return true;
    }
  }

  void _proceedToNextPage() {
    if (_validateFields()) {
      _pageController.jumpToPage(currentPage + 1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields correctly.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Location services are disabled. Please enable the services'),
      ));
      return;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Location permissions are denied'),
        ));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Location permissions are permanently denied, we cannot request permissions.'),
      ));
      return;
    }

    // Get current position
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get place name from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            "${place.locality}, ${place.administrativeArea}, ${place.country}";
        setState(() {
          _locationController.text = address;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to get current location: $e'),
      ));
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
                if (page == 3) {
                  _confettiController.play();
                }
                if (page == 4) {
                  // Start a timer of 10 seconds when the last page is reached
                  Timer(Duration(seconds: 10), () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => WidgetTree()), // Navigate to the Home screen
                    );
                  });
                }
              },
              children: <Widget>[
                // Page 1: Registration
                _buildRegistrationPage(),
                // Page 2: Verification
                _buildVerificationPage(),
                // Page 3: Name
                _buildNamePage(),
                // Page 4: Location
                _buildLocationPage(),
                // Page 5: Congratulation Page
                _buildCongratulationPage(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserRegistrationPageHeader(context, _pageController, currentPage),
        SizedBox(height: 200.h),
        Container(
          margin: EdgeInsets.only(left: 60.w),
          width: 540.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Registration',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 40.sp,
                ),
              ),
              Text(
                'We will send a code (via sms text message) to your phone number',
                style: TextStyle(
                  color: hexToColor('#636363'),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 26.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 50.h),
        Padding(
          padding: EdgeInsets.only(left: 60.w),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 285.h,
                width: 515.w,
                decoration: BoxDecoration(
                  color: hexToColorWithOpacity('#E1E1E1', 0.2),
                  border: Border.all(
                    color: hexToColor('#838383'),
                    strokeAlign: BorderSide.strokeAlignInside,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                margin: EdgeInsets.only(bottom: 25.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/india_flag.png',
                      height: 55.h,
                      width: 75.w,
                    ),
                    SizedBox(width: 15.w),
                    Text(
                      '+91',
                      style: TextStyle(
                        color: hexToColor('#636363'),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 26.sp,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: hexToColor('#636363'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 26.sp,
                          letterSpacing: 2,
                        ),
                        decoration: InputDecoration(
                            counterText: '',
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          isDense: true,
                        ),
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                      _proceedToNextPage();
                  },
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 40.w,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserRegistrationPageHeader(context, _pageController, currentPage),
        SizedBox(height: 200.h),
        Container(
          margin: EdgeInsets.only(left: 60.w),
          width: 540.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verification',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 40.sp,
                ),
              ),
              Text(
                'Enter it in the verification code box and click continue',
                style: TextStyle(
                  color: hexToColor('#636363'),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 26.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 50.h),
        Padding(
          padding: EdgeInsets.only(left: 60.w),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 285.h,
                width: 515.w,
                decoration: BoxDecoration(
                  color: hexToColor('#F5F5F5'),
                  border: Border.all(
                    color: hexToColor('#838383'),
                    strokeAlign: BorderSide.strokeAlignInside,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                margin: EdgeInsets.only(bottom: 25.h),
                child: Center(
                  child: Wrap(
                    spacing: 10.w,
                    children: List.generate(
                      _otpControllers.length,
                      (index) {
                        return Container(
                          height: 50.h,
                          width: 75.w,
                          child: TextField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            style: TextStyle(
                              color: hexToColor('#636363'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 26.sp,
                            ),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                              counterText: '',
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: hexToColor('#838383'),
                                ),
                              ),
                              isDense: true,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                if (index + 1 < _otpControllers.length) {
                                  FocusScope.of(context).nextFocus();
                                } else {
                                  setState(() {
                                    isButtonEnabled = true;
                                  });
                                  FocusScope.of(context).unfocus();
                                }
                              } else {
                                if (index > 0) {
                                  FocusScope.of(context).previousFocus();
                                  setState(() {
                                    isButtonEnabled = false;
                                  });
                                }
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    _proceedToNextPage();
                  },
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 40.w,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNamePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserRegistrationPageHeader(context, _pageController, currentPage),
        SizedBox(height: 200.h),
        Container(
          margin: EdgeInsets.only(left: 45.w),
          width: 540.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What\'s Your Name?',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 32.sp,
                ),
              ),
              Text(
                'Add your name and surname',
                style: TextStyle(
                  color: hexToColor('#636363'),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 21.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 75.h),
        Container(
          width: 515.w,
          padding: EdgeInsets.only(left: 45.w),
          child: Column(
            children: [
              TextField(
                controller: _firstNameController,
                style: TextStyle(
                  fontFamily: 'Gotham',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  label: Text('First Name'),
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                  ),
                  fillColor: hexToColorWithOpacity('#D9D9D9', 0.2),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide(
                      color: hexToColor('#838383'),
                      width: 1.0,
                    ),
                  ),
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: _lastNameController,
                style: TextStyle(
                  fontFamily: 'Gotham',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  label: Text('Last Name'),
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                  ),
                  fillColor: hexToColorWithOpacity('#D9D9D9', 0.2),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide(
                      color: hexToColor('#838383'),
                      width: 1.0,
                    ),
                  ),
                ),
                keyboardType: TextInputType.name,
              ),
            ],
          ),
        ),
        SizedBox(height: 75.h),
        Center(
          child: GestureDetector(
            onTap: () {
              _proceedToNextPage();
            },
            child: Container(
              width: 345.w,
              height: 95.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text('Continue', style: TextStyle(fontSize: 28.sp, color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserRegistrationPageHeader(context, _pageController, currentPage),
        SizedBox(height: 200.h),
        Container(
          margin: EdgeInsets.only(left: 45.w),
          width: 540.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Where are you located?',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 32.sp,
                ),
              ),
              Text(
                'Search for area, street name . . . ',
                style: TextStyle(
                  color: hexToColor('#636363'),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 50.h),
        Container(
          margin: EdgeInsets.only(left: 45.w),
          width: 515.w,
          child: TextField(
            controller: _locationController,
            style: TextStyle(
              fontFamily: 'Gotham',
              fontWeight: FontWeight.w500,
              fontSize: 24.sp,
            ),
            decoration: InputDecoration(
              label: Text('Location'),
              labelStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 24.sp,
              ),
              prefixIcon: Image.asset(
                'assets/icons/globe.png',
                width: 25.w,
                height: 25.h,
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 40,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.my_location),
                onPressed: () {
                  _getCurrentLocation();
                },
              ),
              suffixIconColor: Theme.of(context).primaryColor,
              prefixIconColor: Theme.of(context).primaryColor,
              filled: true,
              fillColor: hexToColor('#F5F5F5'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: hexToColor('#838383'),
                  strokeAlign: BorderSide.strokeAlignInside,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            keyboardType: TextInputType.name,
          ),
        ),
        SizedBox(height: 100.h),
        Center(
          child: GestureDetector(
            onTap: () async {
              if (_validateFields()) {
                await addUserDetails();
                _pageController.jumpToPage(currentPage + 1);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                    Text('Please fill in all required fields correctly.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Container(
              width: 345.w,
              height: 95.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text('Continue', style: TextStyle(fontSize: 28.sp, color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCongratulationPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildUserRegistrationPageHeader(context, _pageController, currentPage),
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
        Container(
          width: 430.w,
          child: Column(
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
                'Your account has been created',
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Hurray! you are now ready to shop from your local stores',
              style: TextStyle(
                color: hexToColor('#636363'),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 17.sp,
              ),
            ),
            Text(
              'Join Our Tnennt Community',
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
    );
  }

  Widget _buildUserRegistrationPageHeader(
      BuildContext context, PageController controller, int currentPage) {
    return Container(
      height: 100.h,
      margin: EdgeInsets.only(top: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
            decoration: BoxDecoration(
              color: hexToColor('#272822'),
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Row(
              children: [
                Image.asset('assets/white_tnennt_logo.png',
                    width: 30.w, height: 30.w),
                SizedBox(width: 16.w),
                Text(
                  'Tnennt inc.',
                  style:
                      TextStyle(color: hexToColor('#E6E6E6'), fontSize: 16.sp),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () {
                  if (currentPage == 0) {
                    Navigator.pop(context);
                  } else if (currentPage == 4) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => WidgetTree()));
                  } else {
                    controller.jumpToPage(currentPage - 1);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
