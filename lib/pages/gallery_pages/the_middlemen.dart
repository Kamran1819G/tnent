import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
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
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 20),
            Image.asset('assets/the_middlemen.png'),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    "The Middlemen Groups!".toUpperCase(),
                    style: TextStyle(
                      color: hexToColor('#2D332F'),
                      fontWeight: FontWeight.w900,
                      fontSize: 28.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    'View List',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 10.0,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Get a chance to work as a certified middlemen and let’s grow together!",
              style: TextStyle(
                color: hexToColor('#727272'),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 12.0,
              ),
            ),
            SizedBox(height: 20),
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
                    fontWeight: FontWeight.w900,
                    fontSize: 10.0,
                  ),
                  backgroundColor: hexToColor('#C4C4C4'),
                  itemRadius: 25,
                  itemCount: 3,
                  itemBorderWidth: 0,
                ),
                SizedBox(width: 20),
                Text(
                  'Active Middlemen',
                  style: TextStyle(
                    color: hexToColor('#727272'),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w900,
                    fontSize: 12.0,
                  ),
                )
              ],
            ),
            SizedBox(height: 40),
            Text(
              "Description".toUpperCase(),
              style: TextStyle(
                color: hexToColor('#2D332F'),
                fontWeight: FontWeight.w900,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
              style: TextStyle(
                color: hexToColor('#727272'),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 12.0,
              ),
            ),
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hexToColor('#2D332F'),
                      padding: EdgeInsets.all(16.0),
                      shape: CircleBorder(
                          side: BorderSide(color: hexToColor('#2D332F'))),
                    )),
                TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Register Now',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'Gotham'),
                        ),
                        SizedBox(width: 20.0),
                        Icon(
                          Icons.list_alt_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 75.0, vertical: 20.0),
                      backgroundColor: hexToColor('#2D332F'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ))
              ],
            )
          ]),
        ),
      )),
    );
  }
}
