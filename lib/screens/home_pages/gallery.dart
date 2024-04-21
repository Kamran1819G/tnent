import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/screens/store_owner/mystoreprofile_screen.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool myStore = true;
  bool isAccepting = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: hexToColor('#F1F0EC'),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 100,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Container(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Gallery'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 28.0,
                            letterSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: ' •',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 28.0,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    'Contact Us',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                )
              ],
            ),
          ),
          if(myStore)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Store',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyStoreProfileScreen()));
                  },
                  child: Container(
                      height: 150,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Jain Brothers',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 24.0,
                                          ),
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
                                          color: Colors.white, fontSize: 14.0),
                                    ),
                                  ],
                                )
                              ],
                            ),

                          ]),
                          Row(
                            children: [
                              Spacer(),
                              Text(
                                "Accepting Orders: ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
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
                        ],
                      )),
                ),
              ],
            ),
          SizedBox(height: 10.0),
          Dash(
            direction: Axis.horizontal,
            length: MediaQuery.of(context).size.width - 32,
            dashLength: 8,
            dashColor: Colors.grey,
          ),
          SizedBox(height: 20.0),

          Image.asset("assets/digital_store_banner.png"),
          SizedBox(height: 20.0),
          Image.asset("assets/deliver_anything_banner.png"),
          SizedBox(height: 20.0),
          Image.asset("assets/the_middleman_banner.png"),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Dash(
                direction: Axis.horizontal,
                length: (MediaQuery.of(context).size.width/3) ,
                dashLength: 8,
                dashColor: Colors.grey,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  'Coming Soon',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ),
              Dash(
                direction: Axis.horizontal,
                length: (MediaQuery.of(context).size.width/3),
                dashLength: 8,
                dashColor: Colors.grey,
              ),
            ]
          ),

          SizedBox(height: 150.0),
        ],
      ),
    );
  }
}
