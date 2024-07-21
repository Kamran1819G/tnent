import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/models/store_model.dart';
import 'package:tnennt/widgets/customCheckboxListTile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StoreRegistration extends StatefulWidget {
  const StoreRegistration({super.key});

  @override
  State<StoreRegistration> createState() => _StoreRegistrationState();
}


class _StoreRegistrationState extends State<StoreRegistration> {
  PageController _pageController = PageController();
  late final PageController _storeFeaturesPageController;
  int _featuresCurrentPageIndex = 0;
  int _currentPageIndex = 0;
  late ConfettiController _confettiController;

  bool value = false;

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
  String selectedCategory= '';

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _upiUsernameController = TextEditingController();
  final _upiIdController = TextEditingController();
  final _locationController = TextEditingController();
  final _otpControllers = List.generate(4, (_) => TextEditingController());
  final _focusNodes = List.generate(4, (_) => FocusNode());
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _storeFeaturesPageController = PageController()
      ..addListener(() {
        setState(() {
          _featuresCurrentPageIndex =
              _storeFeaturesPageController.page?.round() ?? 0;
        });
      });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }

    _confettiController.dispose();
    _storeFeaturesPageController.dispose();
    _pageController.dispose();
    super.dispose();
  }


  Future<void> _registerStore() async {
    try {
      // Get the current user's ID (assuming they're logged in)
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      // Create a new StoreModel instance
      final newStore = StoreModel(
        storeId: FirebaseFirestore.instance.collection('stores').doc().id,
        ownerId: currentUser.uid,
        analyticsId: 'analytics_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        logoUrl: '',
        phone: _phoneController.text,
        email: _emailController.text,
        website: '${_websiteController.text}.tnennt.com',
        upiUsername: _upiUsernameController.text,
        upiId: _upiIdController.text,
        location: _locationController.text,
        category: selectedCategory,
        isActive: true,
        createdAt: Timestamp.now(),
        totalProducts: 0,
        totalPosts: 0,
        storeEngagement: 0,
        greenFlags: 0,
        redFlags: 0,
        postIds: [],
        productIds: [],
        followerIds: [],
      );

      // Add the store to Firestore
      await FirebaseFirestore.instance
          .collection('Stores')
          .doc(newStore.storeId)
          .set(newStore.toFirestore());

      // Add storeId to user's document
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .update({'storeId':  newStore.storeId});

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Store registered successfully')),
      );
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error registering store: $e')),
      );
    }
  }


  void _onCategoryChanged(String category) {
    setState(() {
      if (selectedCategory == category) {
        selectedCategory = '';
      } else {
        selectedCategory = category;
      }
    });
  }

  void _onContinuePressed() {
    if (selectedCategory != '') {
      print('Selected category: $selectedCategory');
      _pageController.jumpToPage(_currentPageIndex + 1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a category'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
                if (index == 10) {
                  _confettiController.play();
                }
              },
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                // Page 1: e-Store Features
                _buildStoreFeatures(),
                // Page 2: Registration
                Column(
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.1),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Registration',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
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
                    SizedBox(height: 40),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 175,
                          width: 375,
                          decoration: BoxDecoration(
                            color: hexToColor('#F5F5F5'),
                            border: Border.all(
                              color: hexToColor('#838383'),
                              strokeAlign: BorderSide.strokeAlignInside,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          margin: EdgeInsets.only(bottom: 25),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/india_flag.png',
                                height: 40,
                              ),
                              SizedBox(width: 15),
                              Text(
                                '+91',
                                style: TextStyle(
                                  color: hexToColor('#636363'),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  letterSpacing: 2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _phoneController,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: hexToColor('#636363'),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    letterSpacing: 2,
                                  ),
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme
                                              .of(context)
                                              .primaryColor,
                                        ),
                                      ),
                                      contentPadding:
                                      EdgeInsets.only(bottom: -15)),
                                  maxLength: 10,
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: ElevatedButton(
                            onPressed: () {
                              _pageController.jumpToPage(_currentPageIndex + 1);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme
                                  .of(context)
                                  .primaryColor,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(15),
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Page 3: Verification
                Column(
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.1),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verification',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
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
                    SizedBox(height: 40),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 175,
                          width: 375,
                          decoration: BoxDecoration(
                            color: hexToColor('#F5F5F5'),
                            border: Border.all(
                              color: hexToColor('#838383'),
                              strokeAlign: BorderSide.strokeAlignInside,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          margin: EdgeInsets.only(bottom: 25),
                          child: Center(
                            child: Wrap(
                              spacing: 10,
                              children: List.generate(
                                _otpControllers.length,
                                    (index) {
                                  return Container(
                                    height: 50.0,
                                    width: 50.0,
                                    child: TextField(
                                      controller: _otpControllers[index],
                                      focusNode: _focusNodes[index],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      cursorColor:
                                      Theme
                                          .of(context)
                                          .primaryColor,
                                      decoration: InputDecoration(
                                        counterText: '',
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: hexToColor('#838383'),
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          if (index + 1 <
                                              _otpControllers.length) {
                                            FocusScope.of(context).nextFocus();
                                          } else {
                                            setState(() {
                                              isButtonEnabled = true;
                                            });
                                            FocusScope.of(context).unfocus();
                                          }
                                        } else {
                                          if (index > 0) {
                                            FocusScope.of(context)
                                                .previousFocus();
                                            setState(() {
                                              isButtonEnabled = false;
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: ElevatedButton(
                            onPressed: isButtonEnabled
                                ? () {
                              _pageController.jumpToPage(_currentPageIndex + 1);
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isButtonEnabled
                                  ? Theme
                                  .of(context)
                                  .primaryColor
                                  : Colors.grey,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(15),
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
                // Page 4: Business Email
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.1),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Your Business/Store email',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Email regarding store will be sent to this email',
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
                    SizedBox(height: 40),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _emailController,
                        style: TextStyle(
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          label: Text('Email'),
                          labelStyle: TextStyle(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: hexToColor('#F5F5F5'),
                          suffixIcon: Icon(Icons.email_outlined),
                          suffixIconColor: Theme
                              .of(context)
                              .primaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: hexToColor('#838383'),
                              strokeAlign: BorderSide.strokeAlignInside,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.4),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              activeColor: Theme
                                  .of(context)
                                  .primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              value: value,
                              onChanged: (value) {
                                setState(() {
                                  this.value = value!;
                                });
                              },
                            ),
                            Text(
                              'I agree to the',
                              style: TextStyle(
                                color: hexToColor('#636363'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Terms and Conditions',
                                style: TextStyle(
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.jumpToPage(_currentPageIndex + 1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hexToColor('#2D332F'),
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
                                30), // Set the button corner radius
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
                // Page 5: Store Name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.1),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Store Name',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'You can change it later from your store settings',
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
                    SizedBox(height: 40),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          label: Text('Store Name'),
                          labelStyle: TextStyle(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: hexToColor('#F5F5F5'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: hexToColor('#838383'),
                              strokeAlign: BorderSide.strokeAlignInside,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.475),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.jumpToPage(_currentPageIndex + 1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hexToColor('#2D332F'),
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
                                30), // Set the button corner radius
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Next', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Page 6: Store Domain
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.1),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Set Your Store Domain',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'People can search for your store using this domain',
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
                    SizedBox(height: 40),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller : _websiteController,
                        decoration: InputDecoration(
                          label: Text('Store Name'),
                          labelStyle: TextStyle(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontSize: 16,
                          ),
                          suffixText: '.tnennt.com',
                          suffixStyle: TextStyle(
                            color: hexToColor('#636363'),
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: hexToColor('#F5F5F5'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: hexToColor('#838383'),
                              strokeAlign: BorderSide.strokeAlignInside,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme
                                  .of(context)
                                  .primaryColor,
                              radius: 8,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'This domain is available',
                              style: TextStyle(
                                color: hexToColor('#636363'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.4375),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.jumpToPage(_currentPageIndex + 1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hexToColor('#2D332F'),
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
                                30), // Set the button corner radius
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Next', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Page 7: Store Category
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
                    SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.025),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choose Your Store Category',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Select one category which describes your store',
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
                    SizedBox(height: 40),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3.5,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        children: [
                          ...categories.map((category) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              child: CustomCheckboxListTile(
                                title: category,
                                value: selectedCategory == category,
                                onChanged: (_) => _onCategoryChanged(category),
                                selectedStyle: true,
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: _onContinuePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hexToColor('#2D332F'),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 100, vertical: 18),
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
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
                    SizedBox(height: 30),
                  ],
                ),
                // Page 8: UPI Details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.1),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Your UPI Details',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'You will receive your store payment directly to your UPI account',
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
                    SizedBox(height: 40),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _upiUsernameController,
                        style: TextStyle(
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          label: Text('Username'),
                          labelStyle: TextStyle(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: hexToColor('#F5F5F5'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: hexToColor('#838383'),
                              strokeAlign: BorderSide.strokeAlignInside,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _upiIdController,
                        style: TextStyle(
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          label: Text('UPI ID'),
                          labelStyle: TextStyle(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: hexToColor('#F5F5F5'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: hexToColor('#838383'),
                              strokeAlign: BorderSide.strokeAlignInside,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme
                                  .of(context)
                                  .primaryColor,
                              radius: 8,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'UPI ID Verified',
                              style: TextStyle(
                                color: hexToColor('#636363'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.34),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.jumpToPage(_currentPageIndex + 1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hexToColor('#2D332F'),
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
                                30), // Set the button corner radius
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Next', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Page 9: Store Location
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.1),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Your Store Location',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
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
                    SizedBox(height: 40),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _locationController,
                        style: TextStyle(
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          label: Text('Location'),
                          labelStyle: TextStyle(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.location_on,
                            size: 20,
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 40,
                          ),
                          prefixIconColor: Theme
                              .of(context)
                              .primaryColor,
                          filled: true,
                          fillColor: hexToColor('#F5F5F5'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: hexToColor('#838383'),
                              strokeAlign: BorderSide.strokeAlignInside,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.475),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.jumpToPage(_currentPageIndex + 1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hexToColor('#2D332F'),
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
                                30), // Set the button corner radius
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
                // Page 10: Store Description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
                    SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.025),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Pay Once & Own Your Store Forever',
                            style: TextStyle(
                              color: hexToColor('#2A2A2A'),
                              fontWeight: FontWeight.w500,
                              fontSize: 34,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Get instant access to your personalized store and list unlimited items to your digital space ',
                            style: TextStyle(
                              color: hexToColor('#636363'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.1),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                  Theme
                                      .of(context)
                                      .primaryColor,
                                  radius: 10,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Lifetime Store Access',
                                  style: TextStyle(
                                    color: hexToColor('#636363'),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                  Theme
                                      .of(context)
                                      .primaryColor,
                                  radius: 10,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Provided middlemen for item delivery',
                                  style: TextStyle(
                                    color: hexToColor('#636363'),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                  Theme
                                      .of(context)
                                      .primaryColor,
                                  radius: 10,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Free store domain',
                                  style: TextStyle(
                                    color: hexToColor('#636363'),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                  Theme
                                      .of(context)
                                      .primaryColor,
                                  radius: 10,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Free marketing & advertisement space',
                                  style: TextStyle(
                                    color: hexToColor('#636363'),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                  Theme
                                      .of(context)
                                      .primaryColor,
                                  radius: 10,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Unlimited coupon generator for your store',
                                  style: TextStyle(
                                    color: hexToColor('#636363'),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                  Theme
                                      .of(context)
                                      .primaryColor,
                                  radius: 10,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Print store analytics in excel, pdf or jpeg',
                                  style: TextStyle(
                                    color: hexToColor('#636363'),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Hurry up! Register now and start your digital store',
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
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          try{
                            await _registerStore();
                            _pageController.jumpToPage(_currentPageIndex + 1);
                          } catch (e) {
                            print(e);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme
                              .of(context)
                              .primaryColor,
                          // Set the button color to black
                          foregroundColor: Colors.white,
                          // Set the text color to white
                          padding: EdgeInsets.symmetric(
                              horizontal: 120, vertical: 18),
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
                            Text('Pay ₹2999.00',
                                style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Page 11:  Congratulation Page
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildStoreRegistrationPageHeader(
                        context, _pageController, _currentPageIndex),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.1),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ConfettiWidget(
                          confettiController: _confettiController,
                          blastDirectionality: BlastDirectionality.explosive,
                          shouldLoop: false,
                          colors: [Theme
                              .of(context)
                              .primaryColor
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'assets/congratulation.png',
                            width: 200,
                            height: 200,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.05),
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
                            'Your Store has been created',
                            style: TextStyle(
                              color: hexToColor('#636363'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Hurry up! Register now and start your digital store',
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
                            color: Theme
                                .of(context)
                                .primaryColor,
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

  Widget _buildStoreRegistrationPageHeader(BuildContext context,
      PageController controller, int currentPage) {
    return Container(
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
              children: [
                Image.asset(
                    'assets/white_tnennt_logo.png', width: 20, height: 20),
                SizedBox(width: 10),
                Text(
                  'Tnennt inc.',
                  style: TextStyle(
                      color: hexToColor('#E6E6E6'), fontSize: 14.0),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () {
                  if (currentPage == 0 || currentPage > 9) {
                    Navigator.pop(context);
                  } else {
                    controller.jumpToPage(currentPage - 1);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreFeatures() {
    return Stack(
      children: [
        PageView(
          controller: _storeFeaturesPageController,
          children: [
            _buildStoreFeaturePage('Create Your Own e-Store',
                'Make your own digital store and start selling online',
                'assets/create_your_own_e-store.png'),
            _buildStoreFeaturePage(
                'Delivery Support', 'Provided middlemen for product delivery',
                'assets/delivery_support.png'),
            _buildStoreFeaturePage(
                'Packaging', 'Provide product delivery in our custom packaging',
                'assets/packaging.png'),
            _buildStoreFeaturePage(
                'Analytics', 'See Your Business Insights & Store Matrics',
                'assets/analytics.png'),
            _buildStoreFeaturePage('Discount Coupons',
                'Create Discount Coupons For Your Store And Products Easily And Instantly',
                'assets/discount_coupons.png'),
          ],
        ),
        _buildStoreFeatureHeader(),
        _buildStoreFeaturePageIndicator(),
        _buildStoreFeatureNavigationButton(),
      ],
    );
  }

  Widget _buildStoreFeaturePage(String title, String subtitle,
      String imagePath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: MediaQuery
              .of(context)
              .size
              .width * 0.7,
          height: MediaQuery
              .of(context)
              .size
              .height * 0.35,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 50),
        Text(
          title,
          style: TextStyle(color: hexToColor('#1E1E1E'), fontSize: 26.0),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            subtitle,
            style: TextStyle(
              color: hexToColor('#858585'),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStoreFeatureHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
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
                ],
              ),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey[100],
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  onPressed: () {
                    if (_storeFeaturesPageController.hasClients &&
                        _featuresCurrentPageIndex > 0) {
                      _storeFeaturesPageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOutBack,
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreFeaturePageIndicator() {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Center(
        child: SmoothPageIndicator(
          controller: _storeFeaturesPageController,
          count: 5,
          effect: ExpandingDotsEffect(
            dotColor: hexToColor('#787878'),
            activeDotColor: Theme
                .of(context)
                .primaryColor,
            dotHeight: 4,
            dotWidth: 4,
            spacing: 10,
            expansionFactor: 5,
          ),
        ),
      ),
    );
  }

  Widget _buildStoreFeatureNavigationButton() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            if (_storeFeaturesPageController.hasClients) {
              if (_featuresCurrentPageIndex < 4) {
                _storeFeaturesPageController.nextPage(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeIn,
                );
              } else {
                _pageController.jumpToPage(_currentPageIndex + 1);
                _featuresCurrentPageIndex = 0;
                _storeFeaturesPageController.jumpToPage(0);
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 75, vertical: 20),
            textStyle: TextStyle(
              fontSize: 16,
              fontFamily: 'Gotham',
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            _featuresCurrentPageIndex >= 4 ? 'Finish' : 'Next',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
