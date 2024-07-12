import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnennt/services/firebase/firebase_auth_service.dart';
import 'package:tnennt/screens/signin_screen.dart';

import '../../helpers/color_utils.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  PageController _pageController = PageController();
  TextEditingController _emailController = TextEditingController();
  int _currentPage = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: hexToColor('#272822'),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/white_tnennt_logo.png',
                                  width: 20, height: 20),
                              SizedBox(width: 10),
                              Text(
                                'Tnennt inc.',
                                style: TextStyle(
                                  color: hexToColor('#E6E6E6'),
                                  fontSize: 14.0,
                                ),
                              ),
                            ]),
                      ),
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reset password',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 26),
                      ),
                      Text(
                        'Enter the email associated with your account and we’ll send an email with instruction to reset your paswword',
                        style: TextStyle(
                          color: hexToColor('#636363'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 50),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: hexToColor('#D9D9D9'),
                    border: Border.all(
                      color: hexToColor('#838383'),
                      strokeAlign: BorderSide.strokeAlignInside,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _emailController,
                    style: TextStyle(
                      fontFamily: 'Gotham',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                        label: Text('Email Address'),
                        labelStyle: TextStyle(
                          color: hexToColor('#545454'),
                          fontSize: 16,
                        ),
                        border: InputBorder.none),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(right: 40),
                  child: Row(
                    children: [
                      Spacer(),
                      CircleAvatar(
                        backgroundColor: _emailController.text.isNotEmpty
                            ? Theme.of(context).primaryColor
                            : Colors.grey[500],
                        radius: 30,
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () async {
                            if(_emailController.text.isNotEmpty){
                              _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                              _currentPage++;
                            }
                          },
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: hexToColor('#272822'),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/white_tnennt_logo.png',
                                  width: 20, height: 20),
                              SizedBox(width: 10),
                              Text(
                                'Tnennt inc.',
                                style: TextStyle(
                                  color: hexToColor('#E6E6E6'),
                                  fontSize: 14.0,
                                ),
                              ),
                            ]),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios_new,
                                color: Colors.black),
                            onPressed: () {
                              if (_currentPage == 0) {
                                Navigator.pop(context);
                              } else {
                                _pageController.previousPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                                _currentPage--;
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Check your email',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 26,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'We have sent a password recovery instruction to your email',
                          style: TextStyle(
                            color: hexToColor('#636363'),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {

                      _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                      _currentPage++;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      // Set the button color to black
                      foregroundColor: Colors.white,
                      // Set the text color to white
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 18),
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
                        Text('Verify email', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: hexToColor('#272822'),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/white_tnennt_logo.png',
                                  width: 20, height: 20),
                              SizedBox(width: 10),
                              Text(
                                'Tnennt inc.',
                                style: TextStyle(
                                  color: hexToColor('#E6E6E6'),
                                  fontSize: 14.0,
                                ),
                              ),
                            ]),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create new password',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 26,
                        ),
                      ),
                      Text(
                        'Your new password must be different from previous used passwords.',
                        style: TextStyle(
                          color: hexToColor('#636363'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 50),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: hexToColor('#D9D9D9'),
                    border: Border.all(
                      color: hexToColor('#838383'),
                      strokeAlign: BorderSide.strokeAlignInside,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    style: TextStyle(
                      fontFamily: 'Gotham',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                        label: Text('New Password'),
                        labelStyle: TextStyle(
                          color: hexToColor('#545454'),
                          fontSize: 16,
                        ),
                        border: InputBorder.none),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 50),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: hexToColor('#D9D9D9'),
                    border: Border.all(
                      color: hexToColor('#838383'),
                      strokeAlign: BorderSide.strokeAlignInside,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    style: TextStyle(
                      fontFamily: 'Gotham',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                        label: Text('Confirm Password'),
                        labelStyle: TextStyle(
                          color: hexToColor('#545454'),
                          fontSize: 16,
                        ),
                        border: InputBorder.none),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(right: 40),
                  child: Row(
                    children: [
                      Spacer(),
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 30,
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInScreen()));
                          },
                          color: Colors.white,
                        ),
                      ),
                    ],
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
