import 'package:flutter/material.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/screens/product_detail_screen.dart';
import 'notification_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int? _selectedFilterOption;
  String searchQuery = '';
  List<dynamic> products = [
    {
      'name': 'Product 1 Product 1 Product 1',
      'image': 'assets/product_image.png',
      'price': 100.0,
    },
    {
      'name': 'Product 2',
      'image': 'assets/product_image.png',
      'price': 200.0,
    },
    {
      'name': 'Product 3',
      'image': 'assets/product_image.png',
      'price': 300.0,
    },
    {
      'name': 'Product 4',
      'image': 'assets/product_image.png',
      'price': 400.0,
    },
    {
      'name': 'Product 1 Product 1 Product 1',
      'image': 'assets/product_image.png',
      'price': 100.0,
    },
    {
      'name': 'Product 2',
      'image': 'assets/product_image.png',
      'price': 200.0,
    },
    {
      'name': 'Product 3',
      'image': 'assets/product_image.png',
      'price': 300.0,
    },
    {
      'name': 'Product 4',
      'image': 'assets/product_image.png',
      'price': 400.0,
    },
    {
      'name': 'Product 1 Product 1 Product 1',
      'image': 'assets/product_image.png',
      'price': 100.0,
    },
    {
      'name': 'Product 2',
      'image': 'assets/product_image.png',
      'price': 200.0,
    },
    {
      'name': 'Product 3',
      'image': 'assets/product_image.png',
      'price': 300.0,
    },
    {
      'name': 'Product 4',
      'image': 'assets/product_image.png',
      'price': 400.0,
    }
  ];

  List<dynamic> filteredProducts = [];

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts =
            products; // Show all products if the search query is empty
      } else {
        filteredProducts = products
            .where((product) =>
                product['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Explore'.toUpperCase(),
                        style: TextStyle(
                          color: hexToColor('#1E1E1E'),
                          fontSize: 24.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        ' •',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18.0,
                          color: hexToColor('#FAD524'),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NotificationScreen()));
                          },
                          child: Image.asset(
                            'assets/icons/notification_box.png',
                            height: 24,
                            width: 24,
                            fit: BoxFit.cover,
                            colorBlendMode: BlendMode.overlay,
                          )),
                      SizedBox(width: 10),
                      Container(
                        margin: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios_new,
                                color: Colors.black),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Products & Store',
                        hintStyle: TextStyle(
                          color: hexToColor('#6D6D6D'),
                          fontSize: 16.0,
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        searchQuery = value;
                        _filterProducts(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (filteredProducts.isNotEmpty && searchQuery.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        'Showing ${filteredProducts.length} results for "$searchQuery"',
                        style: TextStyle(
                          color: hexToColor('#6D6D6D'),
                          fontSize: 14.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => _buildBottomSheet());
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          'assets/icons/filter.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
            filteredProducts.isNotEmpty && searchQuery.isNotEmpty
                ? Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      padding: EdgeInsets.all(20),
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.7,
                      children: [
                        ...filteredProducts.map((product) {
                          return ResultTile(
                            name: product['name'],
                            image: product['image'],
                            price: product['price'],
                          );
                        }).toList(),
                      ],
                    ),
                  )
                : filteredProducts.isEmpty && searchQuery.isNotEmpty
                    ? ClipRRect(
                        child: Image.asset(
                          'assets/no_results.png',
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.7,
                        ),
                      )
                    : Container()
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: hexToColor('#CACACA'),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Add Filter',
            style: TextStyle(
                color: hexToColor('#343434'),
                fontSize: 16.0),
          ),
          SizedBox(height: 25),
          StatefulBuilder(
            builder: (context, setState) => Column(
              children: [
                RadioListTile(
                  title: Text('Featured',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0)),
                  controlAffinity: ListTileControlAffinity.trailing,
                  dense: true,
                  value: 0,
                  groupValue: _selectedFilterOption,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilterOption = value as int?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('High To Low',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0)),
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: 1,
                  groupValue: _selectedFilterOption,
                  activeColor: Theme.of(context).primaryColor,
                  dense: true,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilterOption = value as int?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Low To High',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0)),
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: 2,
                  groupValue: _selectedFilterOption,
                  activeColor: Theme.of(context).primaryColor,
                  dense: true,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilterOption = value as int?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Discount',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0)),
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: 3,
                  groupValue: _selectedFilterOption,
                  activeColor: Theme.of(context).primaryColor,
                  dense: true,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilterOption = value as int?;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResultTile extends StatefulWidget {
  final String name;
  final String image;
  final double price;

  ResultTile({
    required this.name,
    required this.image,
    required this.price,
  });

  @override
  _ResultTileState createState() => _ResultTileState();
}

class _ResultTileState extends State<ResultTile> {
  bool _isInWishlist = false;

  void _toggleWishlist() {
    setState(() {
      _isInWishlist = !_isInWishlist;
    });

// Send wishlist request to the server
    if (_isInWishlist) {
// Code to send wishlist request to the server
      print('Adding to wishlist...');
    } else {
// Code to remove from wishlist request to the server
      print('Removing from wishlist...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              images: [
                Image.asset(widget.image),
                Image.asset(widget.image),
                Image.asset(widget.image),
              ],
              productName: widget.name,
              productDescription:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. eiusmod tempor incididunt ut labore et do.',
              productPrice: widget.price,
              storeName: 'Jain Brothers',
              storeLogo: 'assets/jain_brothers.png',
              Discount: 10,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: hexToColor('#F5F5F5'),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  child: Image.asset(widget.image, fit: BoxFit.fill),
                ),
                Positioned(
                  right: 8.0,
                  top: 8.0,
                  child: GestureDetector(
                    onTap: _toggleWishlist,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Icon(
                        _isInWishlist ? Icons.favorite : Icons.favorite_border,
                        color: _isInWishlist ? Colors.red : Colors.grey,
                        size: 14.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                        color: hexToColor('#222230'),
                        fontSize: 12.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    '\$${widget.price.toString()}',
                    style: TextStyle(
                        color: hexToColor('#343434'),
                        fontSize: 12.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
