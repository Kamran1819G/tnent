import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/models/user_model.dart';
import 'package:tnennt/screens/explore_screen.dart';
import 'package:tnennt/screens/notification_screen.dart';
import 'package:tnennt/screens/stores_screen.dart';
import 'package:tnennt/screens/users_screens/myprofile_screen.dart';
import 'package:tnennt/widgets/product_tile.dart';

import '../../screens/story_screen.dart';
import '../../screens/store_owner_screens/storeprofile_screen.dart';

class Home extends StatefulWidget {
  final UserModel? currentUser;

  Home({required this.currentUser});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 6,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getTabLabel(int index) {
    switch (index) {
      case 0:
        return 'Electronics';
      case 1:
        return 'Clothings';
      case 2:
        return 'Accessories';
      case 3:
        return 'Groceries';
      case 4:
        return 'Books';
      case 5:
        return 'More';
      default:
        return '';
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning ⛅';
    } else if (hour < 18) {
      return 'Good Afternoon ';
    } else {
      return 'Good Evening 🌕';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 100,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getGreeting().toUpperCase(),
                        style: TextStyle(
                            color: hexToColor('#727272'), fontSize: 12.0)),
                    SizedBox(height: 4.0),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: (widget.currentUser!.firstName.isNotEmpty)
                                ? 'Hello, ${widget.currentUser!.firstName} ${widget.currentUser!.lastName}'
                                : 'Hello, User',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Gotham Black',
                              fontSize: 24.0,
                            ),
                          ),
                          TextSpan(
                            text: ' •',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 30.0,
                              color: hexToColor('#42FF00'),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 10.0),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationScreen()));
                  },
                  child: Image.asset(
                    'assets/icons/notification_box.png',
                    height: 24,
                    width: 24,
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.overlay,
                  )),
              SizedBox(width: 16.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyProfileScreen()));
                },
                child: widget.currentUser != null &&
                        widget.currentUser!.photoURL.isNotEmpty
                    ? CircleAvatar(
                        radius: 30.0,
                        backgroundImage:
                            NetworkImage(widget.currentUser!.photoURL),
                      )
                    : CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Theme.of(context).primaryColor,
                        child:
                            Icon(Icons.person, color: Colors.white, size: 30.0),
                      ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ExploreScreen()));
          },
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                width: 1,
                color: hexToColor('#DDDDDD'),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundColor: hexToColor('#EEEEEE'),
                  child: CircleAvatar(
                    radius: 15.0,
                    backgroundColor: hexToColor('#DDDDDD'),
                    child: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Products & Store',
                      style: TextStyle(
                        color: hexToColor('#6D6D6D'),
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      'clothings, electronics, groceries & more...',
                      style: TextStyle(
                        color: hexToColor('#989898'),
                        fontFamily: 'Gotham',
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Image.asset('assets/store_profile_banner.png'),
        ),
        SizedBox(height: 20.0),
        // Updates Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Updates',
            style: TextStyle(
              color: hexToColor('#343434'),
              fontSize: 18.0,
            ),
          ),
        ),
        Container(
          height: 150.0,
          padding: EdgeInsets.only(left: 8.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return UpdateTile(
                  name: "Sahachari", image: "assets/sahachari_image.png");
            },
          ),
        ),
        SizedBox(height: 20.0),
        // Featured Section
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Wrap(
            children: List.generate(6, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: ChoiceChip(
                  label: Text(_getTabLabel(index)),
                  labelStyle: TextStyle(
                    fontSize: 12.0,
                    color: _selectedIndex == index
                        ? Colors.white
                        : hexToColor("#343434"),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    side: BorderSide(
                      color: hexToColor('#343434'),
                    ),
                  ),
                  showCheckmark: false,
                  selected: _selectedIndex == index,
                  selectedColor: hexToColor('#343434'),
                  backgroundColor: Colors.white,
                  onSelected: (selected) {
                    setState(() {
                      _selectedIndex = index;
                      _tabController.index = index;
                    });
                  },
                ),
              );
            }),
          ),
        ),

        SizedBox(height: 40.0),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Featured',
            style: TextStyle(
              color: hexToColor('#343434'),
              fontSize: 22.0,
            ),
          ),
        ),

        SizedBox(height: 20.0),

        Container(
          height: 200.0,
          padding: EdgeInsets.only(left: 8.0),
          child: TabBarView(
            controller: _tabController,
            children: [
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ProductTile(
                      name: "Cannon XYZ",
                      image: "assets/product_image.png",
                      price: 200);
                },
              ),
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ProductTile(
                      name: "Cannon XYZ",
                      image: "assets/product_image.png",
                      price: 200);
                },
              ),
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ProductTile(
                      name: "Cannon XYZ",
                      image: "assets/product_image.png",
                      price: 200);
                },
              ),
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ProductTile(
                      name: "Cannon XYZ",
                      image: "assets/product_image.png",
                      price: 200);
                },
              ),
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ProductTile(
                      name: "Cannon XYZ",
                      image: "assets/product_image.png",
                      price: 200);
                },
              ),
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ProductTile(
                      name: "Cannon XYZ",
                      image: "assets/product_image.png",
                      price: 200);
                },
              ),
            ],
          ),
        ),

        SizedBox(height: 40.0),

        // Feature Store Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                'Featured Stores',
                style: TextStyle(
                  color: hexToColor('#343434'),
                  fontSize: 22.0,
                ),
              ),
              Spacer(),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => StoresScreen()));
              //   },
              //   child: Container(
              //     padding:
              //         EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              //     decoration: BoxDecoration(
              //       color: hexToColor('#F5F5F5'),
              //       borderRadius: BorderRadius.circular(50.0),
              //     ),
              //     child: Text(
              //       'View All',
              //       style: TextStyle(
              //         color: hexToColor('#272822'),
              //
              //         fontSize: 12.0,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),

        SizedBox(height: 30.0),

        Container(
          height: 125.0,
          padding: EdgeInsets.only(left: 16.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              StoreTile(
                storeName: 'Sanachari',
                storeLogo: 'assets/sahachari_image.png',
              ),
              SizedBox(width: 15.0),
              StoreTile(
                storeName: 'Jain Brothers',
                storeLogo: 'assets/jain_brothers.png',
              ),
              SizedBox(width: 15.0),
              StoreTile(
                storeName: 'Sanachari',
                storeLogo: 'assets/sahachari_image.png',
              ),
              SizedBox(width: 15.0),
              StoreTile(
                storeName: 'Jain Brothers',
                storeLogo: 'assets/jain_brothers.png',
              ),
              SizedBox(width: 15.0),
              StoreTile(
                storeName: 'Sanachari',
                storeLogo: 'assets/sahachari_image.png',
              ),
              SizedBox(width: 15.0),
              StoreTile(
                storeName: 'Jain Brothers',
                storeLogo: 'assets/jain_brothers.png',
              ),
            ],
          ),
        ),

        SizedBox(height: 20.0),

        // Category Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Category',
            style: TextStyle(
              color: hexToColor('#343434'),
              fontSize: 22.0,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 1.05,
          child: GridView.count(
            padding: EdgeInsets.all(16.0),
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 30.0,
            childAspectRatio: 0.75,
            children: [
              CategoryTile(
                name: 'Clothings',
                image: 'assets/product_image.png',
              ),
              CategoryTile(
                name: 'Electronics',
                image: 'assets/product_image.png',
              ),
              CategoryTile(
                name: 'groceries',
                image: 'assets/product_image.png',
              ),
              CategoryTile(
                name: 'Accessories',
                image: 'assets/product_image.png',
              ),
              CategoryTile(name: 'Sports', image: 'assets/product_image.png'),
              CategoryTile(name: 'Books', image: 'assets/product_image.png'),
            ],
          ),
        ),
      ],
    );
  }
}

class StoreTile extends StatelessWidget {
  final String storeName;
  final String storeLogo;

  StoreTile({
    required this.storeName,
    required this.storeLogo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreProfileScreen(
              storeName: storeName,
              storeLogo: storeLogo,
            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 75,
            width: 75,
            decoration: BoxDecoration(
              border: Border.all(color: hexToColor('#B5B5B5')),
              borderRadius: BorderRadius.circular(18.0),
              image: DecorationImage(
                image: AssetImage(storeLogo),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: Text(
              storeName,
              style: TextStyle(fontSize: 10.0),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String name;
  final String image;

  CategoryTile({
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: hexToColor('#F5F5F5'),
      ),
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 6.0),
          Text(
            name,
            style: TextStyle(
              color: hexToColor('#343434'),
              fontSize: 14.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
            builder: (context) => StoryScreen(
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
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                name,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 10.0),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
