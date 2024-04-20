import 'package:flutter/material.dart';
import 'package:tnennt/screens/setting_screen.dart';
import 'package:tnennt/screens/update_screen.dart';
import 'package:tnennt/widgets/FeaturedTile.dart';
import 'package:tnennt/widgets/UpdateTile.dart';

import '../../widgets/CategoryTile.dart';

class StoreProfile extends StatefulWidget {
  const StoreProfile({super.key});

  @override
  State<StoreProfile> createState() => _StoreProfileState();
}

class _StoreProfileState extends State<StoreProfile>
    with TickerProviderStateMixin {
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
                    Text('Wednesday, 17 November',
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w900,
                            fontSize: 16.0)),
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
                              fontSize: 28.0,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 16.0),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateScreen()));
                  },
                  child: Icon(Icons.notifications_rounded)),
              SizedBox(width: 16.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingScreen()));
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile_image.png'),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              width: 2,
              color: Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[100],
                child: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Products & Store',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Image.asset('assets/store_profile_banner.png'),
        ),
        SizedBox(height: 20.0),
        // Updates Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: RichText(
            text: TextSpan(
              text: 'Updates',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 175.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return UpdateTile(
                    name: "Sahachari", image: "assets/updates_image.png");
              }),
        ),

        // Featured Section
        TabBar(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          unselectedLabelColor: Colors.black,
          labelColor: Colors.black,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          splashBorderRadius: BorderRadius.circular(20),
          indicatorSize: TabBarIndicatorSize.values[0],
          dividerColor: Colors.transparent,
          tabs: <Widget>[
            Tab(
              text: "Electronics",
            ),
            Tab(
              text: "Clothings",
            ),
            Tab(
              text: "Groceries",
            ),
            Tab(
              text: "Accessories",
            ),
            Tab(
              text: "Books",
            )
          ],
        ),

        SizedBox(height: 20.0),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: RichText(
            text: TextSpan(
              text: 'Featured',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 24.0,
              ),
            ),
          ),
        ),

        SizedBox(height: 20.0),

        Container(
          height: 200.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: TabBarView(controller: _tabController, children: [
            ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (context, index) {
                  return SizedBox(width: 15.0);
                },
                itemBuilder: (context, index) {
                  return FeaturedTile(
                      name: "Sahachari",
                      image: "assets/updates_image.png",
                      price: 200);
                }),
            ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (context, index) {
                  return SizedBox(width: 15.0);
                },
                itemBuilder: (context, index) {
                  return FeaturedTile(
                      name: "Sahachari",
                      image: "assets/updates_image.png",
                      price: 200);
                }),
            ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (context, index) {
                  return SizedBox(width: 15.0);
                },
                itemBuilder: (context, index) {
                  return FeaturedTile(
                      name: "Sahachari",
                      image: "assets/updates_image.png",
                      price: 200);
                }),
            ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (context, index) {
                  return SizedBox(width: 15.0);
                },
                itemBuilder: (context, index) {
                  return FeaturedTile(
                      name: "Sahachari",
                      image: "assets/updates_image.png",
                      price: 200);
                }),
            ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (context, index) {
                  return SizedBox(width: 15.0);
                },
                itemBuilder: (context, index) {
                  return FeaturedTile(
                      name: "Sahachari",
                      image: "assets/updates_image.png",
                      price: 200);
                }),
          ]),
        ),

        SizedBox(height: 40.0),

        // Category Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: RichText(
            text: TextSpan(
              text: 'Category',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: GridView.count(
            padding: EdgeInsets.all(16.0),
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            children: [
              CategoryTile(
                name: 'Clothings',
                image: 'assets/updates_image.png',
              ),
              CategoryTile(
                name: 'Electronics',
                image: 'assets/updates_image.png',
              ),
              CategoryTile(
                name: 'groceries',
                image: 'assets/updates_image.png',
              ),
              CategoryTile(
                name: 'Accessories',
                image: 'assets/updates_image.png',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
