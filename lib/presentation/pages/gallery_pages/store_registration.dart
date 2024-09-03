import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tnent/core/routes/app_routes.dart';
import 'package:tnent/presentation/controllers/otp_controller.dart';
import 'package:tnent/core/helpers/color_utils.dart';
import 'package:tnent/models/store_model.dart';
import 'package:tnent/presentation/pages/webview_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/helpers/snackbar_utils.dart';

class StoreRegistration extends StatefulWidget {
  const StoreRegistration({super.key});
  @override
  State<StoreRegistration> createState() => _StoreRegistrationState();
}

class _StoreRegistrationState extends State<StoreRegistration> {
  final PageController _pageController = PageController();
  late final PageController _storeFeaturesPageController;
  int _featuresCurrentPageIndex = 0;
  int _currentPageIndex = 0;
  late ConfettiController _confettiController;

  final OTPController otpController = OTPController();
  String? sessionIdReceived;

  bool _termsAccepted = false;
  bool isButtonEnabled = false;
  bool _isStorePhoneUnique = true;
  bool _isStoreEmailUnique = true;
  bool _isStoreDomainUnique = true;

  List<String> categories = [
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
  ];
  String selectedCategory = '';

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storeDomainController = TextEditingController();
  final _upiUsernameController = TextEditingController();
  final _upiIdController = TextEditingController();
  final _locationController = TextEditingController();
  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _storeFeaturesPageController = PageController()
      ..addListener(() {
        setState(() {
          _featuresCurrentPageIndex =
              _storeFeaturesPageController.page?.round() ?? 0;
        });
      });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _storeFeaturesPageController.dispose();
    _pageController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _registerStore() async {
    try {
      // Get the current user's ID (assuming they're logged in)
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      // Create a new StoreModel instance
      final newStore = StoreModel(
        storeId: FirebaseFirestore.instance.collection('Stores').doc().id,
        ownerId: currentUser.uid,
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        logoUrl:
            "https://firebasestorage.googleapis.com/v0/b/tnennt-1e1f2.appspot.com/o/Don't%20Delete%2Fblack_tnennt_logo.png?alt=media&token=7880c411-c4dc-4615-b800-f55193f23721",
        storeDomain: '${_storeDomainController.text}.tnent.com',
        upiUsername: _upiUsernameController.text,
        upiId: _upiIdController.text,
        location: _locationController.text,
        category: selectedCategory,
        isActive: true,
        createdAt: Timestamp.now(),
        greenFlags: 0,
        redFlags: 0,
        featuredProductIds: [],
        followerIds: [],
      );

      // Add the store to Firestore
      await FirebaseFirestore.instance
          .collection('Stores')
          .doc(newStore.storeId)
          .set(newStore.toFirestore());

      // Add storeId to user's document
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .update({'storeId': newStore.storeId});

      // Show success message
      showSnackBar(context, 'Store registered successfully');
    } catch (e) {
      // Handle any errors
      showSnackBar(context, 'Error registering store: $e');
    }
  }

  Future<void> _validateStoreDomain(String domain) async {
    final storeRef = FirebaseFirestore.instance.collection('Stores');
    final querySnapshot =
        await storeRef.where('storeDomain', isEqualTo: domain).get();

    setState(() {
      _isStoreDomainUnique = querySnapshot.docs.isEmpty;
    });
  }

  Future<void> _validateStoreEmail(String email) async {
    final storeRef = FirebaseFirestore.instance.collection('Stores');
    final querySnapshot = await storeRef.where('email', isEqualTo: email).get();

    setState(() {
      _isStoreEmailUnique = querySnapshot.docs.isEmpty;
    });
  }

  Future<void> _validateStorePhone(String phone) async {
    final storeRef = FirebaseFirestore.instance.collection('Stores');
    final querySnapshot = await storeRef.where('phone', isEqualTo: phone).get();

    setState(() {
      _isStorePhoneUnique = querySnapshot.docs.isEmpty;
    });
  }

  void _onCategoryChanged(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _onContinuePressed() {
    if (selectedCategory != '') {
      print('Selected category: $selectedCategory');
      _pageController.jumpToPage(_currentPageIndex + 1);
    } else {
      showSnackBar(context, 'Please select a category');
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
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Get the address from the coordinates
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    } else {
      return 'No address available.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
                if (index == 10) {
                  _confettiController.play();
                }
                if (index == 10) {
                  // Start a timer of 5 seconds when the last page is reached
                  Timer(const Duration(seconds: 5), () {
                    Get.offAllNamed(AppRoutes.HOME_SCREEN);
                  });
                }
              },
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                // Page 1: e-Store Features
                _buildStoreFeatures(),
                // Page 2: Registration
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
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
                                const SizedBox(width: 8),
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
                                      _validateStorePhone(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () async {
                                if (_isStorePhoneUnique) {
                                  debugPrint('Sending OTP');
                                  try {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      },
                                    );

                                    sessionIdReceived =
                                        await otpController.sendOtp(
                                            _phoneController.text.trim(),
                                            context);

                                    if (!context.mounted) return;
                                    Navigator.of(context).pop();
                                    showSnackBar(
                                        context, 'OTP sent successfully');

                                    _pageController
                                        .jumpToPage(_currentPageIndex + 1);
                                  } catch (e) {
                                    debugPrint('Error in on tap : $e');

                                    showSnackBar(context,
                                        'Failed to send OTP. Please try again.');
                                  }
                                } else {
                                  showSnackBar(context,
                                      'This phone number is already registered');
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                radius: 40.w,
                                child: const Icon(
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
                ),
                // Page 3: Verification
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
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
                                length: 6,
                                controller: _otpController,
                                pinAnimationType: PinAnimationType.fade,
                                onCompleted: (pin) {
                                  setState(() {
                                    isButtonEnabled = true;
                                  });
                                },
                                onChanged: (value) {
                                  setState(() {
                                    isButtonEnabled = value.length == 6;
                                  });
                                },
                                defaultPinTheme: PinTheme(
                                  width: 56.w,
                                  height: 56.h,
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
                                  width: 56.w,
                                  height: 56.h,
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
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: GestureDetector(
                              onTap: isButtonEnabled
                                  ? () async {
                                      bool isVerified =
                                          await otpController.verifyOtp(
                                        sessionIdReceived!,
                                        _otpController.text,
                                        context,
                                      );

                                      if (isVerified) {
                                        _pageController
                                            .jumpToPage(_currentPageIndex + 1);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Invalid OTP. Please try again.')),
                                        );
                                      }
                                    }
                                  : null,
                              child: CircleAvatar(
                                backgroundColor: isButtonEnabled
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                                radius: 40.w,
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Page 4: Business Email
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
                    SizedBox(height: 200.h),
                    Container(
                      padding: EdgeInsets.only(left: 45.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Your Business/Store email',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 32.sp,
                            ),
                          ),
                          Text(
                            'Email regarding store will be sent to this email',
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
                        controller: _emailController,
                        style: TextStyle(
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 24.sp,
                        ),
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 24.sp,
                          ),
                          filled: true,
                          fillColor: hexToColor('#F5F5F5'),
                          suffixIcon: const Icon(Icons.email_outlined),
                          suffixIconColor: Theme.of(context).primaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.sp),
                            borderSide: BorderSide(
                              color: hexToColor('#838383'),
                              strokeAlign: BorderSide.strokeAlignInside,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          _validateStoreEmail(value);
                        },
                      ),
                    ),
                    if (!_isStoreEmailUnique) ...[
                      SizedBox(height: 20.h),
                      Container(
                        margin: EdgeInsets.only(left: 45.w),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 12.w,
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'This email is already registered',
                              style: TextStyle(
                                color: hexToColor('#636363'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: 550.h),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              value: _termsAccepted,
                              onChanged: (value) {
                                setState(() {
                                  _termsAccepted = value!;
                                });
                              },
                            ),
                            Text(
                              'I agree to the',
                              style: TextStyle(
                                color: hexToColor('#636363'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 20.sp,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const WebViewScreen(
                                            url:
                                                'https://tnent-updated.vercel.app/legals',
                                            title: 'Terms and Conditions')));
                              },
                              child: Text(
                                'Terms and Conditions',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.sp,
                                ),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (_emailController.text.isNotEmpty &&
                              _termsAccepted &&
                              _isStoreEmailUnique) {
                            _pageController.jumpToPage(_currentPageIndex + 1);
                          } else {
                            showSnackBar(context,
                                'Please accept the terms and conditions and provide a unique email');
                          }
                        },
                        child: Container(
                          height: 95.h,
                          width: 480.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: hexToColor('#2D332F'),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Text('Continue',
                              style: TextStyle(
                                  fontSize: 25.sp,
                                  fontFamily: 'Gotham',
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),

                // Page 5: Store Name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
                    SizedBox(height: 200.h),
                    Container(
                      padding: EdgeInsets.only(left: 45.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Store Name',
                            style: TextStyle(
                              fontSize: 32.sp,
                            ),
                          ),
                          Text(
                            'You can change it later from your store settings',
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
                        controller: _nameController,
                        style: TextStyle(
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 24.sp,
                        ),
                        decoration: InputDecoration(
                          label: const Text('Store Name'),
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 24.sp,
                          ),
                          filled: true,
                          fillColor: hexToColor('#F5F5F5'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.sp),
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
                    SizedBox(height: 650.h),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (_nameController.text.isNotEmpty) {
                            _pageController.jumpToPage(_currentPageIndex + 1);
                            setState(() {
                              _storeDomainController.text = _nameController.text
                                  .toLowerCase()
                                  .replaceAll(' ', '');
                            });
                          } else {
                            showSnackBar(
                                context, 'Please enter a valid store name');
                          }
                        },
                        child: Container(
                          height: 95.h,
                          width: 480.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: hexToColor('#2D332F'),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Text('Next',
                              style: TextStyle(
                                  fontSize: 25.sp,
                                  fontFamily: 'Gotham',
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
                // Page 6: Store Domain
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
                    SizedBox(height: 200.h),
                    Container(
                      padding: EdgeInsets.only(left: 45.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Set Your Store Domain',
                            style: TextStyle(
                              fontSize: 32.sp,
                            ),
                          ),
                          Text(
                            'People can search for your store using this domain',
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
                        controller: _storeDomainController,
                        style: TextStyle(
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 24.sp,
                        ),
                        decoration: InputDecoration(
                          label: const Text('Store Name'),
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 24.sp,
                          ),
                          suffixText: '.tnent.com',
                          suffixStyle: TextStyle(
                            color: hexToColor('#636363'),
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                            fontSize: 24.sp,
                          ),
                          filled: true,
                          fillColor: hexToColor('#F5F5F5'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            borderSide: BorderSide(
                              color: hexToColor('#838383'),
                              strokeAlign: BorderSide.strokeAlignInside,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          _validateStoreDomain(value);
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                        margin: EdgeInsets.only(left: 45.w),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: _isStoreDomainUnique
                                  ? Theme.of(context).primaryColor
                                  : Colors.red,
                              radius: 12.w,
                              child: Icon(
                                _isStoreDomainUnique
                                    ? Icons.check
                                    : Icons.close,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              _isStoreDomainUnique
                                  ? 'This domain is available'
                                  : 'This domain is not available',
                              style: TextStyle(
                                color: hexToColor('#636363'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: 600.h),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (_storeDomainController.text.isNotEmpty &&
                              _isStoreDomainUnique) {
                            _pageController.jumpToPage(_currentPageIndex + 1);
                          } else if (_storeDomainController.text.isEmpty) {
                            showSnackBar(
                                context, 'Please enter a valid store domain');
                          }
                        },
                        child: Container(
                          height: 95.h,
                          width: 480.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: hexToColor('#2D332F'),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Text('Next',
                              style: TextStyle(
                                  fontSize: 25.sp,
                                  fontFamily: 'Gotham',
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
                // Page 7: Store Category
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
                    SizedBox(height: 50.h),
                    Container(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choose Your Store Category',
                            style: TextStyle(
                              fontSize: 32.sp,
                            ),
                          ),
                          Text(
                            'Select one category which describes your store',
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
                    const SizedBox(height: 50),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                          childAspectRatio: 3.5,
                        ),
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = selectedCategory == category;

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[300]!,
                                width: 1,
                              ),
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                            ),
                            child: InkWell(
                              onTap: () => _onCategoryChanged(category),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24.w,
                                      height: 24.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey[400]!,
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? Center(
                                              child: Icon(Icons.check,
                                                  size: 16.sp,
                                                  color: Colors.white),
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16.sp,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: selectedCategory != null
                            ? _onContinuePressed
                            : null,
                        child: Container(
                          height: 95.h,
                          width: 480.w,
                          margin: EdgeInsets.only(bottom: 50.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: hexToColor('#2D332F'),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Text('Continue',
                              style: TextStyle(
                                  fontSize: 25.sp,
                                  fontFamily: 'Gotham',
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
                // Page 8: UPI Details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
                    SizedBox(height: 200.h),
                    Container(
                      padding: EdgeInsets.only(left: 45.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Your UPI Details',
                            style: TextStyle(
                              fontSize: 32.sp,
                            ),
                          ),
                          Text(
                            'You will receive your store payment directly to your UPI account',
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
                        controller: _upiUsernameController,
                        style: TextStyle(
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 24.sp,
                        ),
                        decoration: InputDecoration(
                          label: const Text('Username'),
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 24.sp,
                          ),
                          filled: true,
                          fillColor: hexToColor('#F5F5F5'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
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
                    SizedBox(height: 20.h),
                    Container(
                      margin: EdgeInsets.only(left: 45.w),
                      width: 515.w,
                      child: TextField(
                        controller: _upiIdController,
                        style: TextStyle(
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 24.sp,
                        ),
                        decoration: InputDecoration(
                          label: const Text('UPI ID'),
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 24.sp,
                          ),
                          filled: true,
                          fillColor: hexToColor('#F5F5F5'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
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
                    SizedBox(height: 20.h),
                    Container(
                        margin: EdgeInsets.only(left: 45.w),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              radius: 12.w,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'UPI ID Verified',
                              style: TextStyle(
                                color: hexToColor('#636363'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: 500.h),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (_upiUsernameController.text.isNotEmpty &&
                              _upiIdController.text.isNotEmpty) {
                            _pageController.jumpToPage(_currentPageIndex + 1);
                          } else {
                            showSnackBar(
                                context, 'Please enter your UPI details');
                          }
                        },
                        child: Container(
                          height: 95.h,
                          width: 480.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: hexToColor('#2D332F'),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Text('Next',
                              style: TextStyle(
                                  fontSize: 25.sp,
                                  fontFamily: 'Gotham',
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
                // Page 9: Store Location
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
                    SizedBox(height: 200.h),
                    Container(
                      padding: EdgeInsets.only(left: 45.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Your Store Location',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 35.sp,
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
                          label: const Text('Location'),
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 24.sp,
                          ),
                          prefixIcon: Image.asset(
                            'assets/icons/globe.png',
                            width: 25.w,
                            height: 25.h,
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 40,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.my_location),
                            onPressed: () async {
                              showSnackBar(
                                context,
                                'Fetching your current location...',
                                bgColor: Colors.green,
                                duration: const Duration(seconds: 5),
                              );

                              String location = await getCurrentLocation();
                              setState(() {
                                _locationController.text = location;
                              });
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
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
                    SizedBox(height: 650.h),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (_locationController.text.isNotEmpty) {
                            _pageController.jumpToPage(_currentPageIndex + 1);
                          } else {
                            showSnackBar(
                                context, 'Please enter your store location');
                          }
                        },
                        child: Container(
                          height: 95.h,
                          width: 480.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: hexToColor('#2D332F'),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Text('Continue',
                              style: TextStyle(
                                  fontSize: 25.sp,
                                  fontFamily: 'Gotham',
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
                // Page 10: Store Description
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildStoreRegistrationPageHeader(
                          context, _pageController, _currentPageIndex),
                      SizedBox(height: 100.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Pay Once & Own Your Store Forever',
                              style: TextStyle(
                                color: hexToColor('#2A2A2A'),
                                fontWeight: FontWeight.w500,
                                fontSize: 55.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Get instant access to your personalized store and list unlimited items to your digital space ',
                              style: TextStyle(
                                color: hexToColor('#636363'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 20.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 100.h),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 50.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: 15.w,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Lifetime Store Access',
                                    style: TextStyle(
                                      color: hexToColor('#636363'),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: 15.w,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Provided middlemen for item delivery',
                                    style: TextStyle(
                                      color: hexToColor('#636363'),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: 15.w,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Free store domain',
                                    style: TextStyle(
                                      color: hexToColor('#636363'),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: 15.w,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Free marketing & advertisement space',
                                    style: TextStyle(
                                      color: hexToColor('#636363'),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.sp),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: 15.w,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Unlimited coupon generator for your store',
                                    style: TextStyle(
                                      color: hexToColor('#636363'),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: 15.w,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Print store analytics in excel, pdf or jpeg',
                                    style: TextStyle(
                                      color: hexToColor('#636363'),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      SizedBox(height: 300.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Hurry up! Register now and start your digital store',
                            style: TextStyle(
                              color: hexToColor('#636363'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            ),
                          ),
                          Text(
                            'Join Our Tnent Community',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 30.h),
                      // Center(
                      //   child: GestureDetector(
                      //     onTap: () async {
                      //       try {
                      //         await _registerStore();
                      //         _pageController.jumpToPage(_currentPageIndex + 1);
                      //       } catch (e) {
                      //         print(e);
                      //       }
                      //     },
                      //     child: Container(
                      //       height: 95.h,
                      //       width: 595.w,
                      //       alignment: Alignment.center,
                      //       decoration: BoxDecoration(
                      //         color: Theme.of(context).primaryColor,
                      //         borderRadius: BorderRadius.circular(22.r),
                      //       ),
                      //       child: Text('Pay ₹2999.00',
                      //           style: TextStyle(
                      //               fontSize: 28.sp,
                      //               color: Colors.white,
                      //               fontFamily: 'Gotham',
                      //               fontWeight: FontWeight.w500)),
                      // ),
                      SizedBox(height: 100.h),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 50.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: 15.w,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Lifetime Store Access',
                                    style: TextStyle(
                                      color: hexToColor('#636363'),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: 15.w,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Provided middlemen for item delivery',
                                    style: TextStyle(
                                      color: hexToColor('#636363'),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: 15.w,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Free store domain',
                                    style: TextStyle(
                                      color: hexToColor('#636363'),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: 15.w,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Free marketing & advertisement space',
                                    style: TextStyle(
                                      color: hexToColor('#636363'),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.sp),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: 15.w,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Unlimited coupon generator for your store',
                                    style: TextStyle(
                                      color: hexToColor('#636363'),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: 15.w,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Print store analytics in excel, pdf or jpeg',
                                    style: TextStyle(
                                      color: hexToColor('#636363'),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      SizedBox(height: 300.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Hurry up! Register now and start your digital store',
                            style: TextStyle(
                              color: hexToColor('#636363'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Page 11:  Congratulation Page
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
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
                            'Your Store has been created',
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreRegistrationPageHeader(
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
                Image.asset('assets/white_tnent_logo.png',
                    width: 30.w, height: 30.w),
                SizedBox(width: 16.w),
                Text(
                  'Tnent inc.',
                  style:
                      TextStyle(color: hexToColor('#E6E6E6'), fontSize: 16.sp),
                ),
              ],
            ),
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
              if (currentPage == 0 || currentPage > 9) {
                Navigator.pop(context);
              } else {
                controller.jumpToPage(currentPage - 1);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStoreFeatures() {
    return Stack(
      children: [
        PageView(
          controller: _storeFeaturesPageController,
          children: [
            _buildStoreFeaturePage(
                'Create Your Own e-Store',
                'Make your own digital store and start selling online',
                'assets/create_your_own_e-store.png'),
            _buildStoreFeaturePage(
                'Delivery Support',
                'Provided middlemen for product delivery',
                'assets/delivery_support.png'),
            _buildStoreFeaturePage(
                'Packaging',
                'Provide product delivery in our custom packaging',
                'assets/packaging.png'),
            _buildStoreFeaturePage(
                'Analytics',
                'See Your Business Insights & Store Matrics',
                'assets/analytics.png'),
            _buildStoreFeaturePage(
                'Discount Coupons',
                'Create Discount Coupons For Your Store And Products Easily And Instantly',
                'assets/discount_coupons.png'),
          ],
        ),
        _buildStoreFeatureHeader(),
        _buildStoreFeaturePageIndicator(),
        _buildStoreFeatureNavigationButton(),
      ],
    );
  }

  Widget _buildStoreFeaturePage(
      String title, String subtitle, String imagePath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: 600.w,
          height: 600.h,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 50.h),
        Text(
          title,
          style: TextStyle(color: hexToColor('#1E1E1E'), fontSize: 35.sp),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: Text(
            subtitle,
            style: TextStyle(
              color: hexToColor('#858585'),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 23.sp,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStoreFeatureHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100.h,
        margin: EdgeInsets.only(top: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Row(
          children: [
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
              decoration: BoxDecoration(
                color: hexToColor('#272822'),
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Row(
                children: [
                  Image.asset('assets/white_tnent_logo.png',
                      width: 30.w, height: 30.w),
                  SizedBox(width: 16.w),
                  Text(
                    'Tnent inc.',
                    style: TextStyle(
                        color: hexToColor('#E6E6E6'), fontSize: 16.sp),
                  ),
                ],
              ),
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
                if (_storeFeaturesPageController.hasClients &&
                    _featuresCurrentPageIndex > 0) {
                  _storeFeaturesPageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutBack,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreFeaturePageIndicator() {
    return Positioned(
      bottom: 150.h,
      left: 0,
      right: 0,
      child: Center(
        child: SmoothPageIndicator(
          controller: _storeFeaturesPageController,
          count: 5,
          effect: ExpandingDotsEffect(
            dotColor: hexToColor('#787878'),
            activeDotColor: Theme.of(context).primaryColor,
            dotHeight: 6.h,
            dotWidth: 6.w,
            spacing: 10,
            expansionFactor: 5,
          ),
        ),
      ),
    );
  }

  Widget _buildStoreFeatureNavigationButton() {
    return Positioned(
      bottom: 30.h,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: () {
            if (_storeFeaturesPageController.hasClients) {
              if (_featuresCurrentPageIndex < 4) {
                _storeFeaturesPageController.nextPage(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeIn,
                );
              } else {
                _pageController.jumpToPage(_currentPageIndex + 1);
                _featuresCurrentPageIndex = 0;
                _storeFeaturesPageController.jumpToPage(0);
              }
            }
          },
          child: Container(
            height: 95.h,
            width: 490.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Text(
              _featuresCurrentPageIndex >= 4 ? 'Finish' : 'Next',
              style: TextStyle(
                  fontFamily: 'Gotham', fontSize: 25.sp, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
