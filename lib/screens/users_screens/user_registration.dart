import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pinput.dart';
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
  bool _isPhoneNumberUnique = true;
  bool isButtonEnabled = false;
  late UserModel _userModel;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

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
        return _validatePhoneNumber(_phoneController.text);
      case 1:
        return _validateOTP();
      case 2:
        return _validateName(
            _firstNameController.text, _lastNameController.text);
      case 3:
        return _validateLocation(_locationController.text);
      default:
        return true;
    }
  }

  Future<void> _validatePhoneNumberUnique(String phone) async{
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('phoneNumber', isEqualTo: phone)
        .get();

    setState(() {
      _isPhoneNumberUnique = querySnapshot.docs.isEmpty;
    });
  }

  bool _validatePhoneNumber(String phone) {
    // Indian phone number regex pattern
    final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');
    return phoneRegex.hasMatch(phone);
  }

  bool _validateOTP() {
    // Assuming OTP is 4 digits
    final RegExp otpRegex = RegExp(r'^\d{4}$');
    return otpRegex.hasMatch(_otpController.text);
  }

  bool _validateName(String firstName, String lastName) {
    // Name should contain only letters, spaces, and hyphens, and be between 2 and 50 characters
    final RegExp nameRegex = RegExp(r'^[a-zA-Z\s-]{2,50}$');
    return nameRegex.hasMatch(firstName) && nameRegex.hasMatch(lastName);
  }

  bool _validateLocation(String location) {
    // Location should not be empty and be between 3 and 100 characters
    return location.isNotEmpty &&
        location.length >= 3 &&
        location.length <= 100;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _proceedToNextPage() {
    if (_validateFields()) {
      _pageController.jumpToPage(currentPage + 1);
    } else {
      String errorMessage;
      switch (currentPage) {
        case 0:
          errorMessage = 'Please enter a valid 10-digit Indian phone number.';
          break;
        case 1:
          errorMessage = 'Please enter a valid 4-digit OTP.';
          break;
        case 2:
          errorMessage =
              'Please enter valid first and last names (2-50 characters, letters only).';
          break;
        case 3:
          errorMessage = 'Please enter a valid location (3-100 characters).';
          break;
        default:
          errorMessage = 'Please fill in all required fields correctly.';
      }
      _showValidationError(errorMessage);
    }
  }

  Future<String> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location services are disabled.';
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Location permissions are denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Location permissions are permanently denied.';
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Get the address from the coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    } else {
      return 'No address available.';
    }
  }

  @override
  void dispose() {
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
                if (page == 4) {
                  _confettiController.play();
                }
                if (page == 4) {
                  // Start a timer of 5 seconds when the last page is reached
                  Timer(Duration(seconds: 5), () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) =>
                              WidgetTree()),
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
                        onChanged: (value) {
                          _validatePhoneNumber(value);
                          _validatePhoneNumberUnique(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    if (_isPhoneNumberUnique) {
                      _proceedToNextPage();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Phone number already exists'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
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
                child: Center(
                  child: Pinput(
                    length: 4,
                    controller: _otpController,
                    pinAnimationType: PinAnimationType.fade,
                    onCompleted: (pin) {
                      setState(() {
                        isButtonEnabled = true;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        isButtonEnabled = value.length == 4;
                      });
                    },
                    defaultPinTheme: PinTheme(
                      width: 50.w,
                      height: 50.h,
                      textStyle: TextStyle(
                        fontSize: 26.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: hexToColor('#838383'),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 50.w,
                      height: 50.h,
                      textStyle: TextStyle(
                        fontSize: 26.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    submittedPinTheme: PinTheme(
                      width: 50.w,
                      height: 50.h,
                      textStyle: TextStyle(
                        fontSize: 26.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
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
              child: Text('Continue',
                  style: TextStyle(fontSize: 28.sp, color: Colors.white)),
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
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Fetching your current location...'),
                      duration: Duration(seconds: 30),
                    ),
                  );
                  String location = await getCurrentLocation();
                  setState(() {
                    _locationController.text = location;
                  });
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
              child: Text('Continue',
                  style: TextStyle(fontSize: 28.sp, color: Colors.white)),
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
        ],
      ),
    );
  }
}
