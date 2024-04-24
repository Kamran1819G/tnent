import 'package:flutter/material.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/screens/store_owner/analytics_screen.dart';
import 'package:tnennt/widgets/store_profile/AddUpdateTile.dart';

import '../../widgets/store_profile/UpdateTile.dart';

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
            SizedBox(height: 40.0),
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
                  Container(
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
                                    fontSize: 20.0,
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
                              Icon(Icons.stacked_bar_chart_rounded,
                                  color: Colors.black, size: 50),
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
                  Container(
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
                          'Community'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'Post'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
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
                                    fontSize: 20.0,
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
                ],
              ),
            ),
            SizedBox(height: 20.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.flag_rounded,
                              color: hexToColor('#47E012'), size: 30.0),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Orders & Pays',
                                style: TextStyle(
                                  color: hexToColor('#272822'),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0,
                                )),
                            Text(
                              'Orders & Payments',
                              style: TextStyle(
                                color: hexToColor('#838383'),
                                fontFamily: 'Poppins',
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                  )
                ])
              ],
            ),
            SizedBox(height: 20.0),

            // Updates
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
                height: 175.0,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  AddUpdateTile(),
                  for (int i = 0; i < 5; i++)
                    UpdateTile(
                        name: "Sahachari", image: "assets/updates_image.png"),
                ])),
          ],
        ),
      ),
    );
  }
}
