import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tnennt/models/product_model.dart';

class OptionalsScreen extends StatefulWidget {
  final String productId;
  final String productCategory;

  const OptionalsScreen({
    Key? key,
    required this.productId,
    required this.productCategory,
  }) : super(key: key);

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
    switch (widget.productCategory.toLowerCase()) {
      case 'clothing':
        return 3; // Topwear, Bottomwear, Footwear
      case 'bakery':
        return 2; // Pound, Gram/KG
      case 'electronic':
        return 1; // Capacity
      default:
        return 1;
    }
  }

  String getCategoryTitle() {
    switch (widget.productCategory.toLowerCase()) {
      case 'clothing':
        return 'Add Size';
      case 'bakery':
        return 'Add Bakery';
      case 'electronic':
        return 'Add Storage';
      default:
        return 'Add Option';
    }
  }

  List<Widget> getTabs() {
    switch (widget.productCategory.toLowerCase()) {
      case 'clothing':
        return [
          OptionTab('Topwear', hexToColor('#343434')),
          OptionTab('Bottomwear', hexToColor('#343434')),
          OptionTab('Footwear', hexToColor('#343434')),
        ];
      case 'bakery':
        return [
          OptionTab('Pound', hexToColor('#343434')),
          OptionTab('Gram/KG', hexToColor('#343434')),
        ];
      case 'electronic':
        return [OptionTab('Capacity', hexToColor('#343434'))];
      default:
        return [OptionTab('Option', hexToColor('#343434'))];
    }
  }

  List<Widget> getTabViews() {
    switch (widget.productCategory.toLowerCase()) {
      case 'clothing':
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
      case 'bakery':
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
      case 'electronic':
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
                        'Optionals'.toUpperCase(),
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
            SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getCategoryTitle(),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    TabBar(
                      controller: optionTabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      unselectedLabelColor: hexToColor('#737373'),
                      labelColor: Colors.white,
                      indicator: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      dividerColor: Colors.transparent,
                      tabs: getTabs(),
                    ),
                    SizedBox(height: 20),
                    Dash(
                      direction: Axis.horizontal,
                      length: MediaQuery.of(context).size.width * 0.9,
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
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OptionalsPriceScreen(
                        productId: widget.productId,
                        selectedOptions: selectedOptions,
                      ),
                    ),
                  );
                },
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
        borderRadius: BorderRadius.circular(12.0),
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
                fontSize: 16.0,
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
  final String productId;
  final List<String> selectedOptions;


  const OptionalsPriceScreen({
    Key? key,
    required this.productId,
    required this.selectedOptions,
  }) : super(key: key);

  @override
  State<OptionalsPriceScreen> createState() => _OptionalsPriceScreenState();
}

class _OptionalsPriceScreenState extends State<OptionalsPriceScreen> {
  Map<String, GlobalKey<_OptionalPriceAndQuantityState>> optionalPriceKeys = {};
  bool isLoading = true;
  Map<String, dynamic>? productData;

  @override
  void initState() {
    super.initState();
    initializeOptionalPriceKeys();
    fetchProductData();
  }

  void initializeOptionalPriceKeys() {
    for (var option in widget.selectedOptions) {
      optionalPriceKeys[option] = GlobalKey<_OptionalPriceAndQuantityState>();
    }
  }

  Future<void> fetchProductData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();
      if (doc.exists) {
        setState(() {
          productData = doc.data() as Map<String, dynamic>?;
          isLoading = false;
        });
      } else {
        print('Product not found');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching product data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> saveDataToFirebase() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Map<String, ProductVariant> variations = {};

    for (var option in widget.selectedOptions) {
      final state = optionalPriceKeys[option]!.currentState!;
      variations[option] = ProductVariant(
        discount: double.tryParse(state._discountController.text) ?? 0,
        mrp: double.tryParse(state._mrpController.text) ?? 0,
        price: double.tryParse(state._itemPriceController.text) ?? 0,
        stockQuantity: int.tryParse(state._quantityController.text) ?? 0,
        sku: '${widget.productId}-${option.replaceAll(' ', '-').toLowerCase()}',
      );
    }

    Map<String, dynamic> productData = {
      'variations': variations.map((key, value) => MapEntry(key, value.toMap())),
    };

    try {
      await firestore
          .collection('products')
          .doc(widget.productId)
          .set(productData, SetOptions(merge: true));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Product Added Successfully')));
      Navigator.pop(context);
    } catch (e) {
      print('Error saving data: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error saving data')));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  Text(
                    'Add Price To Your Optionals',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'All the optional will have the default pricing entered while adding product.',
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
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      width: 175,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
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
                            child: Icon(Icons.add, color: Colors.white),
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
            SizedBox(height: 20),
            Dash(
              direction: Axis.horizontal,
              length: MediaQuery.of(context).size.width,
              dashLength: 10,
              dashColor: hexToColor('#848484'),
            ),
            SizedBox(height: 20),
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
              child: GestureDetector(
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

  void _calculateValues() {
    double discount = double.tryParse(_discountController.text) ?? 0;
    double mrp = double.tryParse(_mrpController.text) ?? 0;

    if (discount != 0 && mrp != 0) {
      double itemPrice = mrp - (mrp * discount / 100);
      setState(() {
        _itemPriceController.text = itemPrice.toStringAsFixed(2);
      });
    } else {
      setState(() {
        _itemPriceController.text = '';
      });
    }
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
            fontSize: 16.0,
          ),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _isExpanded ? 'Hide' : 'Price',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: hexToColor('#FFFFFF'),
              ),
            ),
          ),
          SizedBox(width: 8),
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
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
                    width: MediaQuery.of(context).size.width * 0.3,
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
                    width: MediaQuery.of(context).size.width * 0.3,
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
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    width: 175,
                    child: TextField(
                      controller: _quantityController,
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
      ],
    );
  }
}
