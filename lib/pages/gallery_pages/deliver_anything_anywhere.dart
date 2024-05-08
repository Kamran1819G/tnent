import 'package:flutter/material.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/pages/delivery_service_pages/deliver_from_me.dart';
import 'package:tnennt/pages/delivery_service_pages/deliver_to_me.dart';
import 'package:tnennt/pages/delivery_service_pages/deliverproduct.dart';

class DeliverAnythingAnywhere extends StatefulWidget {
  const DeliverAnythingAnywhere({super.key});

  @override
  State<DeliverAnythingAnywhere> createState() =>
      _DeliverAnythingAnywhereState();
}

class _DeliverAnythingAnywhereState extends State<DeliverAnythingAnywhere> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/delivery_service_bg_1.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    height: 75,
                    padding: EdgeInsets.only(left: 16, right: 8),
                    child: Row(
                      children: [
                        Image.asset('assets/black_tnennt_logo.png',
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
                    alignment: Alignment(0, 0.1),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'Deliver Anything Anywhere Easily',
                      style: TextStyle(
                        color: hexToColor('#2A2A2A'),
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Check all your recent & ongoing delivery details just in one click',
                style: TextStyle(
                  color: hexToColor('#2A2A2A'),
                  fontFamily: 'Gotham',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeliverToMe()));
              },
              child: Container(
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
                    Text('to me',
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
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeliverFromMe()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
                decoration: BoxDecoration(
                  color: hexToColor('#FFDFDF'),
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
                            color: hexToColor('#34A853'),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    Text('from me',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 24.0,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'See all deliveries I have send',
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
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeliverProduct()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: hexToColor('#2D332F'),
                  // Set the button color to black
                  foregroundColor: Colors.white,
                  // Set the text color to white
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 18),
                  // Set the padding
                  textStyle: TextStyle(
                    fontSize: 16, // Set the text size
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w500, // Set the text weight
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        100), // Set the button corner radius
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Deliver Product', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
