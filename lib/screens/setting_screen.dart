import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 100.0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black,
              radius: 50.0,
              child: Image.asset('assets/profile_image.png')),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Kamran Khan',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.grey[100],
              elevation: 0.0,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Location", style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    )),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        Icon(Icons.location_pin, color: Colors.black),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'Navi Mumbai, Maharashtra, India',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            color: Colors.grey[600], size: 16.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Card(
              color: Colors.grey[100],
              elevation: 0.0,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload/Change your document',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Submit your government documents so that we can verify its you',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.upload_file,
                        color: Colors.grey[600],),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMenuItem(Icons.report_problem, 'Report Issue'),
                _buildMenuItem(Icons.person, 'About'),
                _buildMenuItem(Icons.feedback, 'Send Feedback'),
                _buildMenuItem(Icons.shopping_cart, 'Purchase History'),
                _buildMenuItem(Icons.password, 'Change Password & Email'),
                _buildMenuItem(Icons.delete, 'Delete Account'),
                _buildMenuItem(Icons.help, 'Help'),
                _buildMenuItem(Icons.gavel, 'Legal'),
                SizedBox(height: 16.0),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      // Set the button color to black
                      foregroundColor: Colors.white,
                      // Set the text color to white
                      padding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
                )
              ],
            ),
          ],
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
            backgroundColor: Colors.black,
              child: Icon(icon, color: Colors.white, size: 16,)),
          SizedBox(width: 16.0),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
