import 'package:flutter/material.dart';
import 'package:tnennt/widgets/community/community_post.dart';

import '../../helpers/color_utils.dart';
import 'package:tnennt/screens/create_community_post_screen.dart';

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Row(
                children: [
                  Text(
                    'Community'.toUpperCase(),
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
                      color: hexToColor('#FF0000'),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: hexToColor('#F5F5F5'),
                  child: IconButton(
                    icon: Icon(Icons.create_outlined, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CreateCommunityPostScreen()));
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        CommunityPost(
          name: 'Kamran Khan',
          profileImage: 'assets/profile_image.png',
          postTime: '8 h ago',
          caption: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          image: 'assets/post_image.png',
          likes: 991,
          productLink: 'https://example.com/product',
        ),
        CommunityPost(
          name: 'Kamran Khan',
          profileImage: 'assets/profile_image.png',
          postTime: '8 h ago',
          caption: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          likes: 991,
        ),
        CommunityPost(
          name: 'Kamran Khan',
          profileImage: 'assets/profile_image.png',
          postTime: '8 h ago',
          caption: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          likes: 991,
        ),
        SizedBox(height: 100.0),
      ],
    );
  }
}
