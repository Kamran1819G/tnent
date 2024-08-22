import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:uuid/uuid.dart';

import '../../../core/helpers/color_utils.dart';
import '../../../models/product_model.dart';
import '../../../models/store_category_model.dart';
import 'optionals_screen.dart';

class AddProductScreen extends StatefulWidget {
  final StoreCategoryModel category;
  final String storeId;

  AddProductScreen({required this.category, required this.storeId});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    "Clothing",
    "Electronic",
    "Restaurant",
    "Book",
    "Bakery",
    "Beauty Apparel",
    "Cafe",
    "Florist",
    "Footwear",
    "Accessories",
    "Stationery",
    "Eyewear",
    "Watches",
    "Musicals",
    "Grocery",
    "Sports"
  ];

  List<String> multiOptionCategories = [
    'Clothing',
    'Electronic',
    'Bakery',
    'Footwear',
    "Restaurant",
  ];

  bool get isMultiOptionCategory =>
      multiOptionCategories.contains(selectedCategory);

  void _calculateItemPrice() {
    double discount = double.tryParse(_discountController.text) ?? 0.0;
    double mrp = double.tryParse(_mrpController.text) ?? 0.0;

    if (mrp > 0) {
      double itemPrice = mrp - (mrp * discount / 100);
      _itemPriceController.text = itemPrice.toStringAsFixed(2);
    } else {
      _itemPriceController.text = '';
    }
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 60);

    if (image != null) {
      // Get the app's temporary directory to save the WebP image
      final directory = await getTemporaryDirectory();
      final targetPath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.webp';

      // Compress the image and convert to WebP format
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        format: CompressFormat.webp,
        quality: 80, // Adjust the quality as needed
      );

      if (compressedFile != null) {
        setState(() {
          _images.add(File(compressedFile.path));
        });
      }
    }
  }

  Future<void> _addSingleVariantProduct() async {
    if (!_formKey.currentState!.validate() ||
        _images.isEmpty ||
        selectedCategory == null) {
      _showSnackBar(
          'Please fill in all required fields and add at least one image');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      String customDocRef = 'Product-ID-${Uuid().v4()}';
      final imageUrls = await _uploadImages(customDocRef);
      final productData = _createProductData(customDocRef, imageUrls);
      await FirebaseFirestore.instance
          .collection('products')
          .doc(customDocRef)
          .set(productData);
      await FirebaseFirestore.instance
          .collection('Stores')
          .doc(widget.storeId)
          .update({'totalProducts': FieldValue.increment(1)});
      await FirebaseFirestore.instance
          .collection('Stores')
          .doc(widget.storeId)
          .collection('categories')
          .doc(widget.category.id)
          .update({
        'totalProducts': FieldValue.increment(1),
        'productIds': FieldValue.arrayUnion([customDocRef])
      });

      setState(() {
        isSubmitting = false;
      });
      _showSnackBar('Your product has been listed successfully');
      _clearForm();
      Navigator.pop(context);
    } catch (e) {
      print('Error adding product: $e');
      _showSnackBar('Error adding product. Please try again.');
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void _navigateToOptionalsScreen() {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _images.isEmpty ||
        selectedCategory == null) {
      _showSnackBar(
          'Please fill in all required fields and add at least one image');
      return;
    }

    String customDocRef = 'Product-ID-${Uuid().v4()}';

    ProductModel productData = ProductModel(
      productId: customDocRef,
      storeId: widget.storeId,
      name: _nameController.text,
      description: _descriptionController.text,
      productCategory: selectedCategory!,
      storeCategory: widget.category.name,
      imageUrls: [],
      isAvailable: true,
      createdAt: Timestamp.now(),
      greenFlags: 0,
      redFlags: 0,
      variations: {},
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OptionalsScreen(
          productData: productData,
          categoryId: widget.category.id,
          images: _images,
        ),
      ),
    );
  }

  String _generateSku(String productName, Map<String, dynamic> attributes) {
    String skuBase = productName.substring(0, 3).toUpperCase();
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

    String sku = _generateSku(productData.name, {});
    productData.variations['default'] = ProductVariant(
      discount: double.tryParse(_discountController.text) ?? 0.0,
      mrp: double.tryParse(_mrpController.text) ?? 0.0,
      price: double.tryParse(_itemPriceController.text) ?? 0.0,
      stockQuantity: int.tryParse(_stockQuantityController.text) ?? 0,
      sku: sku,
    );

    return productData.toFirestore();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _clearForm() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100.h,
              margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Add Products'.toUpperCase(),
                        style: TextStyle(
                          color: hexToColor('#1E1E1E'),
                          fontSize: 35.sp,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        ' •',
                        style: TextStyle(
                          fontSize: 35.sp,
                          color: hexToColor('#FF0000'),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.grey[100],
                      ),
                      shape: MaterialStateProperty.all(
                        CircleBorder(),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      // Add Image
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Image',
                              style: TextStyle(
                                fontSize: 23.sp,
                              ),
                            ),
                            SizedBox(height: 12.h),
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
                                    height: 105.h,
                                    width: 105.w,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: hexToColor('#848484')),
                                      borderRadius: BorderRadius.circular(22.r),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.image_outlined,
                                        size: 45.sp,
                                        color: hexToColor('#545454'),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 14.w),
                                if (_images.isNotEmpty)
                                  Expanded(
                                    child: SizedBox(
                                      height: 105.h,
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
                                                height: 105.h,
                                                width: 105.w,
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          22.r),
                                                  child: FadeInImage(
                                                    placeholder: MemoryImage(
                                                        kTransparentImage),
                                                    image: MemoryImage(
                                                        _images[index]
                                                            .readAsBytesSync()),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 2.h,
                                                right: 8.w,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _images.removeAt(index);
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.red,
                                                    ),
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 24.sp,
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
                                    width: 340.w,
                                    child: Text(
                                      'Note: Add more than one image of the product',
                                      style: TextStyle(
                                        fontSize: 17.sp,
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
                      SizedBox(height: 50.h),
                      Container(
                        width: 320.w,
                        height: 75.h,
                        margin: EdgeInsets.only(left: 24.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: hexToColor('#AFAFAF'),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: DropdownButton<String>(
                          hint: Text('Select Product Category'),
                          dropdownColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          style: TextStyle(
                            color: hexToColor('#272822'),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w900,
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          underline: SizedBox(),
                          value: selectedCategory,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCategory = newValue!;
                            });
                          },
                          items: categories.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 50.h),
                      // Product Name
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Item Name',
                              style: TextStyle(
                                fontSize: 23.sp,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            TextFormField(
                              controller: _nameController,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Write your Product Name',
                                hintStyle: TextStyle(
                                  color: hexToColor('#989898'),
                                  fontFamily: 'Gotham',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.sp,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: hexToColor('#848484'),
                                  ),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the product name';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.h),
                      // Product Price
                      if (!isMultiOptionCategory) ...[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Item Price',
                                style: TextStyle(fontSize: 23.sp),
                              ),
                              Text(
                                '(Fill in Discount and MRP, and Item Price will be calculated automatically)',
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  color: hexToColor('#636363'),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 190.w,
                                    child: TextFormField(
                                      controller: _discountController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20.sp,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Discount',
                                        hintStyle: TextStyle(
                                          color: hexToColor('#989898'),
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20.sp,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.percent,
                                          color: Theme.of(context).primaryColor,
                                          size: 30.sp,
                                        ),
                                        prefixIconConstraints:
                                            BoxConstraints(minWidth: 30),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: hexToColor('#848484')),
                                          borderRadius:
                                              BorderRadius.circular(18.r),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          setState(() {
                                            _discountController.text = '0';
                                          });
                                          return null; // Allow empty discount (0%)
                                        }
                                        final double? discount =
                                            double.tryParse(value);
                                        if (discount == null ||
                                            discount < 0 ||
                                            discount > 100) {
                                          return 'Please enter a valid discount (0-100)';
                                        }
                                        return null;
                                      },
                                      onChanged: (_) => _calculateItemPrice(),
                                    ),
                                  ),
                                  Container(
                                    width: 190.w,
                                    child: TextFormField(
                                      controller: _mrpController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20.sp,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'MRP Price',
                                        hintStyle: TextStyle(
                                          color: hexToColor('#989898'),
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20.sp,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.currency_rupee,
                                          color: Theme.of(context).primaryColor,
                                          size: 30.sp,
                                        ),
                                        prefixIconConstraints:
                                            BoxConstraints(minWidth: 30),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: hexToColor('#848484')),
                                          borderRadius:
                                              BorderRadius.circular(18.r),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the MRP';
                                        }
                                        final double? mrp =
                                            double.tryParse(value);
                                        if (mrp == null || mrp <= 0) {
                                          return 'Please enter a valid MRP';
                                        }
                                        return null;
                                      },
                                      onChanged: (_) => _calculateItemPrice(),
                                    ),
                                  ),
                                  Container(
                                    width: 190.w,
                                    child: TextFormField(
                                      controller: _itemPriceController,
                                      enabled: false, // Make it non-editable
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20.sp,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Item Price',
                                        hintStyle: TextStyle(
                                          color: hexToColor('#989898'),
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20.sp,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.currency_rupee,
                                          color: Theme.of(context).primaryColor,
                                          size: 30.sp,
                                        ),
                                        prefixIconConstraints:
                                            BoxConstraints(minWidth: 30),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: hexToColor('#848484')),
                                          borderRadius:
                                              BorderRadius.circular(18.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50.h),
                      ],
                      // Product Description
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Product Description & More Details',
                              style: TextStyle(
                                fontSize: 23.sp,
                              ),
                            ),
                            SizedBox(height: 30.h),
                            TextFormField(
                              controller: _descriptionController,
                              textAlign: TextAlign.start,
                              maxLines: 5,
                              maxLength: 700,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp,
                              ),
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Description',
                                labelStyle: TextStyle(
                                  color: hexToColor('#545454'),
                                  fontSize: 20.sp,
                                ),
                                hintText: 'Write product description...',
                                hintStyle: TextStyle(
                                  color: hexToColor('#989898'),
                                  fontFamily: 'Gotham',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.sp,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: hexToColor('#848484'),
                                  ),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the product description';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.h),
                      // Product Stock Quantity
                      if (!isMultiOptionCategory) ...[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product Stock Quantity',
                                style: TextStyle(
                                  fontSize: 23.sp,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 300.w,
                                    child: TextFormField(
                                      controller: _stockQuantityController,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20.sp,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Ex. 100',
                                        hintStyle: TextStyle(
                                          color: hexToColor('#989898'),
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20.sp,
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: hexToColor('#848484'),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 16,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the stock quantity';
                                        }
                                        final int? stockQuantity =
                                            int.tryParse(value);
                                        if (stockQuantity == null ||
                                            stockQuantity < 0) {
                                          return 'Please enter a valid stock quantity';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Expanded(
                                    child: Text(
                                      '(Add Total Product Stock Quantity)',
                                      style: TextStyle(
                                        fontSize: 17.sp,
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
                        SizedBox(height: 30.h),
                      ],
                      if (isMultiOptionCategory)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Add item price and stock quantity on next page',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: hexToColor('#636363'),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 8.h),
                      Center(
                        child: isSubmitting
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    hexToColor('#2B2B2B')),
                              )
                            : ElevatedButton(
                                onPressed: isMultiOptionCategory
                                    ? _navigateToOptionalsScreen
                                    : _addSingleVariantProduct,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: hexToColor('#2B2B2B'),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 75, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.r)),
                                ),
                                child: Text(
                                  isMultiOptionCategory ? 'Next' : 'List Item',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.sp,
                                      fontFamily: 'Gotham',
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
