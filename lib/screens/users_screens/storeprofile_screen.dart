import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnennt/models/store_category_model.dart';
import 'package:tnennt/models/product_model.dart';
import 'package:tnennt/models/store_model.dart';
import 'package:tnennt/screens/store_community.dart';
import 'package:tnennt/widgets/wishlist_product_tile.dart';
import '../../helpers/color_utils.dart';
import '../update_screen.dart';

class StoreProfileScreen extends StatefulWidget {
  final StoreModel store;

  const StoreProfileScreen({super.key, required this.store});

  @override
  State<StoreProfileScreen> createState() => _StoreProfileScreenState();
}

class _StoreProfileScreenState extends State<StoreProfileScreen>
    with SingleTickerProviderStateMixin {
  bool isConnected = false;
  int storeEngagement = 0;
  bool isExpanded = false;
  bool isGreenFlag = true;
  String userVote = 'none'; // 'none', 'green', or 'red'
  late int greenFlags;
  late int redFlags;


  late AnimationController _controller;
  late Animation<double> _animation;

  String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<StoreCategoryModel>> fetchCategories() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Stores')
        .doc(widget.store.storeId)
        .collection('categories')
        .get();

    return querySnapshot.docs
        .map((doc) => StoreCategoryModel.fromFirestore(doc))
        .toList();
  }


  @override
  void initState() {
    super.initState();
    greenFlags = widget.store.greenFlags;
    redFlags = widget.store.redFlags;
    checkConnectionStatus();
    checkUserVote();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    listenToFlagChanges();
  }

  Future<void> checkUserVote() async {
      DocumentSnapshot voteDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('storeVotes')
          .doc(widget.store.storeId)
          .get();

      if (voteDoc.exists) {
        Map<String, dynamic> data = voteDoc.data() as Map<String, dynamic>;
        setState(() {
          userVote = data['greenFlag'] ? 'green' : 'red';
        });
      }
  }

  void listenToFlagChanges() {
    FirebaseFirestore.instance
        .collection('Stores')
        .doc(widget.store.storeId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          greenFlags = snapshot.data()?['greenFlags'] ?? 0;
          redFlags = snapshot.data()?['redFlags'] ?? 0;
        });
      }
    });
  }

  Future<void> handleVote(String voteType) async {

    await handleStoreVote(userId, widget.store.storeId, voteType);

    setState(() {
      if (userVote == voteType) {
        userVote = 'none';
      } else {
        userVote = voteType;
      }
      _controller.reverse();
      isExpanded = false;
    });
  }

  Future<void> handleStoreVote(String userId, String storeId, String voteType) async {
    final userVoteRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("storeVotes")
        .doc(storeId);
    final storeRef = FirebaseFirestore.instance.collection("Stores").doc(storeId);

    try {
      return await FirebaseFirestore.instance.runTransaction((transaction) async {
        final voteDoc = await transaction.get(userVoteRef);
        final storeDoc = await transaction.get(storeRef);

        if (!storeDoc.exists) {
          throw Exception('Store does not exist');
        }

        if (voteDoc.exists) {
          final previousVote = voteDoc.data() as Map<String, dynamic>;
          // If the previous vote is the same as the new vote, remove the vote
          if (previousVote['greenFlag'] == true && voteType == 'greenFlag') {
            transaction.update(storeRef, {'greenFlags': FieldValue.increment(-1)});
            transaction.delete(userVoteRef);
            return;
          } else if (previousVote['redFlag'] == true && voteType == 'redFlag') {
            transaction.update(storeRef, {'redFlags': FieldValue.increment(-1)});
            transaction.delete(userVoteRef);
            return;
          }
          // If changing the vote type, decrement the old vote
          if (previousVote['greenFlag'] == true && voteType != 'greenFlag') {
            transaction.update(storeRef, {'greenFlags': FieldValue.increment(-1)});
          } else if (previousVote['redFlag'] == true && voteType != 'redFlag') {
            transaction.update(storeRef, {'redFlags': FieldValue.increment(-1)});
          }
        }

        // Add the new vote
        if (voteType == 'greenFlag') {
          transaction.update(storeRef, {'greenFlags': FieldValue.increment(1)});
        } else if (voteType == 'redFlag') {
          transaction.update(storeRef, {'redFlags': FieldValue.increment(1)});
        }

        transaction.set(userVoteRef, {
          'greenFlag': voteType == 'greenFlag',
          'redFlag': voteType == 'redFlag'
        }, SetOptions(merge: true));
      });
    } catch (error) {
      print('Error recording vote: $error');
      rethrow;
    }
  }

  Future<void> checkConnectionStatus() async {
    setState(() {
      storeEngagement = widget.store.storeEngagement;
      isConnected = widget.store.followerIds.contains(userId);
    });
  }

  Future<void> toggleConnection() async {
    DocumentReference storeRef = FirebaseFirestore.instance
        .collection('Stores')
        .doc(widget.store.storeId);

    // Fetch the store document to check current state
    DocumentSnapshot storeDoc = await storeRef.get();
    List<dynamic> followerIds = storeDoc.get('followerIds') ?? [];
    bool isCurrentlyConnected = followerIds.contains(userId);

    // Update follower IDs and engagement count based on current state
    if (!isCurrentlyConnected) {
      // Connect to store
      await storeRef.update({
        'followerIds': FieldValue.arrayUnion([userId]),
        'storeEngagement': FieldValue.increment(1),
      });

      setState(() {
        isConnected = true;
        storeEngagement++;
      });
    } else {
      // Disconnect from store
      await storeRef.update({
        'followerIds': FieldValue.arrayRemove([userId]),
        'storeEngagement': FieldValue.increment(-1),
      });

      setState(() {
        isConnected = false;
        storeEngagement--;
      });
    }
  }

  void _toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              // Profile Card
              Container(
                height: 290.h,
                width: 618.w,
                margin: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: hexToColor('#2D332F'),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 16.0,
                      top: 16.0,
                      child: CircleAvatar(
                        backgroundColor: hexToColor('#F5F5F5'),
                        radius: 20,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                            size: 18,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-0.9, -0.5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                widget.store.logoUrl,
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                height: 30.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border:
                                      Border.all(color: hexToColor('#DEFF98')),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Text(
                                  widget.store.category,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              SizedBox(
                                width: 400.w,
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: widget.store.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Gotham Black',
                                        fontSize: 36.sp,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '•',
                                      style: TextStyle(
                                        fontFamily: 'Gotham Black',
                                        fontSize: 36.sp,
                                        color: hexToColor('#42FF00'),
                                      ),
                                    ),
                                  ]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/blue_globe.png',
                                    height: 16.w,
                                    width: 16.w,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    widget.store.website,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontSize: 16.sp),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment(0.9, 0.9),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.ios_share, color: Colors.white, size: 25.sp),
                          SizedBox(width: 10.0),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: hexToColorWithOpacity('#C0C0C0', 0.2),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text(
                              widget.store.location,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 17.sp),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 6.0),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 0.5),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '0',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                                Text(
                                  'Customers',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 8.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),

              Container(
                height: 225.h,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 180.h,
                      width: 390.w,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: hexToColor('#DDF1EF'),
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Store'.toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 21.sp,
                                          ),
                                        ),
                                        Text(
                                          ' •',
                                          style: TextStyle(
                                            fontSize: 21.sp,
                                            fontFamily: 'Gotham Black',
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Engagement'.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 21.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (!isExpanded)
                                      Text(
                                        ' ${userVote == 'red' ? redFlags : greenFlags} / ${greenFlags + redFlags}',
                                        style: TextStyle(
                                          color: hexToColor('#676767'),
                                          fontFamily: 'Gotham',
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    SizedBox(width: 8.w),
                                    buildFlagButton(),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                // connect button with left + button and connect text at right
                                GestureDetector(
                                  onTap: toggleConnection,
                                  child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 300),
                                    // Adjust the duration as needed
                                    child: Container(
                                      key: ValueKey<bool>(isConnected),
                                      // Key helps AnimatedSwitcher identify the widget
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(50.r),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 300),
                                            padding: EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(
                                              color: isConnected
                                                  ? hexToColor('#D4EDDA')
                                                  : hexToColor('#F3F3F3'),
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                            child: Icon(
                                              isConnected
                                                  ? Icons.check
                                                  : Icons.add,
                                              color: hexToColor('#272822'),
                                              size: 18.sp,
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          AnimatedSwitcher(
                                            duration:
                                                Duration(milliseconds: 300),
                                            child: Text(
                                              isConnected
                                                  ? 'Connected'.toUpperCase()
                                                  : 'Connect'.toUpperCase(),
                                              key: ValueKey<bool>(isConnected),
                                              style: TextStyle(
                                                color: hexToColor("#272822"),
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      storeEngagement.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24.sp,
                                      ),
                                    ),
                                    Text(
                                      'Connections'.toUpperCase(),
                                      style: TextStyle(
                                        color: hexToColor('#7D7D7D'),
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ]),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoreCommunity(
                              store: widget.store,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 180.h,
                        width: 180.w,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: hexToColor('#EFEFEF'),
                          borderRadius: BorderRadius.circular(22.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Store'.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Gotham Black',
                                      fontSize: 21.sp,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' •',
                                    style: TextStyle(
                                      fontSize: 21.sp,
                                      fontFamily: 'Gotham Black',
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Community'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 21.sp,
                              ),
                            ),
                            Text(
                              'Post'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 21.sp,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.store.totalPosts.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24.sp,
                                      ),
                                    ),
                                    Text(
                                      'Posts'.toUpperCase(),
                                      style: TextStyle(
                                        color: hexToColor('#7D7D7D'),
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                // right arrow box
                                Container(
                                  margin: EdgeInsets.only(left: 10.0),
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[700],
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Updates Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'Highlights',
                      style: TextStyle(
                        color: hexToColor('#343434'),
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Container(
                    height: 150.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return UpdateTile(
                            name: "Sahachari",
                            image: "assets/sahachari_image.png");
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Featured Products Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Featured Products',
                          style: TextStyle(
                            color: hexToColor('#343434'),
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      FeatureProductsListView(
                          featuredProductIds: widget.store.featuredProductIds),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  FutureBuilder<List<StoreCategoryModel>>(
                    future: fetchCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<StoreCategoryModel> categories = snapshot.data!;
                        return Column(
                          children: categories
                              .map((category) =>
                                  CategoryProductsListView(category: category))
                              .toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFlagButton() {
    String flagImage;
    if (userVote == 'green') {
      flagImage = 'assets/green-flag.png';
    } else if (userVote == 'red') {
      flagImage = 'assets/red-flag.png';
    } else {
      flagImage = 'assets/grey-flag.png';
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return GestureDetector(
          onTap: _toggleExpansion,
          child: isExpanded
              ? Container(
            width: isExpanded ? (_animation.value * 60 + 40) : 40,
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => handleVote('greenFlag'),
                  child: Image.asset('assets/green-flag.png',
                      height: 18.0, width: 18.0),
                ),
                if (isExpanded) SizedBox(width: _animation.value * 25),
                if (isExpanded)
                  GestureDetector(
                    onTap: () => handleVote('redFlag'),
                    child: Image.asset('assets/red-flag.png',
                        height: 18.0, width: 18.0),
                  ),
              ],
            ),
          )
              : Container(
            width: 40,
            height: 35.0,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Image.asset(flagImage, height: 18.0, width: 18.0),
          ),
        );
      },
    );
  }

}

class FeatureProductsListView extends StatefulWidget {
  final List<String> featuredProductIds;

  const FeatureProductsListView({Key? key, required this.featuredProductIds})
      : super(key: key);

  @override
  State<FeatureProductsListView> createState() =>
      _FeatureProductsListViewState();
}

class _FeatureProductsListViewState extends State<FeatureProductsListView> {
  Future<List<ProductModel>> fetchProducts() async {
    if (widget.featuredProductIds.isEmpty) {
      return [];
    }
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where(FieldPath.documentId, whereIn: widget.featuredProductIds)
        .get();

    print('Fetched ${querySnapshot.docs.length} products');
    return querySnapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: FutureBuilder<List<ProductModel>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<ProductModel> featuredProducts = snapshot.data!;
            if (featuredProducts.isEmpty) {
              return Center(
                child: Text(
                  'No Products in Featured',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: featuredProducts.length,
              itemBuilder: (context, index) {
                return WishlistProductTile(product: featuredProducts[index]);
              },
            );
          }
        },
      ),
    );
  }
}

class CategoryProductsListView extends StatefulWidget {
  final StoreCategoryModel category;

  const CategoryProductsListView({Key? key, required this.category})
      : super(key: key);

  @override
  State<CategoryProductsListView> createState() =>
      _CategoryProductsListViewState();
}

class _CategoryProductsListViewState extends State<CategoryProductsListView> {
  Future<List<ProductModel>> fetchProducts() async {
    if (widget.category.productIds.isEmpty) {
      return [];
    }
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where(FieldPath.documentId, whereIn: widget.category.productIds)
        .get();

    print('Fetched ${querySnapshot.docs.length} products');
    return querySnapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            widget.category.name,
            style: TextStyle(
              color: hexToColor('#343434'),
              fontSize: 18.0,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          height: 200.0,
          child: FutureBuilder<List<ProductModel>>(
            future: fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<ProductModel> products = snapshot.data!;
                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      'No Products in ${widget.category.name}',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return WishlistProductTile(product: products[index]);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class UpdateTile extends StatelessWidget {
  final String name;
  final String image;

  UpdateTile({
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateScreen(
              storeName: name,
              storeImage: Image.asset(image),
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: hexToColor('#B5B5B5')),
                borderRadius: BorderRadius.circular(18.0),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              name,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 10.0),
            ),
          ],
        ),
      ),
    );
  }
}
