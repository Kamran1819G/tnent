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
              // const Spacer(),
              /*Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationScreen()));
                        setState(() {
                          isNewNotification = false;
                        });
                      },
                      child: isNewNotification
                          ? Image.asset(
                              'assets/icons/new_notification_box.png',
                              height: 35.h,
                              width: 35.w,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/icons/no_new_notification_box.png',
                              height: 35.h,
                              width: 35.w,
                              fit: BoxFit.cover,
                            )),
                  SizedBox(width: 22.w),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyProfileScreen()));
                    },
                    child: widget.currentUser.photoURL != null
                        ? CircleAvatar(
                            radius: 30.0,
                            backgroundImage:
                                NetworkImage(widget.currentUser.photoURL ?? ''),
                          )
                        : CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(Icons.person,
                                color: Colors.white, size: 30.0),
                          ),
                  ),
                ],
              )*/
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
        underWidget("assets/categories2/cata1.png"),
        underWidget("assets/categories2/cata3.png"),
        underWidget("assets/categories2/cata2.png"),
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
