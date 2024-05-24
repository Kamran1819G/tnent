import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tnennt/screens/store_owner_screens/optionals_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/screens/product_detail_screen.dart';

class ProductCategoriesScreen extends StatefulWidget {
  const ProductCategoriesScreen({super.key});

  @override
  State<ProductCategoriesScreen> createState() =>
      _ProductCategoriesScreenState();
}

class _ProductCategoriesScreenState extends State<ProductCategoriesScreen> {
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
                  Image.asset('assets/black_tnennt_logo.png',
                      width: 30, height: 30),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: IconButton(
                        icon:
                            Icon(Icons.arrow_back_ios_new, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: Text(
                      'Choose Your Personalized Category',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Create dedicated sections for your product list add items to their respective slot.',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: hexToColor('#636363'),
                    ),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllProductsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        'View All Products',
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: hexToColor('#FFFFFF')),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Categories:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: hexToColor('#545454'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: hexToColor('#848484'),
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: hexToColor('#2D332F'),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Create Your New Category',
                              hintTextDirection: TextDirection.ltr,
                              hintStyle: TextStyle(
                                color: hexToColor('#A1A1A1'),
                                fontSize: 16,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Created Categories:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: hexToColor('#545454'),
                    ),
                  ),
                  SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return CategoryTile(
                        categoryName: 'Food',
                        itemCount: 137,
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String categoryName;
  final Color color;
  final int itemCount;

  const CategoryTile({
    required this.categoryName,
    this.color = const Color(0xFFDDF1EF),
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsScreen(),
          ),
        );
      },
      child: Container(
        height: 100,
        width: 125,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              categoryName.toUpperCase(),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemCount.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Items'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddProductScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File? _image;
  List<File> _images = [];
  String selectedCategory = 'Accessories';
  TextEditingController _discountController = TextEditingController();
  TextEditingController _mrpController = TextEditingController();
  TextEditingController _itemPriceController = TextEditingController();

  void _calculateValues() {
    double discount = double.tryParse(_discountController.text) ?? 0.0;
    double mrp = double.tryParse(_mrpController.text) ?? 0.0;
    double itemPrice = double.tryParse(_itemPriceController.text) ?? 0.0;

    if (discount != 0.0 && mrp != 0.0) {
      itemPrice = mrp - (mrp * discount / 100);
      _itemPriceController.text = itemPrice.toStringAsFixed(2);
    } else if (discount != 0.0 && itemPrice != 0.0) {
      mrp = itemPrice / (1 - discount / 100);
      _mrpController.text = mrp.toStringAsFixed(2);
    } else if (mrp != 0.0 && itemPrice != 0.0) {
      discount = ((mrp - itemPrice) / mrp) * 100;
      _discountController.text = discount.toStringAsFixed(2);
    }
  }

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _images.add(_image!);
      });
    }
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
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Add Products'.toUpperCase(),
                        style: TextStyle(
                          color: hexToColor('#1E1E1E'),
                          fontWeight: FontWeight.w900,
                          fontSize: 24.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        ' •',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 28.0,
                          color: hexToColor('#FF0000'),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: IconButton(
                        icon:
                            Icon(Icons.arrow_back_ios_new, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    // Add Image
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Image',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w900),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Add the function to be executed when the button is pressed
                                  if (_images.length < 3) {
                                    pickImage();
                                  }
                                },
                                child: Container(
                                  height: 75,
                                  width: 75,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: hexToColor('#848484')),
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.image_outlined,
                                      size: 40,
                                      color: hexToColor('#545454'),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              if (_images.isNotEmpty)
                                Expanded(
                                  child: SizedBox(
                                    height: 75,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: _images.length > 3
                                          ? 3
                                          : _images.length,
                                      itemBuilder: (context, index) {
                                        return Stack(
                                          children: [
                                            Container(
                                              width: 75,
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        hexToColor('#848484')),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                image: DecorationImage(
                                                  image:
                                                      FileImage(_images[index]),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _images.removeAt(index);
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.red,
                                                  ),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              if (_images.isEmpty)
                                Text(
                                  '(Add more than one image of the product)',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: hexToColor('#636363'),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: hexToColor('#AFAFAF'),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: DropdownButton<String>(
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                              style: TextStyle(
                                color: hexToColor('#272822'),
                                fontWeight: FontWeight.w900,
                                fontSize: 16.0,
                              ),
                              icon: Icon(Icons.keyboard_arrow_down_rounded),
                              underline: SizedBox(),
                              value: selectedCategory,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCategory = newValue!;
                                });
                              },
                              items: <String>[
                                'Accessories',
                                'Clothing',
                                'Electronics',
                                'Food',
                                'Furniture',
                                'Grocery',
                                'Home Decor',
                                'Jewelry',
                                'Shoes',
                                'Toys',
                                'Watches',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Select Product Category',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: hexToColor('#636363'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    // Product Name
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item Name',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w900),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              hintText: 'Write your Product Name',
                              hintStyle: TextStyle(
                                color: hexToColor('#989898'),
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: hexToColor('#848484'),
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    // Product Price
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item Price',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w900),
                          ),
                          Text(
                            '(Fill any two slots and the third will be calculated automatically)',
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: hexToColor('#636363'),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _discountController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Gotham',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Discount',
                                    hintStyle: TextStyle(
                                      color: hexToColor('#989898'),
                                      fontFamily: 'Gotham',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                    ),
                                    prefixIcon: Text(
                                      '%',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    prefixIconConstraints: BoxConstraints(
                                      minWidth: 30,
                                      minHeight: 0,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: hexToColor('#848484'),
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  onSubmitted: (_) => _calculateValues(),
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: TextField(
                                  controller: _mrpController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Gotham',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'MRP Price',
                                    hintStyle: TextStyle(
                                      color: hexToColor('#989898'),
                                      fontFamily: 'Gotham',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                    ),
                                    prefixIcon: Text(
                                      '₹',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    prefixIconConstraints: BoxConstraints(
                                      minWidth: 30,
                                      minHeight: 0,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: hexToColor('#848484'),
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  onSubmitted: (_) => _calculateValues(),
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: TextField(
                                  controller: _itemPriceController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Gotham',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Item Price',
                                    hintStyle: TextStyle(
                                      color: hexToColor('#989898'),
                                      fontFamily: 'Gotham',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                    ),
                                    prefixIcon: Text(
                                      '₹',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    prefixIconConstraints: BoxConstraints(
                                      minWidth: 30,
                                      minHeight: 0,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: hexToColor('#848484'),
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  onSubmitted: (_) => _calculateValues(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    // Optional
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item Optional',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w900),
                          ),
                          Text(
                            '(Use if your product has different size, weight & volume )',
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: hexToColor('#636363'),
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OptionalsScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              width: 175,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Add Optional',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    // Product Description
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Product Description & More Details',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w900),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            textAlign: TextAlign.start,
                            maxLines: 5,
                            maxLength: 700,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Description',
                              labelStyle: TextStyle(
                                color: hexToColor('#545454'),
                                fontWeight: FontWeight.w900,
                                fontSize: 14.0,
                              ),
                              hintText: 'Write product description...',
                              hintStyle: TextStyle(
                                color: hexToColor('#989898'),
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: hexToColor('#848484'),
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Stock Quantity',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w900),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              SizedBox(
                                width: 175,
                                child: TextField(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Gotham',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Ex. 100',
                                    hintStyle: TextStyle(
                                      color: hexToColor('#989898'),
                                      fontFamily: 'Gotham',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: hexToColor('#848484'),
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  '(Add Total Product Stock Quantity)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: hexToColor('#636363'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 50,
                          width: 250,
                          margin: EdgeInsets.symmetric(vertical: 15.0),
                          decoration: BoxDecoration(
                            color: hexToColor('#2B2B2B'),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Center(
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Container(
            height: 100,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Row(
                  children: [
                    Text(
                      'All Products'.toUpperCase(),
                      style: TextStyle(
                        color: hexToColor('#1E1E1E'),
                        fontWeight: FontWeight.w900,
                        fontSize: 24.0,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      ' •',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 28.0,
                        color: hexToColor('#FF0000'),
                      ),
                    ),
                  ],
                ),
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
          SizedBox(),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.7,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return ProductTile(
                  name: 'Product $index',
                  image: 'assets/product_image.png',
                  price: 100.0,
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 100,
            padding: EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                Image.asset('assets/black_tnennt_logo.png',
                    width: 30, height: 30),
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
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Category Products',
              style: TextStyle(
                color: hexToColor('#343434'),
                fontWeight: FontWeight.w900,
                fontSize: 18.0,
              ),
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.7,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return ProductTile(
                  name: 'Product $index',
                  image: 'assets/product_image.png',
                  price: 100.0,
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}

class ProductTile extends StatefulWidget {
  final String name;
  final String image;
  final double price;

  ProductTile({
    required this.name,
    required this.image,
    required this.price,
  });

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
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
        height: 200, // Adjust the height as needed
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
                        image: AssetImage(widget.image),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8.0,
                    top: 8.0,
                    child: GestureDetector(
                      onTap: _toggleWishlist,
                      child: Container(
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Icon(
                          _isInWishlist
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _isInWishlist ? Colors.red : Colors.grey,
                          size: 12.0,
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
                      fontWeight: FontWeight.w900,
                      fontSize: 10.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    '\$${widget.price.toString()}',
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontWeight: FontWeight.w900,
                      fontSize: 10.0,
                    ),
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