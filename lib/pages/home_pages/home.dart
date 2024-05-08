import 'package:flutter/material.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/screens/explore_screen.dart';
import 'package:tnennt/screens/notification_screen.dart';
import 'package:tnennt/screens/stores_screen.dart';
import 'package:tnennt/widgets/ProductTile.dart';
import 'package:tnennt/widgets/StoresUpdateTile.dart';
import 'package:tnennt/screens/users_screens/myprofile_screen.dart';
import 'package:tnennt/widgets/CategoryTile.dart';
import 'package:tnennt/widgets/StoreTile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 5,
        initialIndex: 0,
        vsync: this); // Change the length to match your number of tabs.
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                    Text('Wednesday, 17 November'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w900,
                            fontSize: 12.0)),
                    SizedBox(height: 4.0),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Kamran Khan',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 28.0,
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
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile_image.png'),
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
                        fontWeight: FontWeight.w900,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      'clothings, electronics, groceries & more...',
                      style: TextStyle(
                        color: hexToColor('#989898'),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Updates',
            style: TextStyle(
              color: hexToColor('#343434'),
              fontWeight: FontWeight.w900,
              fontSize: 18.0,
            ),
          ),
        ),
        SizedBox(
          height: 150.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return StoreUpdateTile(
                  name: "Sahachari", image: "assets/sahachari_image.png");
            },
          ),
        ),
        SizedBox(height: 40.0),
        // Featured Section
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          unselectedLabelColor: hexToColor('#737373'),
          labelColor: Colors.white,
          indicator: BoxDecoration(
            color: hexToColor('#343434'),
            borderRadius: BorderRadius.circular(50),
          ),
          labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
          labelStyle: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w900,
          ),
          indicatorSize: TabBarIndicatorSize.label,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          dividerColor: Colors.transparent,
          tabs: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: hexToColor('#343434'), width: 1.0),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Text(
                "Electronics",
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: hexToColor('#343434'), width: 1.0),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Text(
                "Clothings",
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: hexToColor('#343434'), width: 1.0),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Text(
                "Groceries",
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: hexToColor('#343434'), width: 1.0),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Text(
                "Accessories",
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: hexToColor('#343434'), width: 1.0),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Text(
                "Books",
              ),
            )
          ],
        ),

        SizedBox(height: 40.0),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Featured',
            style: TextStyle(
              color: hexToColor('#343434'),
              fontWeight: FontWeight.w900,
              fontSize: 24.0,
            ),
          ),
        ),

        SizedBox(height: 20.0),

        Container(
          height: 200.0,
          padding: EdgeInsets.only(left: 16.0),
          child: TabBarView(controller: _tabController, children: [
            ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (context, index) {
                  return SizedBox(width: 15.0);
                },
                itemBuilder: (context, index) {
                  return ProductTile(
                      name: "Cannon XYZ",
                      image: "assets/product_image.png",
                      price: 200);
                }),
            ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (context, index) {
                  return SizedBox(width: 15.0);
                },
                itemBuilder: (context, index) {
                  return ProductTile(
                      name: "Sahachari",
                      image: "assets/sahachari_image.png",
                      price: 200);
                }),
            ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (context, index) {
                  return SizedBox(width: 15.0);
                },
                itemBuilder: (context, index) {
                  return ProductTile(
                      name: "Sahachari",
                      image: "assets/sahachari_image.png",
                      price: 200);
                }),
            ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (context, index) {
                  return SizedBox(width: 15.0);
                },
                itemBuilder: (context, index) {
                  return ProductTile(
                      name: "Sahachari",
                      image: "assets/sahachari_image.png",
                      price: 200);
                }),
            ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (context, index) {
                  return SizedBox(width: 15.0);
                },
                itemBuilder: (context, index) {
                  return ProductTile(
                      name: "Sahachari",
                      image: "assets/sahachari_image.png",
                      price: 200);
                }),
          ]),
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
                  fontWeight: FontWeight.w900,
                  fontSize: 22.0,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StoresScreen()));
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: hexToColor('#F5F5F5'),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: hexToColor('#272822'),
                      fontWeight: FontWeight.w900,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
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
              fontWeight: FontWeight.w900,
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
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
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
