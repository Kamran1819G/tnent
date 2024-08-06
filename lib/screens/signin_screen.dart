// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tnent/services/notification_service.dart';
import 'package:tnent/helpers/snackbar_utils.dart';
import 'package:tnent/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tnent/services/firebase/firebase_auth_service.dart';
import 'package:tnent/screens/users_screens/reset_password_screen.dart';
import 'package:tnent/widget_tree.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../helpers/color_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String? errorMessage = '';
  bool passwordVisible = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WidgetTree(),
        ),
      );
      await NotificationService.onUserLogin();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
      showSnackBar(context, errorMessage);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await Auth().signInWithGoogle();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WidgetTree(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });

      showSnackBar(context, errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100.h,
                margin: EdgeInsets.only(left: 20.w, top: 20.h),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.0.h),
                      decoration: BoxDecoration(
                        color: hexToColor('#272822'),
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/white_tnent_logo.png',
                                width: 30.w, height: 30.w),
                            const SizedBox(width: 10),
                            Text(
                              'Tnent inc.',
                              style: TextStyle(
                                color: hexToColor('#E6E6E6'),
                                fontSize: 16.0.sp,
                              ),
                            ),
                          ]),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              SizedBox(height: 200.h),
              Container(
                padding: EdgeInsets.only(left: 40.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 40.sp,
                      ),
                    ),
                    Text(
                      'Enter the following details ',
                      style: TextStyle(
                        color: hexToColor('#636363'),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 30.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.h),
              Container(
                margin: EdgeInsets.only(left: 32.w),
                width: 520.w,
                child: TextField(
                  controller: emailController,
                  style: const TextStyle(
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    label: const Text('Email'),
                    labelStyle: TextStyle(
                      color: hexToColor('#545454'),
                      fontSize: 16,
                    ),
                    suffixIcon: const Icon(Icons.email_outlined),
                    suffixIconColor: Theme.of(context).primaryColor,
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
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                margin: EdgeInsets.only(left: 32.w),
                width: 520.w,
                child: TextField(
                  controller: passwordController,
                  cursorColor: Theme.of(context).primaryColor,
                  style: const TextStyle(
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  obscureText: !passwordVisible,
                  decoration: InputDecoration(
                    label: const Text('Password'),
                    labelStyle: TextStyle(
                      color: hexToColor('#545454'),
                      fontSize: 16,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                      child: Icon(
                        passwordVisible ? Icons.lock_open : Icons.lock_outline,
                      ),
                    ),
                    suffixIconColor: Theme.of(context).primaryColor,
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
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
              SizedBox(height: 10.h),
              GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResetPasswordScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(left: 50.w),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: hexToColor('#636363'),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                  padding: EdgeInsets.only(left: 470.w),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 40.w,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        signInWithEmailAndPassword();
                      },
                      color: Colors.white,
                    ),
                  )),
              SizedBox(height: 200.h),
              // Create google and apple sign in buttons
              Center(
                child: Text(
                  'Or Sign In With',
                  style: TextStyle(
                    color: hexToColor('#636363'),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 23.sp,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 75.h,
                        margin: const EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            signInWithGoogle();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/google.png',
                                width: 30.w,
                                height: 30.h,
                              ),
                              SizedBox(width: 16.w),
                              Text(
                                'Google',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 75.h,
                        margin: const EdgeInsets.only(left: 10),
                        child: ElevatedButton(
                          onPressed: () async {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/facebook.png',
                                width: 30.w,
                                height: 30.h,
                              ),
                              SizedBox(width: 16.w),
                              Text(
                                'Facebook',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24.sp,
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
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New Here?',
                    style: TextStyle(
                      color: hexToColor('#636363'),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 27.sp,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: hexToColor('#636363'),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 27.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
