import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tnent/core/helpers/color_utils.dart';

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
                  decoration: const BoxDecoration(
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
                    SizedBox(
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
                    const Spacer(),
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
                SizedBox(height: 145.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hexToColor('#2D332F'),
                          padding: EdgeInsets.all(24.w),
                          shape: CircleBorder(
                              side: BorderSide(color: hexToColor('#2D332F'))),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 30.sp,
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MiddlemenRegistrationForm(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 80.w, vertical: 24.h),
                          backgroundColor: hexToColor('#2D332F'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                        ),
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
                        )),
                  ],
                ),
                const SizedBox(height: 20),
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _idProofController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();
  final TextEditingController _vehicleRegController = TextEditingController();

  int _vehicleRadioValue = 0;
  File? _idProofImage;
  final picker = ImagePicker();

  Future<void> _pickIdProofImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _idProofImage = File(pickedFile.path);
        _idProofController.text = pickedFile.path.split('/').last;
      }
    });
  }

  //uploading id proof  to fire store
  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      final storage = FirebaseStorage.instance;
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final Reference reference = storage.ref().child('id_proofs/$fileName');

      final UploadTask uploadTask = reference.putFile(imageFile);
      final TaskSnapshot taskSnapshot = await uploadTask;

      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

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

  String _generateRandomPassword() {
    const String chars =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return List.generate(6, (index) => chars[Random().nextInt(chars.length)])
        .join();
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  Future<void> _saveDataToFirebase() async {
    try {
      final firestore = FirebaseFirestore.instance;

      String? idProofImageUrl;
      if (_idProofImage != null) {
        idProofImageUrl = await _uploadImageToFirebase(_idProofImage!);
      }

      // Extract the first name
      String fullName = _nameController.text.trim();
      String firstName = fullName.split(' ').first;

      // Generate 3 random digits
      String randomDigits = (1000 + Random().nextInt(900)).toString();

      // Create the document ID
      String docId = '$firstName$randomDigits';

      // Generate random password
      String randomPassword = _generateRandomPassword();

      await firestore.collection('Middlemens').doc(docId).set({
        'fullName': fullName,
        'dateOfBirth': _dobController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneController.text,
        'address': _addressController.text,
        'idProof': _idProofController.text,
        'idProofImageUrl': idProofImageUrl,
        'hasVehicle': _vehicleRadioValue == 1,
        'vehicleRegistrationNumber':
            _vehicleRadioValue == 1 ? _vehicleRegController.text : null,
        'upiId': _upiIdController.text,
        'emergencyContact': _emergencyContactController.text,
        'registrationDate': FieldValue.serverTimestamp(),
        'password': randomPassword,
        'middlemanId': docId,
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Successful'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your account has been created successfully.'),
                const SizedBox(height: 5),
                const Text('Your Middleman ID is:'),
                Row(
                  children: [
                    Text(
                      docId,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () => _copyToClipboard(docId),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text('Your temporary password is:'),
                Row(
                  children: [
                    Text(
                      randomPassword,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () => _copyToClipboard(randomPassword),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text('Please change your password after logging in.'),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Return to the previous screen
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Error'),
            content: Text('An error occurred during registration: $e'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
  /*bool _isValidUpiId(String upiId) {
    // This is a basic regex pattern for UPI ID validation
    // You may need to adjust it based on specific requirements
    final RegExp upiRegex = RegExp(r'^[\w\.\-_]{3,}@[\w\-]{3,}$');
    return upiRegex.hasMatch(upiId);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
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
              const SizedBox(height: 16.0),
              Image.asset('assets/black_tnent_logo.png', width: 75),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fill the form below to register as a middlemen!',
                      style: TextStyle(
                        color: hexToColor('#727272'),
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Full Name',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: hexToColor('#2D332F'),
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your full name',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: hexToColor('#727272'),
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    //DOB
                    Text(
                      'Date of Birth',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: hexToColor('#2D332F'),
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _dobController,
                      decoration: InputDecoration(
                        hintText: 'Enter your date of birth',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
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
                    const SizedBox(height: 20),
                    Text(
                      'Email Address',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: hexToColor('#2D332F'),
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your email address',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: hexToColor('#727272'),
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Phone Number',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: hexToColor('#2D332F'),
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: 'Enter your phone number',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: hexToColor('#727272'),
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Address',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: hexToColor('#2D332F'),
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: 'Enter your address',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'ID Proof',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: hexToColor('#2D332F'),
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _idProofController,
                                decoration: InputDecoration(
                                  hintText: 'Aadhar Card, Voter ID, etc.',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: hexToColor('#727272'),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: _pickIdProofImage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: hexToColor('#2D332F'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Icon(
                                Icons.upload_file,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        if (_idProofImage != null) ...[
                          const SizedBox(height: 5),
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(_idProofImage!),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 20),
                    // radio button for do you have vehicle yes or no
                    Text(
                      'Do you have a vehicle?',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: hexToColor('#2D332F'),
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 5),
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
                            fontFamily: 'Poppins',
                            color: hexToColor('#727272'),
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                          ),
                        ),
                        const SizedBox(width: 20),
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
                            fontFamily: 'Poppins',
                            color: hexToColor('#727272'),
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    if (_vehicleRadioValue == 1) ...[
                      const SizedBox(height: 20),
                      Text(
                        'Vehicle Registration No.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: hexToColor('#2D332F'),
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _vehicleRegController,
                        decoration: InputDecoration(
                          hintText: 'Enter your vehicle registration number',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
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
                    const SizedBox(height: 20),
                    // UPI ID
                    Text(
                      'UPI ID',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: hexToColor('#2D332F'),
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _upiIdController,
                      decoration: InputDecoration(
                        hintText: 'Enter your UPI ID',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: hexToColor('#727272'),
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Emergency Contact No.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: hexToColor('#2D332F'),
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _emergencyContactController,
                      decoration: InputDecoration(
                        hintText: 'Enter your emergency contact number',
                        hintStyle: TextStyle(
                          color: hexToColor('#727272'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveDataToFirebase,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hexToColor('#2D332F'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 60.0,
                            vertical: 16.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
