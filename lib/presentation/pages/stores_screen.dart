import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnent/presentation/pages/store_owner_screens/my_store_profile_screen.dart';

import '../../core/helpers/color_utils.dart';
import 'users_screens/storeprofile_screen.dart';
import '../../models/store_model.dart'; // Make sure to import your StoreModel

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  final ScrollController _scrollController = ScrollController();
  List<StoreModel> stores = [];
  bool isLoadingMore = false;
  DocumentSnapshot? lastDocument;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchStores();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchMoreStores();
      }
    });
  }

  Future<void> _fetchStores() async {
    Query query = FirebaseFirestore.instance.collection('Stores').limit(24);

    QuerySnapshot snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        stores =
            snapshot.docs.map((doc) => StoreModel.fromFirestore(doc)).toList();
        lastDocument = snapshot.docs.last;
        hasMore = snapshot.docs.length == 24;
      });
    }
  }

  Future<void> _fetchMoreStores() async {
    if (!isLoadingMore && hasMore) {
      setState(() => isLoadingMore = true);

      Query query = FirebaseFirestore.instance
          .collection('Stores')
          .startAfterDocument(lastDocument!)
          .limit(10);

      QuerySnapshot snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          stores.addAll(snapshot.docs
              .map((doc) => StoreModel.fromFirestore(doc))
              .toList());
          lastDocument = snapshot.docs.last;
          hasMore = snapshot.docs.length == 10;
          isLoadingMore = false;
        });
      } else {
        setState(() => hasMore = false);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Stores'.toUpperCase(),
                        style: TextStyle(
                          color: hexToColor('#1E1E1E'),
                          fontSize: 28.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        ' •',
                        style: TextStyle(
                          fontSize: 28.0,
                          color: hexToColor('#FF0000'),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (stores.isEmpty && !isLoadingMore)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    final store = stores[index];
                    return StoreTile(store: store);
                  },
                ),
              ),
            if (isLoadingMore && stores.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}

class StoreTile extends StatelessWidget {
  final StoreModel store;

  const StoreTile({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreProfileScreen(
              store: store,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(23.r),
                child: Image.network(
                  store.logoUrl,
                  fit: BoxFit.cover,
                  height: 120.h,
                  width: 120.w,
                )),
            SizedBox(height: 12.h),
            Text(
              store.name,
              style: TextStyle(fontSize: 16.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
