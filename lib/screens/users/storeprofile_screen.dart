import 'package:flutter/material.dart';

import '../../widgets/store_profile/UpdateTile.dart';

class StoreProfileScreen extends StatefulWidget {
  const StoreProfileScreen({super.key});

  @override
  State<StoreProfileScreen> createState() => _StoreProfileScreenState();
}

class _StoreProfileScreenState extends State<StoreProfileScreen> {

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
                  color: Colors.grey[800],
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
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage('assets/profile_image.png'),
                                fit: BoxFit.cover)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Kamran Khan',
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
                            children: [
                              Icon(Icons.person_outline,
                                  color: Colors.blue, size: 16),
                              SizedBox(width: 5.0),
                              Text(
                                'kamran1819g',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
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
                        children: [

                          // Share Button
                          Icon(Icons.ios_share, color: Colors.white),

                          SizedBox(width: 10.0),

                          // Location
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.location_pin,
                                    color: Colors.white, size: 16),
                                SizedBox(width: 5.0),
                                Text(
                                  'Navi Mumbai',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),

                          Spacer(),

                          // 3 dots
                          GestureDetector(
                            onTap: (){

                            },
                            child: Icon(Icons.more_horiz, color: Colors.white, size: 50.0),
                          ),
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
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Total'.toUpperCase(),
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
                          'Customers'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '137',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'Customers'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 125,
                    width: 125,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Total'.toUpperCase(),
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
                        Text(
                          'Reviews'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 14,
                          child: Icon(
                            Icons.flag_sharp,
                            color: Colors.green,
                            size: 20.0,
                          ),
                        ),
                        Text(
                          '800/900',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 125,
                    width: 125,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.brown[50],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                borderRadius: BorderRadius.circular(10.0),
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
            SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RichText(
                text: TextSpan(
                  text: 'Highlights',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              height: 175.0,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return UpdateTile(
                        name: "Sahachari", image: "assets/sahachari_image.png");
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
