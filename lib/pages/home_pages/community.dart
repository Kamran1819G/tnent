import 'package:flutter/material.dart';
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

class CommunityPost extends StatelessWidget {
  final String name;
  final String profileImage;
  final String postTime;
  final String? image;
  final String? caption;
  final String? productLink;
  final int? likes;

  const CommunityPost({
    super.key,
    required this.name,
    required this.profileImage,
    required this.postTime,
    this.image,
    this.caption,
    this.productLink,
    this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User information row
          Row(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(profileImage),
                    radius: 20.0,
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                postTime,
                style: TextStyle(
                  color: hexToColor('#9C9C9C'),
                  fontSize: 10.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          // Caption
          if (caption != null)
            Text(
              caption!,
              style: TextStyle(
                color: hexToColor('#737373'),
                fontSize: 12.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          SizedBox(height: 10),
          // Post image
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                image!,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(height: 10),
          // Likes
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                decoration: BoxDecoration(
                  border: Border.all(color: hexToColor('#BEBEBE')),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '$likes',
                      style: TextStyle(color: hexToColor('#989797'), fontSize: 12.0),
                    ),
                  ],
                ),
              ),
              Spacer(),
              if (productLink != null)
                Chip(
                  backgroundColor: hexToColor('#EDEDED'),
                  side: BorderSide.none,
                  label: Text(
                    '${productLink!}',
                    style: TextStyle(
                      color: hexToColor('#B4B4B4'),
                      fontFamily: 'Gotham',
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  avatar: Icon(Icons.link_outlined, color: hexToColor('#B4B4B4'),),
                ),
              Spacer(),
              Icon(Icons.ios_share_outlined)
            ],
          ),
        ],
      ),
    );
  }
}

