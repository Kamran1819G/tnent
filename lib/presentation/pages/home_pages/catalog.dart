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

import '../../../core/helpers/color_utils.dart';

class Catalog extends StatefulWidget {
  final UserModel currentUser;

  const Catalog({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<Catalog> createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
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
              Spacer(),
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
        Container(
          height: 400.h,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                spreadRadius: 5,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
        SizedBox(height: 30.h),
        Container(
          height: 600.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 20.w,
            mainAxisSpacing: 20.h,
            physics: NeverScrollableScrollPhysics(),
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WishlistScreen()),
                  );
                },
                child: Container(
                  height: 265.h,
                  width: 290.w,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: hexToColor('#FFFCE4'),
                    image: DecorationImage(
                      image: AssetImage('assets/catalog_container_graphic.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Container(
                    width: 200.w,
                    padding: EdgeInsets.only(left: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Wishlist',
                          style: TextStyle(
                            color: hexToColor('#1E1E1E'),
                            fontWeight: FontWeight.w400,
                            fontSize: 30.sp,
                          ),
                        ),
                        Text(
                          'See all your saved products here',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: hexToColor('#585858'),
                          ),
                        ),
                        SizedBox(height: 50.h),
                        Row(
                          children: [
                            Spacer(),
                            Image.asset('assets/icons/wishlist.png',
                                height: 55.h, width: 55.w, fit: BoxFit.cover),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PurchaseScreen()),
                  );
                },
                child: Container(
                  height: 265.h,
                  width: 290.w,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: hexToColor('#FFDFDF'),
                    image: DecorationImage(
                      image: AssetImage('assets/catalog_container_graphic.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Container(
                    width: 200.w,
                    padding: EdgeInsets.only(left: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'My Purchases',
                          style: TextStyle(
                            color: hexToColor('#1E1E1E'),
                            fontWeight: FontWeight.w400,
                            fontSize: 30.sp,
                          ),
                        ),
                        Text(
                          'See all your currently purchased items',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: hexToColor('#585858'),
                          ),
                        ),
                        SizedBox(height: 50.h),
                        Row(
                          children: [
                            Spacer(),
                            Image.asset('assets/icons/my_purchases.png',
                                height: 55.h, width: 55.w, fit: BoxFit.cover),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.COMING_SOON);
                },
                child: Container(
                  height: 265.h,
                  width: 290.w,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: hexToColor('#EAE6F6'),
                    image: DecorationImage(
                      image: AssetImage('assets/catalog_container_graphic.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Container(
                    width: 200.w,
                    padding: EdgeInsets.only(left: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Premium',
                          style: TextStyle(
                            color: hexToColor('#1E1E1E'),
                            fontWeight: FontWeight.w400,
                            fontSize: 30.sp,
                          ),
                        ),
                        Text(
                          'Unlock features with our premium services',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: hexToColor('#585858'),
                          ),
                        ),
                        SizedBox(height: 50.h),
                        Row(
                          children: [
                            Spacer(),
                            Image.asset('assets/icons/premium.png',
                                height: 55.h, width: 55.w, fit: BoxFit.cover),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 265.h,
                width: 290.w,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: hexToColor('#E2FDD9'),
                  image: DecorationImage(
                    image: AssetImage('assets/catalog_container_graphic.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Container(
                  width: 200.w,
                  padding: EdgeInsets.only(left: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Coming Soon...',
                        style: TextStyle(
                          color: hexToColor('#1E1E1E'),
                          fontWeight: FontWeight.w400,
                          fontSize: 30.sp,
                        ),
                      ),
                      Text(
                        'Let Team Tnent. Cook ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: hexToColor('#585858'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 100.0),
      ],
    );
  }
}
