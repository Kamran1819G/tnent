import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          TabBar(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            unselectedLabelColor: Colors.black,
            labelColor: Colors.black,
            indicator: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            splashBorderRadius: BorderRadius.circular(12),
            indicatorSize: TabBarIndicatorSize.values[0],
            dividerColor: Colors.transparent,
            tabs: <Widget>[
              Tab(
                text: "General",
              ),
              Tab(
                text: "Connections",
              ),
            ],
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
                                  Text('Order ID:', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900)),
                                  SizedBox(width: 4.0),
                                  Text('#1234567890', style: TextStyle(fontSize: 12.0)),
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
                    separatorBuilder: (context, index) => SizedBox(height: 16.0),
                    itemCount: 2),
                ListView.separated(
                    itemBuilder: (context, index) => ListTile(
                          title: Text('General'),
                          subtitle: Text('General updates'),
                        ),
                    separatorBuilder: (context, index) => SizedBox(height: 16.0),
                    itemCount: 5)
              ]),
            ),
          )
        ],
      ),
    );
  }
}
