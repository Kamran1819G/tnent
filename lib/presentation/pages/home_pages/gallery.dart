import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:tnent/core/helpers/color_utils.dart';
import 'package:tnent/core/routes/app_routes.dart';
import 'package:tnent/models/store_model.dart';
import 'package:tnent/presentation/pages/gallery_pages/store_registration.dart';
import 'package:tnent/presentation/pages/gallery_pages/the_middlemen_registration.dart';
import 'package:tnent/presentation/pages/store_owner_screens/my_store_profile_screen.dart';
import 'package:tnent/presentation/pages/webview_screen.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool isLoaded = false;
  bool isStoreRegistered = false;
  bool isActive = true;
  late StoreModel store;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await _checkStoreRegistration();
  }

  Future<void> _checkStoreRegistration() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && userDoc.data()!.containsKey('storeId'))
        {
          final storeId = userDoc.get('storeId');
          if (storeId.isNotEmpty)
          {
            final storeDoc = await FirebaseFirestore.instance
                .collection('Stores')
                .doc(storeId)
                .get();
            setState(()
            {
              isStoreRegistered = storeDoc.exists;
              isLoaded = true;
              if (storeDoc.exists)
              {
                store = StoreModel.fromFirestore(storeDoc);
                isActive = store.isActive;
              }
            });
          } else
          {
            setState(()
            {
              isStoreRegistered = false;
              isLoaded = true;
            });
          }
        } else {
          setState(()
          {
            isStoreRegistered = false;
            isLoaded = true;
          });
        }
      } catch (e) {
        print("Error checking store registration: $e");
        setState(() {
          isLoaded = true;
          isStoreRegistered = false;
        });
      }
    } else {
      setState(() {
        isLoaded = true;
        isStoreRegistered = false;
      });
    }
  }

  Future<void> _updateStoreStatus(bool isActive) async
  {
    await FirebaseFirestore.instance
        .collection('Stores')
        .doc(store.storeId)
        .update({'isActive': isActive});
  }

  Widget _buildShimmerSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 90.h,
        width: 90.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: hexToColor('#F1F0EC'),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: 100.h,
              margin: EdgeInsets.only(top: 20.h),
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Gallery'.toUpperCase(),
                        style: TextStyle(
                          color: hexToColor('#1E1E1E'),
                          fontSize: 35.sp,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        ' •',
                        style: TextStyle(
                          fontSize: 35.sp,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.CONTACT);
                    },
                    child: Container(
                      height: 55.h,
                      width: 155.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: hexToColor("#131312"),
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                      child: Text(
                        'Contact Us',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (isStoreRegistered)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(
                        'Store',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyStoreProfileScreen(
                              store: store,
                            ),
                          ),
                        );
                        await _checkStoreRegistration();
                      },
                      child: Container(
                        height: 180.h,
                        width: 604.w,
                        decoration: BoxDecoration(
                          color: hexToColor('#2D332F'),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 135
                                      .h, // Use responsive height if needed (e.g., 135.h)
                                  width: 135
                                      .w, // Use responsive width if needed (e.g., 135.w)
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18
                                        .r), // Use responsive radius if needed (e.g., 18.r)
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18
                                        .r), // Use responsive radius if needed (e.g., 18.r)
                                    child: CachedNetworkImage(
                                      imageUrl: store.logoUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          color: Colors.white,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.475,
                                          child: RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text: store.name,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Gotham Black',
                                                  fontSize: 32.sp,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' •',
                                                style: TextStyle(
                                                  fontFamily: 'Gotham Black',
                                                  fontSize: 32.sp,
                                                  color: hexToColor('#42FF00'),
                                                ),
                                              ),
                                            ]),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/icons/blue_globe.png',
                                          height: 10.0,
                                          width: 10.0,
                                        ),
                                        const SizedBox(width: 5.0),
                                        Text(
                                          '${store.storeDomain}.tnent.com',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.0,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Switch(
                              value: isActive,
                              activeColor: hexToColor('#41FA00'),
                              trackOutlineColor: MaterialStateColor.resolveWith(
                                (states) => Colors.grey,
                              ),
                              trackOutlineWidth:
                                  MaterialStateProperty.resolveWith(
                                (states) => 1.0,
                              ),
                              activeTrackColor: Colors.transparent,
                              inactiveTrackColor: Colors.transparent,
                              onChanged: (value) {
                                setState(() {
                                  isActive = value;
                                });
                                _updateStoreStatus(value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20.0),
            if (!isStoreRegistered && isLoaded) ...[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StoreRegistration()));
                },
                child: Image.asset("assets/digital_store_banner.png"),
              ),
              const SizedBox(height: 20.0),
            ],
            if (!isLoaded) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[500]!,
                  highlightColor: Colors.grey[300]!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 180.h,
                        width: 604.w,
                        decoration: BoxDecoration(
                          color: hexToColor('#2D332F'),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TheMiddlemen()));
                },
                child: Image.asset("assets/the_middleman_banner.png")),
            SizedBox(height: MediaQuery.of(context).size.height * 0.31),
          ],
        ),
      ),
    );
  }
}
