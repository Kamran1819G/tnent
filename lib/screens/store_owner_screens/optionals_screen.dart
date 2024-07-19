import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OptionalsScreen extends StatefulWidget {
  final String productId;

  const OptionalsScreen({Key? key, required this.productId}) : super(key: key);

  @override
  _OptionalsScreenState createState() => _OptionalsScreenState();
}

class _OptionalsScreenState extends State<OptionalsScreen>
    with TickerProviderStateMixin {
  late TabController optionTypeTabController;
  late TabController sizeTabController;
  late TabController weightTabController;
  late TabController volumeTabController;
  late TabController bakeryTabController;
  late TabController storageTabController;

  List<String> selectedSizes = [];
  List<String> selectedWeights = [];
  List<String> selectedVolumes = [];
  List<String> selectedBakeries = [];
  List<String> selectedStorages = [];

  @override
  void initState() {
    super.initState();
    optionTypeTabController = TabController(length: 5, vsync: this);
    sizeTabController = TabController(length: 3, vsync: this);
    weightTabController = TabController(length: 2, vsync: this);
    volumeTabController = TabController(length: 2, vsync: this);
    bakeryTabController = TabController(length: 2, vsync: this);
    storageTabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    optionTypeTabController.dispose();
    sizeTabController.dispose();
    weightTabController.dispose();
    volumeTabController.dispose();
    bakeryTabController.dispose();
    storageTabController.dispose();
    super.dispose();
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
            SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Option Type',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    TabBar(
                      controller: optionTypeTabController,
                      physics: NeverScrollableScrollPhysics(),
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
                      tabs: <Widget>[
                        OptionTab('Size', hexToColor('#343434')),
                        OptionTab('Weight', hexToColor('#343434')),
                        OptionTab('Volume', hexToColor('#343434')),
                        OptionTab('Bakery', hexToColor('#343434')),
                        OptionTab('Storage', hexToColor('#343434')),
                      ],
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        controller: optionTypeTabController,
                        children: [
                          SizeTabView(
                            sizeTabController: sizeTabController,
                            selectedSizes: selectedSizes,
                            onSizeSelected: (size) {
                              setState(() {
                                if (selectedSizes.contains(size)) {
                                  selectedSizes.remove(size);
                                } else {
                                  selectedSizes.add(size);
                                }
                              });
                            },
                          ),
                          WeightTabView(
                            weightTabController: weightTabController,
                            selectedWeights: selectedWeights,
                            onWeightSelected: (weight) {
                              setState(() {
                                if (selectedWeights.contains(weight)) {
                                  selectedWeights.remove(weight);
                                } else {
                                  selectedWeights.add(weight);
                                }
                              });
                            },
                          ),
                          VolumeTabView(
                            volumeTabController: volumeTabController,
                            selectedVolumes: selectedVolumes,
                            onVolumeSelected: (volume) {
                              setState(() {
                                if (selectedVolumes.contains(volume)) {
                                  selectedVolumes.remove(volume);
                                } else {
                                  selectedVolumes.add(volume);
                                }
                              });
                            },
                          ),
                          BakeryTabView(
                            bakeryTabController: bakeryTabController,
                            selectedBakeries: selectedBakeries,
                            onBakerySelected: (bakery) {
                              setState(() {
                                if (selectedBakeries.contains(bakery)) {
                                  selectedBakeries.remove(bakery);
                                } else {
                                  selectedBakeries.add(bakery);
                                }
                              });
                            },
                          ),
                          StorageTabView(
                            storageTabController: storageTabController,
                            selectedStorages: selectedStorages,
                            onStorageSelected: (storage) {
                              setState(() {
                                if (selectedStorages.contains(storage)) {
                                  selectedStorages.remove(storage);
                                } else {
                                  selectedStorages.add(storage);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OptionalsPriceScreen(
                        productId: widget.productId,
                        selectedSizes: selectedSizes,
                        selectedWeights: selectedWeights,
                        selectedVolumes: selectedVolumes,
                        selectedBakeries: selectedBakeries,
                        selectedStorages: selectedStorages,
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

class SizeTabView extends StatelessWidget {
  final TabController sizeTabController;
  final List<String> selectedSizes;
  final Function(String) onSizeSelected;

  SizeTabView({
    required this.sizeTabController,
    required this.selectedSizes,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: sizeTabController,
          isScrollable: true,
          tabs: [
            Tab(text: 'Small'),
            Tab(text: 'Medium'),
            Tab(text: 'Large'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: sizeTabController,
            children: [
              _buildSizeList(['S', 'XS']),
              _buildSizeList(['M']),
              _buildSizeList(['L', 'XL', 'XXL']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSizeList(List<String> sizes) {
    return ListView.builder(
      itemCount: sizes.length,
      itemBuilder: (context, index) {
        final size = sizes[index];
        return CheckboxListTile(
          title: Text(size),
          value: selectedSizes.contains(size),
          onChanged: (bool? value) {
            onSizeSelected(size);
          },
        );
      },
    );
  }
}

class WeightTabView extends StatelessWidget {
  final TabController weightTabController;
  final List<String> selectedWeights;
  final Function(String) onWeightSelected;

  WeightTabView({
    required this.weightTabController,
    required this.selectedWeights,
    required this.onWeightSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: weightTabController,
          isScrollable: true,
          tabs: [
            Tab(text: 'Grams'),
            Tab(text: 'Kilograms'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: weightTabController,
            children: [
              _buildWeightList(['100g', '250g', '500g']),
              _buildWeightList(['1kg', '2kg', '5kg']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeightList(List<String> weights) {
    return ListView.builder(
      itemCount: weights.length,
      itemBuilder: (context, index) {
        final weight = weights[index];
        return CheckboxListTile(
          title: Text(weight),
          value: selectedWeights.contains(weight),
          onChanged: (bool? value) {
            onWeightSelected(weight);
          },
        );
      },
    );
  }
}

class VolumeTabView extends StatelessWidget {
  final TabController volumeTabController;
  final List<String> selectedVolumes;
  final Function(String) onVolumeSelected;

  VolumeTabView({
    required this.volumeTabController,
    required this.selectedVolumes,
    required this.onVolumeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: volumeTabController,
          isScrollable: true,
          tabs: [
            Tab(text: 'Milliliters'),
            Tab(text: 'Liters'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: volumeTabController,
            children: [
              _buildVolumeList(['100ml', '250ml', '500ml']),
              _buildVolumeList(['1L', '2L', '5L']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVolumeList(List<String> volumes) {
    return ListView.builder(
      itemCount: volumes.length,
      itemBuilder: (context, index) {
        final volume = volumes[index];
        return CheckboxListTile(
          title: Text(volume),
          value: selectedVolumes.contains(volume),
          onChanged: (bool? value) {
            onVolumeSelected(volume);
          },
        );
      },
    );
  }
}

class BakeryTabView extends StatelessWidget {
  final TabController bakeryTabController;
  final List<String> selectedBakeries;
  final Function(String) onBakerySelected;

  BakeryTabView({
    required this.bakeryTabController,
    required this.selectedBakeries,
    required this.onBakerySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: bakeryTabController,
          isScrollable: true,
          tabs: [
            Tab(text: 'Bread'),
            Tab(text: 'Pastry'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: bakeryTabController,
            children: [
              _buildBakeryList(['White Bread', 'Whole Wheat', 'Sourdough']),
              _buildBakeryList(['Croissant', 'Danish', 'Muffin']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBakeryList(List<String> bakeries) {
    return ListView.builder(
      itemCount: bakeries.length,
      itemBuilder: (context, index) {
        final bakery = bakeries[index];
        return CheckboxListTile(
          title: Text(bakery),
          value: selectedBakeries.contains(bakery),
          onChanged: (bool? value) {
            onBakerySelected(bakery);
          },
        );
      },
    );
  }
}

class StorageTabView extends StatelessWidget {
  final TabController storageTabController;
  final List<String> selectedStorages;
  final Function(String) onStorageSelected;

  StorageTabView({
    required this.storageTabController,
    required this.selectedStorages,
    required this.onStorageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: storageTabController,
          isScrollable: true,
          tabs: [
            Tab(text: 'Storage Options'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: storageTabController,
            children: [
              _buildStorageList(['Refrigerated', 'Frozen', 'Room Temperature']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStorageList(List<String> storages) {
    return ListView.builder(
      itemCount: storages.length,
      itemBuilder: (context, index) {
        final storage = storages[index];
        return CheckboxListTile(
          title: Text(storage),
          value: selectedStorages.contains(storage),
          onChanged: (bool? value) {
            onStorageSelected(storage);
          },
        );
      },
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

class OptionalsPriceScreen extends StatefulWidget {
  final String productId;
  final List<String> selectedSizes;
  final List<String> selectedWeights;
  final List<String> selectedVolumes;
  final List<String> selectedBakeries;
  final List<String> selectedStorages;

  OptionalsPriceScreen({
    Key? key,
    required this.productId,
    required this.selectedSizes,
    required this.selectedWeights,
    required this.selectedVolumes,
    required this.selectedBakeries,
    required this.selectedStorages,
  }) : super(key: key);

  @override
  State<OptionalsPriceScreen> createState() => _OptionalsPriceScreenState();
}

class _OptionalsPriceScreenState extends State<OptionalsPriceScreen> {
  List<String> items = [];
  List<GlobalKey<_OptionalPriceAndQuantityState>> optionalPriceKeys = [];

  @override
  void initState() {

    super.initState();
    items = [
      ...widget.selectedSizes,
      ...widget.selectedWeights,
      ...widget.selectedVolumes,
      ...widget.selectedBakeries,
      ...widget.selectedStorages,
    ];
    optionalPriceKeys = List.generate(items.length, (_) => GlobalKey<_OptionalPriceAndQuantityState>());
  }

  Future<void> saveDataToFirebase() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Map<String, dynamic> productData = {
      'productId': widget.productId,
      'optionals': items.map((item) {
        final index = items.indexOf(item);
        return {
          'title': item,
          'discount': _getControllerValue(index, '_discountController'),
          'mrp': _getControllerValue(index, '_mrpController'),
          'itemPrice': _getControllerValue(index, '_itemPriceController'),
          'quantity': _getControllerValue(index, '_quantityController'),
        };
      }).toList(),
    };

    try {
      await firestore.collection('Products').doc(widget.productId).set(productData, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data saved successfully')));
    } catch (e) {
      print('Error saving data: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving data')));
    }
  }

  String _getControllerValue(int index, String controllerName) {
    final state = (optionalPriceKeys[index].currentState as _OptionalPriceAndQuantityState);
    switch (controllerName) {
      case '_discountController':
        return state._discountController.text;
      case '_mrpController':
        return state._mrpController.text;
      case '_itemPriceController':
        return state._itemPriceController.text;
      case '_quantityController':
        return state._quantityController.text;
      default:
        return '';
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
                        border: Border.all(color: Theme.of(context).primaryColor),
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
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return OptionalPriceAndQuantity(
                    key: optionalPriceKeys[index],
                    title: items[index],
                    onDeletePressed: () {
                      setState(() {
                        items.removeAt(index);
                        optionalPriceKeys.removeAt(index);
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
  State<OptionalPriceAndQuantity> createState() => _OptionalPriceAndQuantityState();
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
