import 'package:flutter/material.dart';
import 'package:tnennt/screens/signin_screen.dart';
import 'package:tnennt/screens/users/user_registration.dart';

import '../helpers/color_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor('#E6E6E6'),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Image.asset('assets/tnennt_logo.png',
                          width: 20, height: 20),
                      SizedBox(width: 10),
                      Text(
                        'Tnennt inc.',
                        style: TextStyle(
                          color: hexToColor('#E6E6E6'),
                          fontWeight: FontWeight.w900,
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
                    'Sign Up',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 26,
                    ),
                  ),
                  Text(
                    'Enter the following details ',
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
                    label: Text('Username'),
                    labelStyle: TextStyle(
                      color: hexToColor('#545454'),
                      fontSize: 16,
                    ),
                    suffixIcon: Icon(Icons.person_outline),
                    suffixIconColor: Theme.of(context).primaryColor,
                    border: InputBorder.none),
                keyboardType: TextInputType.name,
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
                    label: Text('Email'),
                    labelStyle: TextStyle(
                      color: hexToColor('#545454'),
                      fontSize: 16,
                    ),
                    suffixIcon: Icon(Icons.email_outlined),
                    suffixIconColor: Theme.of(context).primaryColor,
                    border: InputBorder.none),
                keyboardType: TextInputType.emailAddress,
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
                    label: Text('Password'),
                    labelStyle: TextStyle(
                      color: hexToColor('#545454'),
                      fontSize: 16,
                    ),
                    suffixIcon: Icon(Icons.lock_open_outlined),
                    suffixIconColor: Theme.of(context).primaryColor,
                    border: InputBorder.none),
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            SizedBox(height: 20),
            Container(
                padding: EdgeInsets.only(right: 20),
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
                              builder: (context) => UserRegistration(),
                            ),
                          );
                        },
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Center(
              child: Text(
                'Or Sign Up With',
                style: TextStyle(
                  color: hexToColor('#636363'),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/google.png',
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Google',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 10),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/apple.png',
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Apple',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already a user?',
                  style: TextStyle(
                    color: hexToColor('#636363'),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: hexToColor('#636363'),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
