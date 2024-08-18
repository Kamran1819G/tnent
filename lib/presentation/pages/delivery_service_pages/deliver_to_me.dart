import 'package:flutter/material.dart';

import '../../../core/helpers/color_utils.dart';

class DeliverToMe extends StatefulWidget {
  const DeliverToMe({super.key});

  @override
  State<DeliverToMe> createState() => _DeliverToMeState();
}

class _DeliverToMeState extends State<DeliverToMe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 75,
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Row(
                  children: [
                    Image.asset('assets/black_tnent_logo.png',
                        width: 30, height: 30),
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
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
                decoration: BoxDecoration(
                  color: hexToColor('#EFEFEF'),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Deliver',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 24.0,
                            height: 1,
                          ),
                        ),
                        Text(
                          ' •',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18.0,
                            color: hexToColor('#FF0000'),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'to me',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 24.0,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'See all the deliveries you have received',
                      style: TextStyle(
                        color: hexToColor('#6B6B6B'),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
