import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnennt/helpers/color_utils.dart';

class TheMiddlemen extends StatefulWidget {
  const TheMiddlemen({super.key});

  @override
  State<TheMiddlemen> createState() => _TheMiddlemenState();
}

class _TheMiddlemenState extends State<TheMiddlemen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor('#F4F0EF'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30.h),
                  height: 440.h,
                  width: 610.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/the_middlemen.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 450.w,
                      child: Text(
                        "The Middlemen Groups!".toUpperCase(),
                        style: TextStyle(
                          color: hexToColor('#2D332F'),
                          fontSize: 40.sp,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 30.h),
                Text(
                  "Get a chance to work as a certified middlemen and let’s grow together!",
                  style: TextStyle(
                    color: hexToColor('#727272'),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 30.sp),
                Row(
                  children: [
                    FlutterImageStack(
                      imageList: [
                        'https://images.unsplash.com/photo-1593642532842-98d0fd5ebc1a?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80',
                        'https://images.unsplash.com/photo-1612594305265-86300a9a5b5b?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
                        'https://images.unsplash.com/photo-1612626256634-991e6e977fc1?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1712&q=80',
                        'https://images.unsplash.com/photo-1593642702749-b7d2a804fbcf?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1400&q=80'
                      ],
                      totalCount: 4,
                      showTotalCount: true,
                      extraCountTextStyle: TextStyle(
                        color: hexToColor('#727272'),
                        fontSize: 14.sp,
                      ),
                      backgroundColor: hexToColor('#C4C4C4'),
                      itemRadius: 50.w,
                      itemCount: 3,
                      itemBorderWidth: 0,
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      'Active Middlemen',
                      style: TextStyle(
                        color: hexToColor('#727272'),
                        fontFamily: 'Poppins',
                        fontSize: 16.sp,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 50.h),
                Text(
                  "Description".toUpperCase(),
                  style: TextStyle(
                    color: hexToColor('#2D332F'),
                    fontSize: 24.sp,
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                  style: TextStyle(
                    color: hexToColor('#727272'),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 175.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 30.sp,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hexToColor('#2D332F'),
                          padding: EdgeInsets.all(24.w),
                          shape: CircleBorder(
                              side: BorderSide(color: hexToColor('#2D332F'))),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MiddlemenRegistrationForm(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Register Now',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.sp,
                                  fontFamily: 'Gotham'),
                            ),
                            SizedBox(width: 30.w),
                            Icon(
                              Icons.list_alt_rounded,
                              color: Colors.white,
                              size: 30.sp,
                            ),
                          ],
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 80.w, vertical: 24.h),
                          backgroundColor: hexToColor('#2D332F'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MiddlemenRegistrationForm extends StatefulWidget {
  const MiddlemenRegistrationForm({super.key});

  @override
  State<MiddlemenRegistrationForm> createState() =>
      _MiddlemenRegistrationFormState();
}

class _MiddlemenRegistrationFormState extends State<MiddlemenRegistrationForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _idProofController = TextEditingController();
  TextEditingController _vehicleRegController = TextEditingController();

  int _vehicleRadioValue = 0;

  Future<void> pickDoB() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Register'.toUpperCase(),
                          style: TextStyle(
                            color: hexToColor('#1E1E1E'),
                            fontSize: 24.0,
                            letterSpacing: 1.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text(
                          ' •',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: hexToColor('#FF0000'),
                          ),
                        ),
                      ],
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
              SizedBox(height: 16.0),
              Image.asset('assets/black_tnennt_logo.png', width: 75),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fill the form below to register as a middlemen!',
                      style: TextStyle(
                        color: hexToColor('#727272'),
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25),
                    Text(
                      'Full Name',
                      style: TextStyle(
                        color: hexToColor('#2D332F'),
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your full name',
                        hintStyle: TextStyle(
                          color: hexToColor('#727272'),
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    //DOB
                    Text(
                      'Date of Birth',
                      style: TextStyle(
                        color: hexToColor('#2D332F'),
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _dobController,
                      decoration: InputDecoration(
                        hintText: 'Enter your date of birth',
                        hintStyle: TextStyle(
                          color: hexToColor('#727272'),
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        pickDoB();
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Email Address',
                      style: TextStyle(
                        color: hexToColor('#2D332F'),
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your email address',
                        hintStyle: TextStyle(
                          color: hexToColor('#727272'),
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Phone Number',
                      style: TextStyle(
                        color: hexToColor('#2D332F'),
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: 'Enter your phone number',
                        hintStyle: TextStyle(
                          color: hexToColor('#727272'),
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Address',
                      style: TextStyle(
                        color: hexToColor('#2D332F'),
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: 'Enter your address',
                        hintStyle: TextStyle(
                          color: hexToColor('#727272'),
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'ID Proof',
                      style: TextStyle(
                        color: hexToColor('#2D332F'),
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _idProofController,
                      decoration: InputDecoration(
                        hintText: 'Aadhar Card, Voter ID, etc.',
                        hintStyle: TextStyle(
                          color: hexToColor('#727272'),
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // radio button for do you have vehicle yes or no
                    Text(
                      'Do you have a vehicle?',
                      style: TextStyle(
                        color: hexToColor('#2D332F'),
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: _vehicleRadioValue,
                          onChanged: (value) {
                            setState(() {
                              _vehicleRadioValue = value!;
                            });
                          },
                        ),
                        Text(
                          'Yes',
                          style: TextStyle(
                            color: hexToColor('#727272'),
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(width: 20),
                        Radio(
                          value: 2,
                          groupValue: _vehicleRadioValue,
                          onChanged: (value) {
                            setState(() {
                              _vehicleRadioValue = value!;
                            });
                          },
                        ),
                        Text(
                          'No',
                          style: TextStyle(
                            color: hexToColor('#727272'),
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    if (_vehicleRadioValue == 1) ...[
                      SizedBox(height: 20),
                      Text(
                        'Vehicle Registration No.',
                        style: TextStyle(
                          color: hexToColor('#2D332F'),
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _vehicleRegController,
                        decoration: InputDecoration(
                          hintText: 'Enter your vehicle registration number',
                          hintStyle: TextStyle(
                            color: hexToColor('#727272'),
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 20),
                    // UPI ID
                    Text(
                      'UPI ID',
                      style: TextStyle(
                        color: hexToColor('#2D332F'),
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your UPI ID',
                        hintStyle: TextStyle(
                          color: hexToColor('#727272'),
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Emergency Contact No.',
                      style: TextStyle(
                        color: hexToColor('#2D332F'),
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your emergency contact number',
                        hintStyle: TextStyle(
                          color: hexToColor('#727272'),
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hexToColor('#2D332F'),
                          padding: EdgeInsets.symmetric(
                            horizontal: 60.0,
                            vertical: 16.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
