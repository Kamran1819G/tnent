import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/models/store_category_model.dart';
import 'package:tnennt/models/product_model.dart';
import 'package:tnennt/screens/store_owner_screens/optionals_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class AddProductScreen extends StatefulWidget {
  final StoreCategoryModel category;
  final String storeId;

  AddProductScreen({required this.category, required this.storeId});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File? _image;
  List<File> _images = [];
  String? selectedCategory;
  bool isSubmitting = false;
  TextEditingController _discountController = TextEditingController();
  TextEditingController _mrpController = TextEditingController();
  TextEditingController _itemPriceController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _stockQuantityController = TextEditingController();

  List<String> categories = [
    "Clothings",
    "Accessories",
    "Electronics",
    "Foods",
    "Florists",
    "Sports",
    "Books",
    "Stationeries",
    "Beauty Apparels",
    "Eyewares",
    "Furnitures",
    "Home Decors",
    "Jewelries",
    "Shoes",
    "Toys",
    "Watches"
  ];

  List<String> multiOptionCategories = [
    'Clothing',
    'Electronics',
    'Bakery',
    'Shoes'
  ];

  bool get isMultiOptionCategory =>
      multiOptionCategories.contains(selectedCategory);

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

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _images.add(_image!);
      });
    }
  }

  Future<void> _addProduct() async {
    setState(() {
      isSubmitting = true;
    });

    if (_images.isEmpty ||
        selectedCategory == null ||
        _nameController.text.isEmpty) {
      _showSnackBar(
          'Please fill in all required fields and add at least one image');
      return;
    }

    try {
      String productId = 'ProductID' + Uuid().v4();
      // Generate a new document reference with auto-generated ID
      productId = FirebaseFirestore.instance.collection('products').doc().id;
      final imageUrls = await _uploadImages(productId);
      final productData = _createProductData(productId, imageUrls);
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .set(productData);
      await FirebaseFirestore.instance.collection('Stores').doc(widget.storeId).update({'totalProducts': FieldValue.increment(1)});
      await FirebaseFirestore.instance.collection('Stores').doc(widget.storeId).collection('categories').doc(widget.category.id).update({'totalProducts': FieldValue.increment(1), 'productIds': FieldValue.arrayUnion([productId])});
      setState(() {
        isSubmitting = false;
      });
      isMultiOptionCategory
          ? _navigateToOptionalsScreen(productId)
          : _clearForm();
    } catch (e) {
      print('Error adding product: $e');
      _showSnackBar('Error adding product. Please try again.');
    }
  }

  String _generateSku(String productName, Map<String, dynamic> attributes) {
    String skuBase = productName
        .substring(0, 3)
        .toUpperCase(); // First 3 letters of product name
    String skuAttributes = attributes.entries
        .map((entry) =>
            '${entry.key.substring(0, 1).toUpperCase()}${entry.value.toString().substring(0, 1).toUpperCase()}')
        .join('-');
    return '$skuBase-$skuAttributes-${DateTime.now().millisecondsSinceEpoch}';
  }

  Map<String, dynamic> _createProductData(
      String productId, List<String> imageUrls) {
    final productData = ProductModel(
      productId: productId,
      storeId: widget.storeId,
      name: _nameController.text,
      description: _descriptionController.text,
      productCategory: selectedCategory!,
      storeCategory: widget.category.name,
      imageUrls: imageUrls,
      isAvailable: true,
      createdAt: Timestamp.now(),
      greenFlags: 0,
      redFlags: 0,
      variations: {},
    );

    if (!isMultiOptionCategory) {
      String sku = _generateSku(productData.name, {});
      productData.variations['default'] = ProductVariant(
          discount: double.tryParse(_discountController.text) ?? 0.0,
          mrp: double.tryParse(_mrpController.text) ?? 0.0,
          price: double.tryParse(_itemPriceController.text) ?? 0.0,
          stockQuantity: int.tryParse(_stockQuantityController.text) ?? 0,
          sku: sku,
        );
    }

    return productData.toFirestore();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _navigateToOptionalsScreen(String productId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OptionalsScreen(
          productId: productId,
          productCategory: selectedCategory!,
        ),
      ),
    );
  }

  Future<List<String>> _uploadImages(String productId) async {
    List<String> imageUrls = [];
    FirebaseStorage storage = FirebaseStorage.instance;

    for (int i = 0; i < _images.length; i++) {
      String fileName = 'product_${productId}_$i.jpg';
      Reference ref = storage.ref().child('products/$productId/$fileName');
      UploadTask uploadTask = ref.putFile(_images[i]);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }

    return imageUrls;
  }

  void _clearForm() {
    _showSnackBar('Product added successfully');
    setState(() {
      _images.clear();
      selectedCategory = null;
      _nameController.clear();
      _descriptionController.clear();
      _discountController.clear();
      _mrpController.clear();
      _itemPriceController.clear();
      _stockQuantityController.clear();
    });
    Navigator.pop(context);
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
                          fontSize: 24.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        ' •',
                        style: TextStyle(
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
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
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
                                    borderRadius: BorderRadius.circular(18),
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
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    'Note: Add more than one image of the product',
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
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: hexToColor('#AFAFAF'),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: DropdownButton<String>(
                        hint: Text('Select Product Category'),
                        dropdownColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        style: TextStyle(
                          color: hexToColor('#272822'),
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
                        items: categories
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          );
                        }).toList(),
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
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: _nameController,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              hintText: 'Write your Product Name',
                              hintStyle: TextStyle(
                                color: hexToColor('#989898'),
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w700,
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
                    if (!isMultiOptionCategory)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Item Price',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '(Fill any two slots and the third will be calculated automatically)',
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: hexToColor('#636363'),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: TextField(
                                    controller: _discountController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Gotham',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.0,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Discount',
                                      hintStyle: TextStyle(
                                        color: hexToColor('#989898'),
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14.0,
                                      ),
                                      prefixIcon: Text(
                                        '%',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.0,
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
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: TextField(
                                    controller: _mrpController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Gotham',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.0,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'MRP Price',
                                      hintStyle: TextStyle(
                                        color: hexToColor('#989898'),
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14.0,
                                      ),
                                      prefixIcon: Text(
                                        '₹',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.0,
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
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: TextField(
                                    controller: _itemPriceController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Gotham',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.0,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Item Price',
                                      hintStyle: TextStyle(
                                        color: hexToColor('#989898'),
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14.0,
                                      ),
                                      prefixIcon: Text(
                                        '₹',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.0,
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
                    if (!isMultiOptionCategory) SizedBox(height: 30),
                    // Product Description
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Product Description & More Details',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: _descriptionController,
                            textAlign: TextAlign.start,
                            maxLines: 5,
                            maxLength: 700,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Description',
                              labelStyle: TextStyle(
                                color: hexToColor('#545454'),
                                fontSize: 14.0,
                              ),
                              hintText: 'Write product description...',
                              hintStyle: TextStyle(
                                color: hexToColor('#989898'),
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w700,
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
                    // Product Stock Quantity
                    if (!isMultiOptionCategory) ...[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Stock Quantity',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: 175,
                                  child: TextField(
                                    controller: _stockQuantityController,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Gotham',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.0,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Ex. 100',
                                      hintStyle: TextStyle(
                                        color: hexToColor('#989898'),
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w700,
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
                    ],
                    if (isMultiOptionCategory)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Add item price and stock quantity on next page',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: hexToColor('#636363'),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 8),
                    Center(
                      child: isSubmitting
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  hexToColor('#2B2B2B')),
                            )
                          : ElevatedButton(
                              onPressed:_addProduct,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: hexToColor('#2B2B2B'),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 75, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Text(
                                'List Item',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ),
                    ),
                    SizedBox(height: 30),
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
