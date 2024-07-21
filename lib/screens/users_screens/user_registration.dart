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
import 'package:tnennt/services/user_service.dart';
import 'package:tnennt/widget_tree.dart';

class UserRegistration extends StatefulWidget {
  UserRegistration({key}) : super(key: key);

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  PageController _pageController = PageController();
  late ConfettiController _confettiController;
  int currentPage = 0;
  bool value = false;
  bool isButtonEnabled = false;
  User? user = Auth().currentUser;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  final _otpControllers = List.generate(4, (_) => TextEditingController());
  final _focusNodes = List.generate(4, (_) => FocusNode());

  UserModel? _userModel;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 5));
    _initializeUserModel();
  }

  void _initializeUserModel() {
    final user = Auth().currentUser;
    if (user != null) {
      _userModel = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        firstName: '',
        lastName: '',
      );
    }
  }

  Future<void> addUserDetails() async {
    try {
      if (_userModel != null) {
        final updatedUser = _userModel!.copyWith(
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
      }
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
                if(page == 3) {
                  _confettiController.play();
                }
              },
              children: <Widget>[
                // Page 1: Registration
                Column(
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
                                      contentPadding:
                                      EdgeInsets.only(bottom: -15)),
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
                            onPressed: () {
                              _pageController.jumpToPage(currentPage + 1);
                            },
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
                ),
                // Page 2: Verification
                Column(
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
                                      cursorColor:
                                      Theme.of(context).primaryColor,
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
                                          if (index + 1 <
                                              _otpControllers.length) {
                                            FocusScope.of(context).nextFocus();
                                          } else {
                                            setState(() {
                                              isButtonEnabled = true;
                                            });
                                            FocusScope.of(context).unfocus();
                                          }
                                        } else {
                                          if (index > 0) {
                                            FocusScope.of(context)
                                                .previousFocus();
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
                            onPressed: isButtonEnabled
                                ? () {
                              _pageController.jumpToPage(currentPage + 1);
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isButtonEnabled
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
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
                ),
                // Page 3: Name
                Column(
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
                          ),),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.jumpToPage(currentPage + 1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          // Set the button color to black
                          foregroundColor: Colors.white,
                          // Set the text color to white
                          padding: EdgeInsets.symmetric(
                              horizontal: 100, vertical: 18),
                          // Set the padding
                          textStyle: TextStyle(
                            fontSize: 16, // Set the text size
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500, // Set the text weight
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // Set the button corner radius
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
                ),
                // Page 4: Location
                Column(
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
                          ),),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.48),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await addUserDetails();
                          _pageController.jumpToPage(currentPage + 1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          // Set the button color to black
                          foregroundColor: Colors.white,
                          // Set the text color to white
                          padding: EdgeInsets.symmetric(
                              horizontal: 100, vertical: 18),
                          // Set the padding
                          textStyle: TextStyle(
                            fontSize: 16, // Set the text size
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500, // Set the text weight
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // Set the button corner radius
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
                ),
                // Page 5:  Congratulation Page
                Column(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRegistrationPageHeader(BuildContext context, PageController controller, int currentPage) {
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
                Image.asset('assets/white_tnennt_logo.png', width: 20, height: 20),
                SizedBox(width: 10),
                Text(
                  'Tnennt inc.',
                  style: TextStyle(color: hexToColor('#E6E6E6'), fontSize: 14.0),
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WidgetTree()));
                  }
                  else {
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
