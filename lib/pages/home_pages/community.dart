import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../helpers/color_utils.dart';

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
                              builder: (context) => CreateCommunityPost()));
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
          caption:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          image: 'assets/post_image.png',
          likes: 991,
          productLink: 'https://example.com/product',
        ),
        CommunityPost(
          name: 'Kamran Khan',
          profileImage: 'assets/profile_image.png',
          postTime: '8 h ago',
          caption:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          likes: 991,
        ),
        CommunityPost(
          name: 'Kamran Khan',
          profileImage: 'assets/profile_image.png',
          postTime: '8 h ago',
          caption:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        postTime,
                        style: TextStyle(
                          color: hexToColor('#9C9C9C'),
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    context: context,
                    builder: (context) => _buildMoreBottomSheet(),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: hexToColor('#F5F5F5'),
                  child: Icon(
                    Icons.more_horiz,
                    color: hexToColor('#BEBEBE'),
                    size: 20,
                  ),
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
                      style: TextStyle(
                          color: hexToColor('#989797'), fontSize: 12.0),
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
                  avatar: Icon(
                    Icons.link_outlined,
                    color: hexToColor('#B4B4B4'),
                  ),
                ),
              Spacer(),
              Icon(Icons.ios_share_outlined)
            ],
          ),
        ],
      ),
    );
  }
  _buildMoreBottomSheet(){
    return Container(
      height: 250,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: hexToColor('#CACACA'),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(height: 50),
          CircleAvatar(
            backgroundColor: hexToColor('#2B2B2B'),
            child: Icon(
              Icons.report_gmailerrorred,
              color: hexToColor('#BEBEBE'),
              size: 20,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Report',
            style: TextStyle(
              color: hexToColor('#9B9B9B'),
              fontWeight: FontWeight.w900,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}

class CreateCommunityPost extends StatefulWidget {
  const CreateCommunityPost({super.key});

  @override
  State<CreateCommunityPost> createState() => _CreateCommunityPostState();
}

class _CreateCommunityPostState extends State<CreateCommunityPost> {
  File? _image;
  List<File> _images = [];

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _images.add(_image!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Community Post'.toUpperCase(),
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
                        icon: Icon(Icons.arrow_back_ios_rounded,
                            color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            // Add Image
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Image',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Add the function to be executed when the button is pressed
                          if (_images.length < 3) {
                            pickImage();
                          }
                        },
                        child: Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                            border: Border.all(color: hexToColor('#848484')),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 40,
                              color: hexToColor('#545454'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      if (_images.isNotEmpty)
                        Expanded(
                          child: SizedBox(
                            height: 75,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  _images.length > 3 ? 3 : _images.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Container(
                                      width: 75,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: hexToColor('#848484')),
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: FileImage(_images[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _images.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      if (_images.isEmpty)
                        Text(
                          '(you can add up to 3 images)',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: hexToColor('#636363'),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            // Caption
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Caption',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    textAlign: TextAlign.start,
                    maxLines: 5,
                    maxLength: 700,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Description',
                      labelStyle: TextStyle(
                        color: hexToColor('#545454'),
                        fontWeight: FontWeight.w900,
                        fontSize: 16.0,
                      ),
                      hintText: 'Write a caption...',
                      hintStyle: TextStyle(
                        color: hexToColor('#989898'),
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: hexToColor('#848484'),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Product Link
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Link',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.add_link,
                        color: hexToColor('#848484'),
                      ),
                      hintText: 'Paste the product link...',
                      hintStyle: TextStyle(
                        color: hexToColor('#989898'),
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: hexToColor('#848484'),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 100),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add the function to be executed when the button is pressed
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
                        30), // Set the button corner radius
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Post', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
