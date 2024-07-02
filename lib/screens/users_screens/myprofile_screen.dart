import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnennt/models/user_model.dart';
import 'package:tnennt/screens/users_screens/reset_password_screen.dart';
import 'package:tnennt/services/user_service.dart';

import '../../services/firebase/firebase_auth_service.dart';
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
                  height: 125,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: hexToColor('#2D332F'),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 16.0,
                        top: 25.0,
                        child: CircleAvatar(
                          backgroundColor: hexToColor('#F5F5F5'),
                          radius: 16,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.black,
                              size: 16,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(-0.9, -0.2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: GestureDetector(
                                onTap: () {},
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: Image.asset(
                                      'assets/profile_image.png',
                                      width: 55,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Kamran Khan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 26.0,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(width: 10.0),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 25),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
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
                          ],
                        ),
                      ),
                    ],
                  )),

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
                    Auth().signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
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
