import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tnent/core/routes/app_routes.dart';
import 'package:tnent/models/user_model.dart';
import 'package:tnent/presentation/pages/catalog_pages/purchase_screen.dart';
import 'package:tnent/presentation/pages/catalog_pages/wishlist_screen.dart';
import 'package:tnent/presentation/pages/notification_screen.dart';
import 'package:tnent/presentation/pages/users_screens/myprofile_screen.dart';
import 'package:tnent/presentation/widgets/stylized_custom_button.dart';

import '../../../core/helpers/color_utils.dart';

class Catalog extends StatefulWidget {
  final UserModel currentUser;

  const Catalog({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<Catalog> createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  List<Map<String, dynamic>> content = [
    {
      "title": "Wishlist",
      "icon": "assets/catalog_button_images/wishl.png",
      "background": "assets/catalog_button_images/wishlist.png",
      "textColor": Colors.white,
      "function": () {
        Get.to(() => const WishlistScreen());
      },
    },
    {
      "title": "My Purchases",
      "icon": "assets/catalog_button_images/my_purc.png",
      "background": "assets/catalog_button_images/my_purchases.png",
      "textColor": Colors.white,
      "function": () {
        Get.to(() => const PurchaseScreen());
      },
    },
    {
      "title": "Premium",
      "icon": "assets/catalog_button_images/premi.png",
      "background": "assets/catalog_button_images/premium.png",
      "textColor": Colors.black,
      "function": () {
        Get.toNamed(AppRoutes.COMING_SOON);
      },
    },
    {
      "title": "Coming Soon",
      "icon": "",
      "background": "assets/catalog_button_images/coming_soon.png",
      "textColor": Colors.black,
      "function": () {},
    },
  ];
  bool isNewNotification = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 100.h,
          margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              Row(
                children: [
                  Text(
                    'Catalog'.toUpperCase(),
                    style: TextStyle(
                      color: hexToColor('#1E1E1E'),
                      fontWeight: FontWeight.w400,
                      fontSize: 35.sp,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    ' •',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 35.sp,
                      color: hexToColor('#FAD524'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: List.generate(
            2,
            (index) => StylizedCustomButton(
              icon: content[index]["icon"],
              label: content[index]["title"],
              onPressed: content[index]["function"],
              backgground: content[index]["background"],
              textColor: content[index]["textColor"],
            ),
          ),
        ),
        Row(
          children: List.generate(
            2,
            (index) => StylizedCustomButton(
              icon: content[index + 2]["icon"],
              label: content[index + 2]["title"],
              onPressed: content[index + 2]["function"],
              backgground: content[index + 2]["background"],
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
       const FirestoreUnderWidget(),
      ],
    );
  }

  Widget underWidget(String asset) => Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 13),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AspectRatio(aspectRatio: 16 / 9, child: Image.asset(asset)),
        ),
      );
}
class FirestoreUnderWidget extends StatelessWidget {
  const FirestoreUnderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Banners')
          .doc('banner-catalog')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('No banner data available'));
        }
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final List<String> images = List<String>.from(data['images'] ?? []);
        if (images.isEmpty) {
          return const Center(child: Text('No images available'));
        }
        return Column(
          children: images.map((imageUrl) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 13),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.error)),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}