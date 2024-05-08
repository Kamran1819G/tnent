import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/screens/home_screen.dart';

import '../../widgets/customCheckboxListTile.dart';

class UserRegistration extends StatefulWidget {
  const UserRegistration({super.key});

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  PageController _pageController = PageController();
  File? profileImage;
  int currentPage = 0;
  bool value = false;

  final _otpControllers = List.generate(4, (_) => TextEditingController());
  final _focusNodes = List.generate(4, (_) => FocusNode());

  List<String> categories = [
    'Clothing',
    'Grocery',
    'Electronics',
    'Restaurant',
    'Book Store',
    'Bakery',
    'Beauty Apparel',
    'Cafe',
    'Florist',
    'Footwear',
    'Accessories',
    'Stationary',
    'Eyewear',
    'Watch',
    'Musical Instrument',
    'Sports'
  ];

  List<String> filteredCategories = [];

  void _filterCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCategories =
            categories; // Show all categories if the search query is empty
      } else {
        filteredCategories = categories
            .where((category) =>
                category.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
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
      backgroundColor: hexToColor('#E6E6E6'),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                // Page 1: Registration
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
                                      fontWeight: FontWeight.w900,
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
                                  if (currentPage == 0) {
                                    Navigator.pop(context);
                                  } else {
                                    _pageController.previousPage(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                    currentPage--;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                    SizedBox(height: 20),
                    Container(
                      height: 175,
                      width: 350,
                      decoration: BoxDecoration(
                        color: hexToColor('#E1E1E1'),
                        border: Border.all(
                          color: hexToColor('#838383'),
                          strokeAlign: BorderSide.strokeAlignInside,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/india_flag.png',
                            height: 30,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '+91',
                            style: TextStyle(
                              color: hexToColor('#636363'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              style: TextStyle(
                                color: hexToColor('#636363'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                          currentPage++;
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(16),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                // Page 2: Verification
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
                                      fontWeight: FontWeight.w900,
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
                                  if (currentPage == 0) {
                                    Navigator.pop(context);
                                  } else {
                                    _pageController.previousPage(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                    currentPage--;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                    SizedBox(height: 20),
                    Container(
                      height: 175,
                      width: 350,
                      decoration: BoxDecoration(
                        color: hexToColor('#E1E1E1'),
                        border: Border.all(
                          color: hexToColor('#838383'),
                          strokeAlign: BorderSide.strokeAlignInside,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                          (index) {
                            return index < 3
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: 40.0,
                                        height: 40.0,
                                        child: TextField(
                                          controller: _otpControllers[index],
                                          focusNode: _focusNodes[index],
                                          autofocus: index == 0,
                                          textAlign: TextAlign.center,
                                          maxLength: 1,
                                          style: TextStyle(
                                            fontSize: 22.0,
                                            color: hexToColor('#636363'),
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            counterText: '',
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            if (value.isNotEmpty) {
                                              if (index < 5) {
                                                _focusNodes[index + 1]
                                                    .requestFocus();
                                              } else {
                                                // OTP complete
                                              }
                                            } else {
                                              if (index > 0) {
                                                _focusNodes[index - 1]
                                                    .requestFocus();
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10.0), // Add space here
                                    ],
                                  )
                                : SizedBox(
                                    width: 40.0,
                                    height: 40.0,
                                    child: TextField(
                                      controller: _otpControllers[index],
                                      focusNode: _focusNodes[index],
                                      autofocus: index == 0,
                                      textAlign: TextAlign.center,
                                      maxLength: 1,
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        color: hexToColor('#636363'),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        counterText: '',
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          if (index < 5) {
                                            _focusNodes[index + 1]
                                                .requestFocus();
                                          } else {
                                            // OTP complete
                                          }
                                        } else {
                                          if (index > 0) {
                                            _focusNodes[index - 1]
                                                .requestFocus();
                                          }
                                        }
                                      },
                                    ),
                                  );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                          currentPage++;
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
                                      fontWeight: FontWeight.w900,
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
                                  if (currentPage == 0) {
                                    Navigator.pop(context);
                                  } else {
                                    _pageController.previousPage(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                    currentPage--;
                                  }
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
                            currentPage++;
                          }
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
                            Text('Add a picture',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(currentPage + 2,
                            duration: Duration(milliseconds: 100),
                            curve: Curves.easeInOut);
                      },
                      child: Center(
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                          ),
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
                                      fontWeight: FontWeight.w900,
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
                                  if (currentPage == 0) {
                                    Navigator.pop(context);
                                  } else {
                                    _pageController.previousPage(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                    currentPage--;
                                  }
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
                        onPressed: () {
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                          currentPage++;
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
                // Page 5: Name
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
                                      fontWeight: FontWeight.w900,
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
                                  if (currentPage == 0) {
                                    Navigator.pop(context);
                                  } else {
                                    _pageController.previousPage(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                    currentPage--;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
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
                            label: Text('First Name'),
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
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
                            label: Text('Last Name'),
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                          currentPage++;
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
                // Page 6: Location
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
                                      fontWeight: FontWeight.w900,
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
                                  if (currentPage == 0) {
                                    Navigator.pop(context);
                                  } else {
                                    _pageController.previousPage(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                    currentPage--;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
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
                            border: InputBorder.none),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                          currentPage++;
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
                // Page 7: Your Interests
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                      fontWeight: FontWeight.w900,
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
                                  if (currentPage == 0) {
                                    Navigator.pop(context);
                                  } else {
                                    _pageController.previousPage(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                    currentPage--;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    Container(
                      color: hexToColor('#E6E6E6'),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Interests',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Pick upto 5 things you love. It’ll help you get great deals related to these products',
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
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: hexToColor('#E6E6E6'),
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
                            label: Text('Enter Interest'),
                            labelStyle: TextStyle(
                              color: hexToColor('#615656'),
                              fontSize: 12,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: 30,
                            ),
                            prefixIconColor: hexToColor('#615656'),
                            border: InputBorder.none),
                        keyboardType: TextInputType.name,
                        onChanged: _filterCategories,
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3.5,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        children: [
                          if (filteredCategories.isNotEmpty)
                            ...filteredCategories.map((category) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                child: CustomCheckboxListTile(
                                  title: category,
                                ),
                              );
                            }).toList(),
                          if (filteredCategories.isEmpty)
                            ...categories.map((category) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                child: CustomCheckboxListTile(
                                  title: category,
                                ),
                              );
                            }).toList(),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                          currentPage++;
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
                    SizedBox(height: 20),
                  ],
                ),
                // Page 11:  Congratulation Page
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                      fontWeight: FontWeight.w900,
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
                                  if (currentPage == 0) {
                                    Navigator.pop(context);
                                  } else {
                                    _pageController.previousPage(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                    currentPage--;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        'assets/congratulation.png',
                        width: 200,
                        height: 200,
                      ),
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
}
