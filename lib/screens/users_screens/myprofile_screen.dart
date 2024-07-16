import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tnennt/models/user_model.dart';
import 'package:tnennt/screens/users_screens/reset_password_screen.dart';
import 'package:tnennt/services/user_service.dart';

import '../../services/firebase/firebase_auth_service.dart';
import '../../helpers/color_utils.dart';
import '../signin_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  User? currentUser = Auth().currentUser;
  UserModel? userData;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      UserModel user = await _userService.fetchUserDetails();
      setState(() {
        userData = user;
      });
    } catch (e) {
      print('Error fetching user data: $e');
      // You might want to show an error message to the user here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.0),
              // Profile Card
              Container(
                height: 125,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: hexToColor('#2D332F'),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 16.0,
                      top: 25.0,
                      child: CircleAvatar(
                        backgroundColor: hexToColor('#F5F5F5'),
                        radius: 16,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                            size: 16,
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddProfileImageScreen(),
                                  ),
                                ).then((_) => fetchUserData());
                              },
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Theme.of(context).primaryColor,
                                    backgroundImage: userData?.photoURL != null
                                        ? NetworkImage(userData!.photoURL!)
                                        : null,
                                    child: userData?.photoURL == null
                                        ? Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 40,
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
                          SizedBox(width: 10.0),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                userData?.displayName ?? 'Loading...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(width: 10.0),
                              Container(
                                width: 8,
                                height: 8,
                                margin: EdgeInsets.symmetric(vertical: 25),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                  tileColor: hexToColor('#EDEDED'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  leading: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Icon(CupertinoIcons.location_fill, color: Colors.white),
                  ),
                  title: Text(
                    userData?.location ?? 'Address not set',
                    style: TextStyle(
                      color: hexToColor('#4A4F4C'),
                      fontSize: 16.0,
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
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: userData?.pincode ?? 'Not set',
                        style: TextStyle(
                          color: hexToColor('#787878'),
                          fontFamily: 'Poppins',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]),
                  ),
                  trailing: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: Icon(Icons.arrow_forward_ios, size: 18, color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    _buildMenuItem(Icons.person, 'About'),
                    _buildMenuItem(Icons.delete, 'Delete Account'),
                    _buildMenuItem(Icons.help, 'Help'),
                    _buildMenuItem(Icons.gavel, 'Legal'),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Auth().signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text('Sign Out', style: TextStyle(fontSize: 14)),
                ),
              ),
              SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: hexToColor('#2B2B2B'),
            child: Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
          ),
          SizedBox(width: 16.0),
          Text(
            title,
            style: TextStyle(
              color: hexToColor('#9B9B9B'),
              fontSize: 14.0,
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
  PageController _pageController = PageController();
  File? profileImage;
  String? photoURL;
  User? user = Auth().currentUser;

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
    try {
      final user = this.user;
      if (user != null && profileImage != null) {
        photoURL = await UserService().uploadProfilePicture(uid: user.uid, file: profileImage!);

        // Update user data in Firebase
        await UserService().updateUser(uid: user.uid, data: {'profilePicture': photoURL});
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Image uploaded successfully!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          children: [
            // Page 3: Add Profile Picture
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
                        _pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
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
                      Container(
                        margin: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios_new,
                                color: Colors.black),
                            onPressed: () {
                              _pageController.previousPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      ),
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
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
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
