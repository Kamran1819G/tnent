import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tnennt/screens/product_detail_screen.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/screens/store_owner_screens/analytics_screen.dart';
import 'package:tnennt/screens/store_owner_screens/order_pays_screen.dart';
import 'package:tnennt/screens/store_owner_screens/product_categories_screen.dart';
import 'package:tnennt/screens/store_owner_screens/store_settings_screen.dart';

class MyStoreProfileScreen extends StatefulWidget {
  const MyStoreProfileScreen({super.key});

  @override
  State<MyStoreProfileScreen> createState() => _MyStoreProfileScreenState();
}

class _MyStoreProfileScreenState extends State<MyStoreProfileScreen> {
  bool isAccepting = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            // Profile Card
            Container(
                height: 200,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: hexToColor('#2D332F'),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                        height: 75,
                        width: 75,
                        margin: EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            image: DecorationImage(
                                image: AssetImage('assets/jain_brothers.png'),
                                fit: BoxFit.cover)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Jain Brothers',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 28.0,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Container(
                                width: 10,
                                height: 10,
                                margin: EdgeInsets.symmetric(vertical: 25),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.web,
                                  color: hexToColor('#00F0FF'), size: 16),
                              SizedBox(width: 5.0),
                              Text(
                                'jainbrothers.tnennet.store',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 12.0),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30.0, bottom: 50),
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
                    ]),
                    SizedBox(height: 20.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.ios_share, color: Colors.white, size: 18),
                          SizedBox(width: 10.0),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text(
                              'Navi Mumbai',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 12.0),
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Accepting Orders: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                            ),
                          ),
                          Switch(
                              value: isAccepting,
                              activeColor: hexToColor('#41FA00'),
                              trackOutlineColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.grey),
                              trackOutlineWidth:
                                  MaterialStateProperty.resolveWith(
                                      (states) => 1.0),
                              activeTrackColor: Colors.transparent,
                              inactiveTrackColor: Colors.transparent,
                              onChanged: (value) {
                                setState(() {
                                  isAccepting = !isAccepting;
                                });
                              })
                        ],
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 20.0),

            Container(
              height: 140,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductCategoriesScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 125,
                      width: 125,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: hexToColor('#DDF1EF'),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'List'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15.0,
                                  ),
                                ),
                                TextSpan(
                                  text: ' •',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20.0,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Product'.toUpperCase(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '137',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    'Products'.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10.0),
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: hexToColor('#0D6A6D'),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnalyticsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 125,
                      width: 125,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: hexToColor('#EAE6F6'),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Analytics'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15.0,
                                  ),
                                ),
                                TextSpan(
                                  text: ' •',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20.0,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.asset(
                                'assets/icons/analytics.png',
                                width: 60.0,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10.0),
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoreCommunity(),
                        ),
                      );
                    },
                    child: Container(
                      height: 125,
                      width: 125,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: hexToColor('#EFEFEF'),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Store'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16.0,
                                  ),
                                ),
                                TextSpan(
                                  text: ' •',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16.0,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Community'.toUpperCase(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'Post'.toUpperCase(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '17',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    'Posts'.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ],
                              ),
                              // right arrow box
                              Container(
                                margin: EdgeInsets.only(left: 10.0),
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[700],
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  left: 20.0,
                                  right: 50.0,
                                  top: 15.0,
                                  bottom: 15.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Store Engagement',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    Text(
                                      '2500',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.flag_rounded,
                                      color: hexToColor('#47E012'), size: 30.0),
                                  SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Total Reviews',
                                          style: TextStyle(
                                            color: hexToColor('#272822'),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 14.0,
                                          )),
                                      Text(
                                        '700/900',
                                        style: TextStyle(
                                          color: hexToColor('#838383'),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrderAndPaysScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 200.0,
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: hexToColor('#F3F3F3'),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.person_outline,
                                              color: Colors.black)),
                                      SizedBox(width: 10.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Orders & Pays',
                                              style: TextStyle(
                                                color: hexToColor('#272822'),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.0,
                                              )),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              'Orders, Payments & Coupons',
                                              style: TextStyle(
                                                color: hexToColor('#838383'),
                                                fontFamily: 'Poppins',
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StoreSettingsScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 200.0,
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: hexToColor('#F3F3F3'),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.settings_outlined,
                                              color: Colors.black)),
                                      SizedBox(width: 10.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('My Settings',
                                              style: TextStyle(
                                                color: hexToColor('#272822'),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.0,
                                              )),
                                          Text('Store Settings',
                                              style: TextStyle(
                                                color: hexToColor('#838383'),
                                                fontFamily: 'Poppins',
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ])
                      ],
                    ),

                    SizedBox(height: 20.0),

                    // Updates
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: RichText(
                            text: TextSpan(
                              text: 'Updates',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            height: 150.0,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: hexToColor('#F3F3F3'),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Container(
                                              margin: EdgeInsets.all(16.0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: Icon(Icons.add,
                                                  size: 34.0,
                                                  color:
                                                      hexToColor('#B5B5B5'))),
                                        ),
                                      ],
                                    ),
                                  ),
                                  for (int i = 0; i < 5; i++)
                                    UpdateTile(
                                        name: "Sahachari",
                                        image: "assets/sahachari_image.png"),
                                ])),
                      ],
                    ),

                    // Featured Products
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Featured Products Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Featured Products',
                            style: TextStyle(
                              color: hexToColor('#343434'),
                              fontWeight: FontWeight.w900,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          height: 200.0,
                          padding: EdgeInsets.only(left: 8.0),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return ProductTile(
                                  name: "Cannon XYZ",
                                  image: "assets/product_image.png",
                                  price: 200);
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreCommunity extends StatefulWidget {
  const StoreCommunity({super.key});

  @override
  State<StoreCommunity> createState() => _StoreCommunityState();
}

class _StoreCommunityState extends State<StoreCommunity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Container(
                    height: 75,
                    width: 100,
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: hexToColor('#BEBEBE'), width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '17',
                          style: TextStyle(
                            color: hexToColor('#343434'),
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          'Posts',
                          style: TextStyle(
                            color: hexToColor('#7D7D7D'),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
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
                      backgroundColor: hexToColor('#F5F5F5'),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CommunityPost(
                      name: 'Kamran Khan',
                      profileImage: 'assets/profile_image.png',
                      postTime: '8 h ago',
                      caption:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      image: 'assets/post_image.png',
                      likes: 991,
                      productLink: 'https://example.com/product',
                    ),
                    CommunityPost(
                      name: 'Kamran Khan',
                      profileImage: 'assets/profile_image.png',
                      postTime: '8 h ago',
                      caption:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      likes: 991,
                    ),
                    CommunityPost(
                      name: 'Kamran Khan',
                      profileImage: 'assets/profile_image.png',
                      postTime: '8 h ago',
                      caption:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      likes: 991,
                    ),
                    SizedBox(height: 100.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommunityPost extends StatelessWidget {
  final String name;
  final String profileImage;
  final String postTime;
  final String? image;
  final String? caption;
  final String? productLink;
  final int? likes;

  const CommunityPost({
    super.key,
    required this.name,
    required this.profileImage,
    required this.postTime,
    this.image,
    this.caption,
    this.productLink,
    this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User information row
          Row(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(profileImage),
                    radius: 20.0,
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        postTime,
                        style: TextStyle(
                          color: hexToColor('#9C9C9C'),
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    context: context,
                    builder: (context) => _buildMoreBottomSheet(),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: hexToColor('#F5F5F5'),
                  child: Icon(
                    Icons.more_horiz,
                    color: hexToColor('#BEBEBE'),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          // Caption
          if (caption != null)
            Text(
              caption!,
              style: TextStyle(
                color: hexToColor('#737373'),
                fontSize: 12.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          SizedBox(height: 10),
          // Post image
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                image!,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(height: 10),
          // Likes
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                decoration: BoxDecoration(
                  border: Border.all(color: hexToColor('#BEBEBE')),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '$likes',
                      style: TextStyle(
                          color: hexToColor('#989797'), fontSize: 12.0),
                    ),
                  ],
                ),
              ),
              Spacer(),
              if (productLink != null)
                Chip(
                  backgroundColor: hexToColor('#EDEDED'),
                  side: BorderSide.none,
                  label: Text(
                    '${productLink!}',
                    style: TextStyle(
                      color: hexToColor('#B4B4B4'),
                      fontFamily: 'Gotham',
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  avatar: Icon(
                    Icons.link_outlined,
                    color: hexToColor('#B4B4B4'),
                  ),
                ),
              Spacer(),
              Icon(Icons.ios_share_outlined)
            ],
          ),
        ],
      ),
    );
  }

  _buildMoreBottomSheet() {
    return Container(
      height: 250,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: hexToColor('#CACACA'),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(height: 50),
          CircleAvatar(
            backgroundColor: hexToColor('#2B2B2B'),
            child: Icon(
              Icons.report_gmailerrorred,
              color: hexToColor('#BEBEBE'),
              size: 20,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Report',
            style: TextStyle(
              color: hexToColor('#9B9B9B'),
              fontWeight: FontWeight.w900,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}

class UpdateTile extends StatelessWidget {
  final String name;
  final String image;

  UpdateTile({
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: hexToColor('#B5B5B5'), width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.asset(image, height: 48.0)),
        ],
      ),
    );
  }
}

class ProductTile extends StatefulWidget {
  final String name;
  final String image;
  final double price;

  ProductTile({
    required this.name,
    required this.image,
    required this.price,
  });

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              images: [
                Image.asset(widget.image),
                Image.asset(widget.image),
                Image.asset(widget.image),
              ],
              productName: widget.name,
              productDescription:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. eiusmod tempor incididunt ut labore et do.',
              productPrice: widget.price,
              storeName: 'Jain Brothers',
              storeLogo: 'assets/jain_brothers.png',
              Discount: 10,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: hexToColor('#F5F5F5'),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage(widget.image),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  right: 8.0,
                  top: 8.0,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 200,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 100,
                                    height: 4,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    decoration: BoxDecoration(
                                      color: hexToColor('#CACACA'),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            color: hexToColor('#2B2B2B'),
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                          ),
                                          child: Icon(
                                            Icons.edit_note,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Edit',
                                          style: TextStyle(
                                              color: hexToColor('#9C9C9C'),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            color: hexToColor('#2B2B2B'),
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                          ),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Delete',
                                          style: TextStyle(
                                              color: hexToColor('#9C9C9C'),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Icon(
                        Icons.remove,
                        color: Colors.red,
                        size: 14.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                        color: hexToColor('#343434'),
                        fontWeight: FontWeight.w900,
                        fontSize: 10.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '\$${widget.price.toString()}',
                    style: TextStyle(
                        color: hexToColor('#343434'),
                        fontWeight: FontWeight.w900,
                        fontSize: 10.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
