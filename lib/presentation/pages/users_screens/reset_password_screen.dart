import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnent/presentation/pages/signin_screen.dart';
import 'package:tnent/core/helpers/color_utils.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? actionCode;

  const ResetPasswordScreen({Key? key, this.actionCode}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  int _currentPage = 0;
  String? _email;

  @override
  void initState() {
    super.initState();
    if (widget.actionCode != null) {
      _verifyPasswordResetCode();
    }
  }

  Future<void> _sendPasswordResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send reset email: ${e.toString()}')),
      );
    }
  }

  Future<void> _verifyPasswordResetCode() async {
    try {
      _email = await FirebaseAuth.instance
          .verifyPasswordResetCode(widget.actionCode!);
      _pageController.jumpToPage(2); // Jump to new password page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid or expired action code')),
      );
      Navigator.of(context).pop(); // Go back to previous screen
    }
  }

  Future<void> _resetPassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: widget.actionCode!,
        newPassword: _newPasswordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset successfully')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reset password: ${e.toString()}')),
      );
    }
  }

  Widget _buildHeader() {
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
          Spacer(),
          if (_currentPage == 0 || widget.actionCode == null)
            IconButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey[100]),
                shape: MaterialStateProperty.all(CircleBorder()),
              ),
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
        ],
      ),
    );
  }

  Widget _buildEmailPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        SizedBox(height: 200.h),
        Container(
          width: 485.w,
          padding: EdgeInsets.only(left: 26.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reset password',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 40.sp),
              ),
              Text(
                "Enter the email associated with your account and we'll send an email with instructions to reset your password",
                style: TextStyle(
                  color: hexToColor('#636363'),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 27.sp,
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
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.only(left: 470.w),
          child: CircleAvatar(
            backgroundColor: _emailController.text.isNotEmpty
                ? Theme.of(context).primaryColor
                : Colors.grey[500],
            radius: 40.w,
            child: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: _emailController.text.isNotEmpty
                  ? _sendPasswordResetEmail
                  : null,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckEmailPage() {
    return Column(
      children: [
        _buildHeader(),
        SizedBox(height: 400.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Check your email',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 40.sp,
                ),
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'We have sent a password recovery instruction to your email',
                  style: TextStyle(
                    color: hexToColor('#636363'),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 27.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 50.h),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context), // Return to previous screen
            child: Container(
              width: 345.w,
              height: 95.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'Back to Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewPasswordPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        SizedBox(height: 200.h),
        Container(
          width: 485.w,
          padding: EdgeInsets.only(left: 26.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create new password',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 40.sp,
                ),
              ),
              Text(
                'Your new password must be different from previously used passwords.',
                style: TextStyle(
                  color: hexToColor('#636363'),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 27.sp,
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
            controller: _newPasswordController,
            obscureText: true,
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
              border: InputBorder.none,
            ),
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
            controller: _confirmPasswordController,
            obscureText: true,
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
              border: InputBorder.none,
            ),
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
                  onPressed: _resetPassword,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: [
            _buildEmailPage(),
            _buildCheckEmailPage(),
            _buildNewPasswordPage(),
          ],
        ),
      ),
    );
  }
}
