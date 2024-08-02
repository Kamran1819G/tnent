import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tnennt/helpers/snackbar_utils.dart';
import 'package:tnennt/models/product_model.dart';
import 'package:uuid/uuid.dart';

class OptionalsScreen extends StatefulWidget {
  final ProductModel productData;
  final String categoryId;
  final List<File> images;

  OptionalsScreen(
      {required this.productData,
      required this.categoryId,
      required this.images});

  @override
  _OptionalsScreenState createState() => _OptionalsScreenState();
}

class _OptionalsScreenState extends State<OptionalsScreen>
    with TickerProviderStateMixin {
  late TabController optionTabController;
  List<String> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    optionTabController = TabController(length: getTabLength(), vsync: this);
  }

  @override
  void dispose() {
    optionTabController.dispose();
    super.dispose();
  }

  int getTabLength() {
    switch (widget.productData.productCategory.toLowerCase()) {
      case 'clothings':
        return 3; // Topwear, Bottomwear, Footwear
      case 'bakeries':
        return 2; // Pound, Gram/KG
      case 'electronics':
        return 1; // Capacity
      default:
        return 3;
    }
  }

  String getCategoryTitle() {
    switch (widget.productData.productCategory.toLowerCase()) {
      case 'clothings':
        return 'Add Size';
      case 'bakeries':
        return 'Add Bakery';
      case 'electronics':
        return 'Add Storage';
      case 'restaurants':
        return 'Add Bowel Size';
      default:
        return 'Add Option';
    }
  }

  List<Widget> getTabs() {
    switch (widget.productData.productCategory.toLowerCase()) {
      case 'clothings':
        return [
          OptionTab('Topwear', hexToColor('#343434')),
          OptionTab('Bottomwear', hexToColor('#343434')),
          OptionTab('Footwear', hexToColor('#343434')),
        ];
      case 'bakeries':
        return [
          OptionTab('Pound', hexToColor('#343434')),
          OptionTab('Gram/KG', hexToColor('#343434')),
        ];
      case 'electronics':
        return [OptionTab('Capacity', hexToColor('#343434'))];
      case 'restaurants':
        return [OptionTab('Bowel Size', hexToColor('#343434'))];
      default:
        return [OptionTab('Option', hexToColor('#343434'))];
    }
  }

  List<Widget> getTabViews() {
    switch (widget.productData.productCategory.toLowerCase()) {
      case 'clothings':
        return [
          OptionListView(
            options: ['XS', 'S', 'M', 'L', 'XL'],
            selectedOptions: selectedOptions,
            onOptionSelected: updateSelectedOptions,
          ),
          OptionListView(
            options: ['28', '30', '32', '34', '36'],
            selectedOptions: selectedOptions,
            onOptionSelected: updateSelectedOptions,
          ),
          OptionListView(
            options: ['US 6', 'US 7', 'US 8', 'US 9', 'US 10'],
            selectedOptions: selectedOptions,
            onOptionSelected: updateSelectedOptions,
          ),
        ];
      case 'bakeries':
        return [
          OptionListView(
            options: ['1 Pound', '2 Pound', '5 Pound', '10 Pound'],
            selectedOptions: selectedOptions,
            onOptionSelected: updateSelectedOptions,
          ),
          OptionListView(
            options: ['50g', '100g', '200g', '500g', '1kg', '2kg'],
            selectedOptions: selectedOptions,
            onOptionSelected: updateSelectedOptions,
          ),
        ];
      case 'electronics':
        return [
          OptionListView(
            options: [
              '8GB + 64GB',
              '8GB + 128GB',
              '8GB + 256GB',
              '12GB + 128GB',
              '12GB + 256GB',
              '12GB + 512GB'
            ],
            selectedOptions: selectedOptions,
            onOptionSelected: updateSelectedOptions,
          ),
        ];
      case 'restaurants':
        return [
          OptionListView(
            options: ['Half', 'Full'],
            selectedOptions: selectedOptions,
            onOptionSelected: updateSelectedOptions,
          ),
        ];
      default:
        return [Container()];
    }
  }

  void updateSelectedOptions(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  void _validateAndProceed(BuildContext context) {
    if (selectedOptions.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Validation Error'),
          content: Text('Please select at least one option.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).primaryColor,
              ),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OptionalsPriceScreen(
            productData: widget.productData,
            categoryId: widget.categoryId,
            images: widget.images,
            selectedOptions: selectedOptions,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                        'Optionals'.toUpperCase(),
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
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getCategoryTitle(),
                      style: TextStyle(
                        fontSize: 23.sp,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    TabBar(
                      controller: optionTabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      unselectedLabelColor: hexToColor('#737373'),
                      labelColor: Colors.white,
                      indicator: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      labelPadding: EdgeInsets.symmetric(horizontal: 6.w),
                      labelStyle: TextStyle(
                        fontSize: 20.sp,
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      dividerColor: Colors.transparent,
                      tabs: getTabs(),
                    ),
                    SizedBox(height: 30.h),
                    Dash(
                      direction: Axis.horizontal,
                      length: 600.w,
                      dashLength: 10,
                      dashColor: hexToColor('#848484'),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        controller: optionTabController,
                        children: getTabViews(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () => _validateAndProceed(context),
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
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
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

class OptionTab extends StatelessWidget {
  final String title;
  final Color color;

  OptionTab(this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.0),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Text(title),
    );
  }
}

class OptionListView extends StatelessWidget {
  final List<String> options;
  final List<String> selectedOptions;
  final Function(String) onOptionSelected;

  OptionListView({
    required this.options,
    required this.selectedOptions,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          options.length,
          (index) => CheckboxListTile(
            title: Text(
              options[index],
              style: TextStyle(
                fontSize: 23.sp,
                color: Theme.of(context).primaryColor,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            checkColor: Colors.white,
            activeColor: Theme.of(context).primaryColor,
            value: selectedOptions.contains(options[index]),
            onChanged: (value) {
              onOptionSelected(options[index]);
            },
          ),
        ),
      ),
    );
  }
}

class OptionalsPriceScreen extends StatefulWidget {
  ProductModel productData;
  String categoryId;
  List<File> images;
  final List<String> selectedOptions;

  OptionalsPriceScreen({
    Key? key,
    required this.productData,
    required this.categoryId,
    required this.images,
    required this.selectedOptions,
  }) : super(key: key);

  @override
  State<OptionalsPriceScreen> createState() => _OptionalsPriceScreenState();
}

class _OptionalsPriceScreenState extends State<OptionalsPriceScreen> {
  Map<String, GlobalKey<_OptionalPriceAndQuantityState>> optionalPriceKeys = {};
  bool isSubmitting = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initializeOptionalPriceKeys();
  }

  void initializeOptionalPriceKeys() {
    for (var option in widget.selectedOptions) {
      optionalPriceKeys[option] = GlobalKey<_OptionalPriceAndQuantityState>();
    }
  }

  Future<List<String>> _uploadImages(String productId) async {
    List<String> imageUrls = [];
    FirebaseStorage storage = FirebaseStorage.instance;

    for (int i = 0; i < widget.images.length; i++) {
      String fileName = 'product_${productId}_$i.jpg';
      Reference ref = storage.ref().child('products/$productId/$fileName');
      UploadTask uploadTask = ref.putFile(widget.images[i]);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }

    return imageUrls;
  }

  bool validateAllFields() {
    bool isValid = _formKey.currentState?.validate() ?? false;
    optionalPriceKeys.forEach((_, key) {
      if (key.currentState?.validate() == false) {
        isValid = false;
      }
    });
    return isValid;
  }

  Future<void> saveDataToFirebase() async {
    if (!validateAllFields()) {
      showSnackBar(context, 'Please fill all the fields');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Generate a unique product ID if not already set
      String productId = widget.productData.productId.isNotEmpty
          ? widget.productData.productId
          : 'Product-ID-${Uuid().v4()}';

      // Upload images and get their URLs
      List<String> imageUrls = await _uploadImages(productId);

      // Prepare variations data
      Map<String, ProductVariant> variations = {};
      for (var option in widget.selectedOptions) {
        final state = optionalPriceKeys[option]!.currentState!;
        variations[option] = ProductVariant(
          discount: double.tryParse(state._discountController.text) ?? 0,
          mrp: double.tryParse(state._mrpController.text) ?? 0,
          price: double.tryParse(state._itemPriceController.text) ?? 0,
          stockQuantity: int.tryParse(state._quantityController.text) ?? 0,
          sku: '${productId}-${option.replaceAll(' ', '-').toLowerCase()}',
        );
      }

      // Prepare product data
      Map<String, dynamic> productData = widget.productData.toFirestore();
      productData['productId'] = productId;
      productData['variations'] =
          variations.map((key, value) => MapEntry(key, value.toMap()));
      productData['imageUrls'] = imageUrls;

      // Save product data to Firestore
      await firestore.collection('products').doc(productId).set(productData);

      // Update store data
      await firestore
          .collection('Stores')
          .doc(widget.productData.storeId)
          .update({'totalProducts': FieldValue.increment(1)});

      // Update category data
      await firestore
          .collection('Stores')
          .doc(widget.productData.storeId)
          .collection('categories')
          .doc(widget.categoryId)
          .update({
        'totalProducts': FieldValue.increment(1),
        'productIds': FieldValue.arrayUnion([productId])
      });
      showSnackBar(context, 'Product added successfully');
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      print('Error saving data: $e');
      showSnackBar(context, 'Error saving data. Please try again.');
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
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
                          icon: Icon(Icons.arrow_back_ios_new,
                              color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Price To Your Optionals',
                      style: TextStyle(fontSize: 32.sp, color: Colors.black),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'All the optional will have the default pricing entered while adding product.',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: hexToColor('#636363'),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 235.w,
                        height: 70.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 50.h,
                              width: 50.w,
                              margin: EdgeInsets.only(left: 10.w),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'Add Optional',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 17.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Dash(
                direction: Axis.horizontal,
                length: 600.w,
                dashLength: 10,
                dashColor: hexToColor('#848484'),
              ),
              SizedBox(height: 30.h),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.selectedOptions.length,
                  itemBuilder: (context, index) {
                    String option = widget.selectedOptions[index];
                    return OptionalPriceAndQuantity(
                      key: optionalPriceKeys[option],
                      title: option,
                      onDeletePressed: () {
                        setState(() {
                          widget.selectedOptions.remove(option);
                          optionalPriceKeys.remove(option);
                        });
                      },
                    );
                  },
                ),
              ),
              Center(
                child: isSubmitting
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 15.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              hexToColor('#2B2B2B')),
                        ),
                      )
                    : GestureDetector(
                        onTap: saveDataToFirebase,
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
                              'Confirm',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionalPriceAndQuantity extends StatefulWidget {
  final String title;
  final VoidCallback onDeletePressed;

  OptionalPriceAndQuantity({
    Key? key,
    required this.title,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  State<OptionalPriceAndQuantity> createState() =>
      _OptionalPriceAndQuantityState();
}

class _OptionalPriceAndQuantityState extends State<OptionalPriceAndQuantity> {
  TextEditingController _discountController = TextEditingController();
  TextEditingController _mrpController = TextEditingController();
  TextEditingController _itemPriceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  bool _isExpanded = false;
  final _formKey = GlobalKey<FormState>();

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

  bool validate() {
    return _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedShape: InputBorder.none,
      shape: InputBorder.none,
      onExpansionChanged: (value) {
        setState(() {
          _isExpanded = value;
        });
      },
      title: Container(
        margin: EdgeInsets.only(left: 16.0),
        child: Text(
          widget.title,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 23.sp,
          ),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 35.h,
            width: 115.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              _isExpanded ? 'Hide' : 'Price',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: hexToColor('#FFFFFF'),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: hexToColor('#FF0000'),
            ),
            onPressed: widget.onDeletePressed,
          ),
        ],
      ),
      children: [
        SizedBox(height: 20.h),
        Container(
          padding: EdgeInsets.only(left: 45.w, right: 10.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          prefixIconConstraints: BoxConstraints(minWidth: 30),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: hexToColor('#848484')),
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            setState(() {
                              _discountController.text = '0';
                            });
                            return null; // Allow empty discount (0%)
                          }
                          final double? discount = double.tryParse(value);
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
                          prefixIconConstraints: BoxConstraints(minWidth: 30),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: hexToColor('#848484')),
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the MRP';
                          }
                          final double? mrp = double.tryParse(value);
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
                          prefixIconConstraints: BoxConstraints(minWidth: 30),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: hexToColor('#848484')),
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                Row(
                  children: [
                    SizedBox(
                      width: 300.w,
                      child: TextFormField(
                        controller: _quantityController,
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
                            borderRadius: BorderRadius.circular(20.r),
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
                          final int? stockQuantity = int.tryParse(value);
                          if (stockQuantity == null || stockQuantity < 0) {
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
        ),
      ],
    );
  }
}
