import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
        return _otpControllers.every((controller) => controller.text.isNotEmpty);
      case 2:
      // Validate first name and last name
        return _firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty;
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
        content: Text('Location services are disabled. Please enable the services'),
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
        content: Text('Location permissions are permanently denied, we cannot request permissions.'),
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
        String address = "${place.locality}, ${place.administrativeArea}, ${place.country}";
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
      children: [
        _buildUserRegistrationPageHeader(context, _pageController, currentPage),
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Registration',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                ),
              ),
              Text(
                'We will send a code (via sms text message) to your phone number',
                style: TextStyle(
                  color: hexToColor('#636363'),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 175,
              width: 375,
              decoration: BoxDecoration(
                color: hexToColor('#F5F5F5'),
                border: Border.all(
                  color: hexToColor('#838383'),
                  strokeAlign: BorderSide.strokeAlignInside,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 50),
              margin: EdgeInsets.only(bottom: 25),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/india_flag.png',
                    height: 40,
                  ),
                  SizedBox(width: 15),
                  Text(
                    '+91',
                    style: TextStyle(
                      color: hexToColor('#636363'),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
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
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          contentPadding: EdgeInsets.only(bottom: -15)),
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: ElevatedButton(
                onPressed: _proceedToNextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(15),
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVerificationPage() {
    return Column(
      children: [
        _buildUserRegistrationPageHeader(context, _pageController, currentPage),
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verification',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                ),
              ),
              Text(
                'Enter it in the verification code box and click continue',
                style: TextStyle(
                  color: hexToColor('#636363'),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 175,
              width: 375,
              decoration: BoxDecoration(
                color: hexToColor('#F5F5F5'),
                border: Border.all(
                  color: hexToColor('#838383'),
                  strokeAlign: BorderSide.strokeAlignInside,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
              margin: EdgeInsets.only(bottom: 25),
              child: Center(
                child: Wrap(
                  spacing: 10,
                  children: List.generate(
                    _otpControllers.length,
                        (index) {
                      return Container(
                        height: 50.0,
                        width: 50.0,
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
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
              child: ElevatedButton(
                onPressed: _proceedToNextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(15),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNamePage() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        _buildUserRegistrationPageHeader(context, _pageController, currentPage),
    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
    Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'What\'s Your Name?',
    style: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    ),
    ),
    Text(
    'Add your name and surname',
    style: TextStyle(
    color: hexToColor('#636363'),
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    ),
    ),
    ],
    ),
    ),
    SizedBox(height: 40),
    Container(
    margin: EdgeInsets.symmetric(horizontal: 16),
    child: TextField(
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
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.4),
          Center(
            child: ElevatedButton(
              onPressed: _proceedToNextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 18),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Gotham',
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Continue', style: TextStyle(fontSize: 16)),
                ],
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
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Where are you located?',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              Text(
                'Search for area, street name . . . ',
                style: TextStyle(
                  color: hexToColor('#636363'),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _locationController,
            style: TextStyle(
              fontFamily: 'Gotham',
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              label: Text('Location'),
              labelStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
              ),
              prefixIcon: Icon(
                Icons.location_on,
                size: 20,
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 40,
              ),
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
        SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: _getCurrentLocation,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: TextStyle(
                fontSize: 14,
                fontFamily: 'Gotham',
                fontWeight: FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.my_location, size: 18),
                SizedBox(width: 8),
                Text('Use Current Location', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
        Center(
          child: ElevatedButton(
            onPressed: () async {
              if (_validateFields()) {
                await addUserDetails();
                _pageController.jumpToPage(currentPage + 1);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please fill in all required fields correctly.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 18),
              textStyle: TextStyle(
                fontSize: 16,
                fontFamily: 'Gotham',
                fontWeight: FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Continue', style: TextStyle(fontSize: 16)),
              ],
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
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
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
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'assets/congratulation.png',
                width: 200,
                height: 200,
              ),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Congratulations!',
                style: TextStyle(
                  color: hexToColor('#2A2A2A'),
                  fontWeight: FontWeight.w500,
                  fontSize: 34,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Your account has been created',
                style: TextStyle(
                  color: hexToColor('#636363'),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Hurray! you are now ready to shop from your local stores',
              style: TextStyle(
                color: hexToColor('#636363'),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            Text(
              'Join Our Tnennt Community',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildUserRegistrationPageHeader(
      BuildContext context, PageController controller, int currentPage) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: hexToColor('#272822'),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              children: [
                Image.asset('assets/white_tnennt_logo.png',
                    width: 20, height: 20),
                SizedBox(width: 10),
                Text(
                  'Tnennt inc.',
                  style:
                  TextStyle(color: hexToColor('#E6E6E6'), fontSize: 14.0),
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