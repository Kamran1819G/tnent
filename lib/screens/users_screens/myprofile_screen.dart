import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnennt/screens/users_screens/reset_password_screen.dart';

import '../../helpers/color_utils.dart';
import '../signin_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.0),
              // Profile Card
              Container(
                height: 150,
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
                                  color: hexToColor('#00F0FF'),
                                  size: 16,
                                  weight: 5),
                              SizedBox(width: 5.0),
                              Text(
                                'kamran1819g',
                                style: TextStyle(
                                    color: hexToColor('#C5C5C5'),
                                    fontSize: 12.0,
                                    fontFamily: 'Poppins'),
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
                  ],
                ),
              ),

              SizedBox(height: 20),
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                tileColor: hexToColor('#EDEDED'),
                leading: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Icon(Icons.person_outline, color: Colors.white)),
                title: Text(
                  'Taloja Phase 1, Navi Mumbai',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Pincode: ',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Poppins',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(
                      text: '410208',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontFamily: 'Poppins',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]),
                ),
                trailing: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0)),
                  child: Icon(Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    _buildMenuItem(Icons.report_problem, 'Report Issue'),
                    _buildMenuItem(Icons.person, 'About'),
                    _buildMenuItem(Icons.feedback, 'Send Feedback'),
                    _buildMenuItem(Icons.shopping_cart, 'Purchase History'),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetPasswordScreen()),
                          );
                        },
                        child: _buildMenuItem(
                            Icons.password, 'Change Password & Email')),
                    _buildMenuItem(Icons.delete, 'Delete Account'),
                    _buildMenuItem(Icons.help, 'Help'),
                    _buildMenuItem(Icons.gavel, 'Legal'),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignInScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    // Set the button color to black
                    foregroundColor: Colors.white,
                    // Set the text color to white
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    // Set the padding
                    textStyle: TextStyle(
                      fontSize: 16, // Set the text size
                      fontWeight: FontWeight.bold, // Set the text weight
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // Set the button corner radius
                    ),
                  ),
                  child: Text('Sign Out', style: TextStyle(fontSize: 14)),
                ),
              ),
              SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
              backgroundColor: hexToColor('#2B2B2B'),
              child: Icon(
                icon,
                color: Colors.white,
                size: 16,
              )),
          SizedBox(width: 16.0),
          Text(
            title,
            style: TextStyle(
              color: hexToColor('#9B9B9B'),
              fontWeight: FontWeight.w900,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}