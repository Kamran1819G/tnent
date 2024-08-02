import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tnennt/screens/signin_screen.dart';
import 'package:tnennt/services/firebase/firebase_auth_service.dart';
import 'package:tnennt/screens/users_screens/user_registration.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../helpers/color_utils.dart';
import '../helpers/snackbar_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? errorMessage = '';
  bool passwordVisible = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signUpWithEmailAndPassword() async {
    try {
      await Auth().signUpWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (Auth().currentUser != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserRegistration(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'An error occurred during sign up';
      });
      showSnackBar(context, errorMessage);
    } catch (e) {
      setState(() {
        errorMessage = 'An unexpected error occurred';
      });
      showSnackBar(context, errorMessage);
    }
  }

  Future<void> signUpWithGoogle() async {
    try {
      await Auth().signUpWithGoogle();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserRegistration(),
        ),
      );
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
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
                          horizontal: 16.0.w, vertical: 12.0.h),
                      decoration: BoxDecoration(
                        color: hexToColor('#272822'),
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/white_tnennt_logo.png',
                                width: 30.w, height: 30.w),
                            SizedBox(width: 16.w),
                            Text(
                              'Tnennt inc.',
                              style: TextStyle(
                                color: hexToColor('#E6E6E6'),
                                fontSize: 16.0.sp,
                              ),
                            ),
                          ]),
                    ),
                    Spacer(),
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
                      'Sign Up',
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
                  style: TextStyle(
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w500,
                    fontSize: 24.sp,
                  ),
                  decoration: InputDecoration(
                    label: Text('Email'),
                    labelStyle: TextStyle(
                      color: hexToColor('#545454'),
                      fontSize: 24.sp,
                    ),
                    suffixIcon: Icon(Icons.email_outlined),
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
                  obscureText: !passwordVisible,
                  style: TextStyle(
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w500,
                    fontSize: 24.sp,
                  ),
                  decoration: InputDecoration(
                    label: Text('Password'),
                    labelStyle: TextStyle(
                      color: hexToColor('#545454'),
                      fontSize: 24.sp,
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
              SizedBox(height: 50.h),
              Container(
                  padding: EdgeInsets.only(left: 470.w),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 40.w,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        signUpWithEmailAndPassword();
                      },
                      color: Colors.white,
                    ),
                  )),
              SizedBox(height: 200.h),
              Center(
                child: Text(
                  'Or Sign Up With',
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
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 75.h,
                        margin: EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            signUpWithGoogle();
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
                        margin: EdgeInsets.only(left: 10),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
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
              SizedBox(height: 100.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a user?',
                    style: TextStyle(
                      color: hexToColor('#636363'),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 27.sp,
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
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
                        fontSize: 27.sp,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
