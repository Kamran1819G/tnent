import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/widgets/customCheckboxListTile.dart';

class StoreRegistration extends StatefulWidget {
  const StoreRegistration({super.key});

  @override
  State<StoreRegistration> createState() => _StoreRegistrationState();
}

class _StoreRegistrationState extends State<StoreRegistration> {
  PageController _pageController = PageController();
  int currentPage = 0;
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

  final _otpControllers = List.generate(4, (_) => TextEditingController());
  final _focusNodes = List.generate(4, (_) => FocusNode());

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
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                // Page 1: Create Your Own e-Store
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRect(
                            child: Image.asset(
                              'assets/create_your_own_e-store.png',
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.35,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(height: 100),
                          Text(
                            'Create Your Own e-Store',
                            style: TextStyle(
                                color: hexToColor('#1E1E1E'),
                                fontWeight: FontWeight.w900,
                                fontSize: 26.0),
                          ),
                          Text(
                            'Make your own digital store and start selling online',
                            style: TextStyle(
                                color: hexToColor('#858585'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 5,
                        effect: ExpandingDotsEffect(
                          dotColor: hexToColor('#787878'),
                          activeDotColor: Theme.of(context).primaryColor,
                          dotHeight: 4,
                          dotWidth: 4,
                          spacing: 10,
                          expansionFactor: 5,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
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
                              horizontal: 75, vertical: 20),
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
                            Text('Get Started', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Page 2: Delivery support
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.125),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRect(
                            child: Image.asset(
                              'assets/delivery_support.png',
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.35,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(height: 100),
                          Text(
                            'Delivery Support',
                            style: TextStyle(
                                color: hexToColor('#1E1E1E'),
                                fontWeight: FontWeight.w900,
                                fontSize: 26.0),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Provided middlemen for product delivery',
                            style: TextStyle(
                                color: hexToColor('#858585'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 5,
                        effect: ExpandingDotsEffect(
                          dotColor: hexToColor('#787878'),
                          activeDotColor: Theme.of(context).primaryColor,
                          dotHeight: 4,
                          dotWidth: 4,
                          spacing: 10,
                          expansionFactor: 5,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
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
                              horizontal: 75, vertical: 20),
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
                // Page 3: Packaging
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRect(
                            child: Image.asset(
                              'assets/packaging.png',
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.35,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(height: 100),
                          Text(
                            'Packaging',
                            style: TextStyle(
                                color: hexToColor('#1E1E1E'),
                                fontWeight: FontWeight.w900,
                                fontSize: 26.0),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Provide product delivery in our custom packaging ',
                            style: TextStyle(
                                color: hexToColor('#858585'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 5,
                        effect: ExpandingDotsEffect(
                          dotColor: hexToColor('#787878'),
                          activeDotColor: Theme.of(context).primaryColor,
                          dotHeight: 4,
                          dotWidth: 4,
                          spacing: 10,
                          expansionFactor: 5,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
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
                              horizontal: 75, vertical: 20),
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
                // Page 4: Analytics
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRect(
                            child: Image.asset(
                              'assets/analytics.png',
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.4,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(height: 75),
                          Text(
                            'Analytics',
                            style: TextStyle(
                                color: hexToColor('#1E1E1E'),
                                fontWeight: FontWeight.w900,
                                fontSize: 26.0),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'See Your Business Insights & Store Matrics',
                            style: TextStyle(
                                color: hexToColor('#858585'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 5,
                        effect: ExpandingDotsEffect(
                          dotColor: hexToColor('#787878'),
                          activeDotColor: Theme.of(context).primaryColor,
                          dotHeight: 4,
                          dotWidth: 4,
                          spacing: 10,
                          expansionFactor: 5,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
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
                              horizontal: 75, vertical: 20),
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
                // Page 5: Discount Coupons
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRect(
                            child: Image.asset(
                              'assets/discount_coupons.png',
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.35,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(height: 100),
                          Text(
                            'Discount Coupons',
                            style: TextStyle(
                                color: hexToColor('#1E1E1E'),
                                fontWeight: FontWeight.w900,
                                fontSize: 26.0),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Create Discount Coupons For Your Store And Products Easily And Instantly',
                            style: TextStyle(
                                color: hexToColor('#858585'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 5,
                        effect: ExpandingDotsEffect(
                          dotColor: hexToColor('#787878'),
                          activeDotColor: Theme.of(context).primaryColor,
                          dotHeight: 4,
                          dotWidth: 4,
                          spacing: 10,
                          expansionFactor: 5,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
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
                              horizontal: 75, vertical: 20),
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
                            Text('Finish', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Page 2: Registration
                Column(
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
                        color: hexToColor('#F5F5F5'),
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
                // Page 3: Verification
                Column(
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
                        color: hexToColor('#F5F5F5'),
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
                // Page 4: Business Email
                Column(
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
                            'Enter Your Business/Store email',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'email regarding store will be sent to this email',
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
                        color: hexToColor('#F5F5F5'),
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
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                            ),
                            suffixIcon: Icon(Icons.email_outlined),
                            suffixIconColor: Theme.of(context).primaryColor,
                            border: InputBorder.none),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              activeColor: Theme.of(context).primaryColor,
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
                                  color: Theme.of(context).primaryColor,
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
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                          currentPage++;
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
                            'Your Store Name',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
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
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: hexToColor('#F5F5F5'),
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
                            label: Text('Store Name'),
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.5),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                          currentPage++;
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
                            'Set Your Store Domain',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
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
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: hexToColor('#F5F5F5'),
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
                            label: Text('Store Name'),
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                            ),
                            suffixText: '.tnennt.com',
                            suffixStyle: TextStyle(
                              color: hexToColor('#636363'),
                              fontFamily: 'Gotham',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.45),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                          currentPage++;
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
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choose Your Store Category',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
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
                          ...categories.map((category) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              child: CustomCheckboxListTile(
                                title: category,
                                selectedStyle: true,
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
                    SizedBox(height: 20),
                  ],
                ),
                // Page 8: UPI Details
                Column(
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
                            'Enter Your UPI Details',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
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
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: hexToColor('#F5F5F5'),
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
                        color: hexToColor('#F5F5F5'),
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
                            label: Text('UPI ID'),
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
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.35),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                          currentPage++;
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
                            'Enter Your Store Location',
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
                        color: hexToColor('#F5F5F5'),
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.5),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                          currentPage++;
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
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
                                      Theme.of(context).primaryColor,
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
                                      Theme.of(context).primaryColor,
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
                                      Theme.of(context).primaryColor,
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
                                      Theme.of(context).primaryColor,
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
                                      Theme.of(context).primaryColor,
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
                                      Theme.of(context).primaryColor,
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
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
                            color: Theme.of(context).primaryColor,
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
                        height: MediaQuery.of(context).size.height * 0.1),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        'assets/congratulation.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05),
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

                    SizedBox(height: MediaQuery.of(context).size.height * 0.25),
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
