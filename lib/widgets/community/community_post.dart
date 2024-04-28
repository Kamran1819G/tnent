import 'package:flutter/material.dart';

import '../../helpers/color_utils.dart';

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
                    radius: 25.0,
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22.0,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                postTime,
                style: TextStyle(
                  color: hexToColor('#9C9C9C'),
                  fontSize: 12.0,
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
                fontSize: 14.0,
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
                      style: TextStyle(color: hexToColor('#989797')),
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
