import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tnennt/models/user_model.dart';
import 'package:tnennt/pages/catalog_pages/checkout_screen.dart';

import '../../services/firebase/firebase_auth_service.dart';
import '../../helpers/color_utils.dart';
import '../signin_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late Future<UserModel> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = fetchUserData();
  }

  Future<UserModel> fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .get();
    return UserModel.fromFirestore(doc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<UserModel>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No user data available'));
            }

            final user = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  // Profile Card
                  Container(
                    height: 230.h,
                    width: 620.w,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: hexToColor('#2D332F'),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 16.0,
                          top: 25.0,
                          child: CircleAvatar(
                            backgroundColor: hexToColor('#F5F5F5'),
                            radius: 27.w,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black,
                                size: 22.sp,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(-0.9, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddProfileImageScreen(),
                                      ),
                                    ).then((_) => setState(() {
                                          _userFuture = fetchUserData();
                                        }));
                                  },
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 57.w,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        backgroundImage: user.photoURL != null
                                            ? NetworkImage(user.photoURL!)
                                            : null,
                                        child: user.photoURL == null
                                            ? Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 40.sp,
                                              )
                                            : null,
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        right: 0,
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 24.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.55,
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text:
                                          '${user.firstName} ${user.lastName}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Gotham Black',
                                        fontSize: 44.sp,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' •',
                                      style: TextStyle(
                                        fontFamily: 'Gotham Black',
                                        fontSize: 34.sp,
                                        color: hexToColor('#42FF00'),
                                      ),
                                    ),
                                  ]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                      tileColor: hexToColor('#EDEDED'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      leading: Container(
                        height: 80.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Icon(CupertinoIcons.location_fill,
                            color: Colors.white),
                      ),
                      title: Text(
                        user.address?['zip'] ?? 'Please set address',
                        style: TextStyle(
                          color: hexToColor('#4A4F4C'),
                          fontSize: 24.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Pincode: ',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'Poppins',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: user.address?['pincode'] ?? 'Not set',
                            style: TextStyle(
                              color: hexToColor('#787878'),
                              fontFamily: 'Poppins',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ]),
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeAddressScreen(
                                      existingAddress: user.address)));
                        },
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Icon(Icons.arrow_forward_ios,
                              size: 24.sp,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      children: [
                        _buildMenuItem(Icons.person, 'About'),
                        _buildMenuItem(Icons.delete, 'Delete Account'),
                        _buildMenuItem(Icons.help, 'Help'),
                        _buildMenuItem(Icons.gavel, 'Legal'),
                      ],
                    ),
                  ),
                  SizedBox(height: 200.h),
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                        onPressed: () {
                          Auth().signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                        ),
                        child: Text('Sign Out')),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: hexToColor('#2B2B2B'),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 18.w),
          Text(
            title,
            style: TextStyle(
              color: hexToColor('#9B9B9B'),
              fontSize: 18.sp,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class AddProfileImageScreen extends StatefulWidget {
  const AddProfileImageScreen({super.key});

  @override
  State<AddProfileImageScreen> createState() => _AddProfileImageScreenState();
}

class _AddProfileImageScreenState extends State<AddProfileImageScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  File? profileImage;
  String? photoURL;

  final User user = Auth().currentUser!;

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  Future<void> uploadImage() async {
    if (profileImage != null) {
      try {
        final String fileName = 'profile_images/${user.uid}';
        final Reference reference =
            FirebaseStorage.instance.ref().child(fileName);
        final UploadTask uploadTask = reference.putFile(profileImage!);
        final TaskSnapshot taskSnapshot = await uploadTask;
        final String url = await taskSnapshot.ref.getDownloadURL();
        setState(() {
          photoURL = url;
        });
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .update({'photoURL': photoURL});
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
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
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Add profile picture',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 26,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Add a profile photo so that your friend know it’s you',
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
                      await pickImage();
                      if (profileImage != null) {
                        _pageController.jumpToPage(_currentPage + 1);
                      }
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
                        Text('Add a picture', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Page 4: Show Profile Picture
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
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                if (profileImage != null)
                  Stack(
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.file(
                            profileImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30.0,
                          ),
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
                        'Profile picture added',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 26,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    await pickImage();
                  },
                  child: Center(
                    child: Text(
                      'Change Picture',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await uploadImage();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(16),
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
      ),
    );
  }
}
