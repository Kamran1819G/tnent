import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/models/category_model.dart';
import 'package:tnennt/models/product_model.dart';
import 'package:tnennt/screens/product_detail_screen.dart';
import 'package:tnennt/helpers/text_utils.dart';


class CategoryProductsScreen extends StatefulWidget {
  CategoryModel category;

  CategoryProductsScreen({required this.category});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  late Stream<QuerySnapshot> _productsStream;

  @override
  void initState() {
    super.initState();
    _productsStream = FirebaseFirestore.instance
        .collection('Products')
        .where('category', isEqualTo: widget.category)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              padding: EdgeInsets.only(left: 16, right: 8),
              child: Row(
                children: [
                  Image.asset('assets/black_tnennt_logo.png', width: 30, height: 30),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.all(8.0),
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
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.category.name.capitalize(),
                style: TextStyle(
                  color: hexToColor('#343434'),
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _productsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List<ProductModel> products = snapshot.data!.docs
                      .map((doc) => ProductModel.fromFirestore(doc))
                      .toList();

                  return GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductTile(
                        name: product.name,
                        image: product.imageUrls.first,
                        price: product.variants.first.price,
                        onRemove: () {
                          // Remove product from category
                          setState(() {
                            widget.category.products.removeWhere((element) => element['id'] == product.id);
                          });
                        },
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProductTile extends StatefulWidget {
  final String name;
  final String image;
  final double price;
  final Function onRemove;

  ProductTile({
    required this.name,
    required this.image,
    required this.price,
    required this.onRemove,
  });

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  void _removeProduct() {
    widget.onRemove();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: hexToColor('#F5F5F5'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(widget.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 8.0,
                  top: 8.0,
                  child: GestureDetector(
                    onTap: _removeProduct,
                    child: Container(
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Icon(
                        Icons.remove,
                        color: Colors.red,
                        size: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                    color: hexToColor('#343434'),
                    fontSize: 10.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.0),
                Text(
                  '\$${widget.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}