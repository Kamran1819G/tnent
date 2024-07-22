import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/models/product_model.dart';
import 'package:tnennt/screens/notification_screen.dart';
import 'package:tnennt/widgets/wishlist_product_tile.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int? _selectedFilterOption;
  String searchQuery = '';
  List<ProductModel> products = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initially load all products
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot querySnapshot;
      if (searchQuery.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance.collection('products').get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('products')
            .where('name', isGreaterThanOrEqualTo: searchQuery)
            .where('name', isLessThanOrEqualTo: '$searchQuery\uf8ff')
            .get();
      }

      products = querySnapshot.docs.map((doc) {
        return ProductModel.fromFirestore(doc);
      }).toList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching products: $e');
    }
  }

  void _filterProducts(String query) {
    setState(() {
      searchQuery = query;
    });
    _fetchProducts();
  }

  void _applyFilter() {
    List<ProductModel> tempProducts = products;
    if (_selectedFilterOption != null) {
      switch (_selectedFilterOption) {
        case 0:
        // Add logic for 'Featured'
          break;
        case 1:
        // High to Low
          tempProducts.sort((a, b) {
            double aPrice = a.variations.values.first.price;
            double bPrice = b.variations.values.first.price;
            return bPrice.compareTo(aPrice);
          });
          break;
        case 2:
        // Low to High
          tempProducts.sort((a, b) {
            double aPrice = a.variations.values.first.price;
            double bPrice = b.variations.values.first.price;
            return aPrice.compareTo(bPrice);
          });
          break;
        case 3:
        // Discount
          tempProducts.sort((a, b) {
            double aDiscount = a.variations.values.first.discount;
            double bDiscount = b.variations.values.first.discount;
            return bDiscount.compareTo(aDiscount);
          });
          break;
        default:
          break;
      }
    }
    setState(() {
      products = tempProducts;
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
                            'assets/icons/new_notification_box.png',
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
                        _filterProducts(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (products.isNotEmpty && searchQuery.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        'Showing ${products.length} results for "$searchQuery"',
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
                          builder: (context) => _buildBottomSheet(),
                        );
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
            isLoading
                ? Center(child: CircularProgressIndicator())
                : products.isNotEmpty && searchQuery.isNotEmpty
                ? Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(20),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.7,
                children: [
                  ...products.map((product) {
                    return WishlistProductTile(product: product);
                  }).toList(),
                ],
              ),
            )
                : products.isEmpty && searchQuery.isNotEmpty
                ? ClipRRect(
              child: Image.asset(
                'assets/no_results.png',
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.7,
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Sort & Filter',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Column(
            children: [
              _buildFilterOption(0, 'Featured'),
              _buildFilterOption(1, 'Price: High to Low'),
              _buildFilterOption(2, 'Price: Low to High'),
              _buildFilterOption(3, 'Discount'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(int index, String title) {
    return RadioListTile<int>(
      value: index,
      groupValue: _selectedFilterOption,
      onChanged: (int? value) {
        setState(() {
          _selectedFilterOption = value;
        });
        _applyFilter();
        Navigator.pop(context);
      },
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
      activeColor: Theme.of(context).primaryColor,
    );
  }
}
