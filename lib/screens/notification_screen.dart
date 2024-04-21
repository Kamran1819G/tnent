import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isStoreOwner = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: isStoreOwner ? 2 : 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100.0,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Updates'.toUpperCase(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 28.0,
                  letterSpacing: 1.5,
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
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              unselectedLabelColor: Colors.black,
              labelColor: Colors.white,
              indicator: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
              labelStyle: TextStyle(
                fontSize: 14.0,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              dividerColor: Colors.transparent,
              tabs: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text("General")),
                if (isStoreOwner)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      "Store",
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TabBarView(controller: _tabController, children: [
                ListView.separated(
                    itemBuilder: (context, index) => ListTile(
                          minVerticalPadding: 8.0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("Delivered",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.w900)),
                                  SizedBox(width: 8.0),
                                  Text("(April 20, 2024, 12:45pm )",
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w900)),
                                ],
                              ),
                              SizedBox(height: 4.0),
                              Row(
                                children: [
                                  Text('Order ID:',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w900)),
                                  SizedBox(width: 4.0),
                                  Text('#1234567890',
                                      style: TextStyle(fontSize: 12.0)),
                                ],
                              ),
                            ],
                          ),
                          subtitle: Text('Item is delivered to Kamran Khan'),
                          trailing: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.green.shade900,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Icon(Icons.check,
                                color: Colors.white, size: 12.0),
                          ),
                        ),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 16.0),
                    itemCount: 2),
                if (isStoreOwner)
                  ListView.separated(
                      itemBuilder: (context, index) => ListTile(
                            title: Text('General'),
                            subtitle: Text('General updates'),
                          ),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16.0),
                      itemCount: 5)
              ]),
            ),
          )
        ],
      ),
    );
  }
}
