import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnennt/helpers/color_utils.dart';

import 'notification_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Explore'.toUpperCase(),
                        style: TextStyle(
                          color: hexToColor('#1E1E1E'),
                          fontWeight: FontWeight.w900,
                          fontSize: 24.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        ' •',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 28.0,
                          color: hexToColor('#FAD524'),
                        ),
                      ),
                    ],
                  ),

                  Spacer(),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotificationScreen()));
                          },
                          child: Image.asset('assets/icons/notification_box.png', height: 24, width: 24, fit: BoxFit.cover, colorBlendMode: BlendMode.overlay,)),
                      SizedBox(width: 10),
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
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  width: 1,
                  color: hexToColor('#DDDDDD'),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25.0,
                    backgroundColor: hexToColor('#EEEEEE'),
                    child: CircleAvatar(
                      radius: 15.0,
                      backgroundColor: hexToColor('#DDDDDD'),
                      child: Icon(
                        Icons.search,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Products & Store',
                        hintStyle: TextStyle(
                          color: hexToColor('#6D6D6D'),
                          fontWeight: FontWeight.w900,
                          fontSize: 16.0,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
