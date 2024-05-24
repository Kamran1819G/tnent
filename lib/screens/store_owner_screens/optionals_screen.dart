import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:flutter_dash/flutter_dash.dart';

class OptionalsScreen extends StatefulWidget {
  const OptionalsScreen({super.key});

  @override
  State<OptionalsScreen> createState() => _OptionalsScreenState();
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
            SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Option Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
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
                        fontWeight: FontWeight.w900,
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
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
                              }),
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
                              }),
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
                              }),
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
                              }),
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
                          fontSize: 16.0),
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
  String title;
  Color color;

  OptionTab(this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        title,
      ),
    );
  }
}

class SizeTabView extends StatelessWidget {
  final TabController sizeTabController;
  final List<String> selectedSizes;
  final Function(String) onSizeSelected;

  SizeTabView({
    Key? key,
    required this.sizeTabController,
    required this.selectedSizes,
    required this.onSizeSelected,
  }) : super(key: key);

  final List<String> topwearSizes = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
  ];

  final List<String> bottomwearSizes = [
    '20',
    '22',
    '24',
    '26',
    '28',
    '30',
    '32',
    '34',
    '36',
  ];

  final List<String> footwearSizes = [
    'US 5',
    'US 6',
    'US 7',
    'US 8',
    'US 9',
    'US 10',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Size',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 20),
        TabBar(
          controller: sizeTabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          unselectedLabelColor: hexToColor('#737373'),
          labelColor: Colors.white,
          indicator: BoxDecoration(
            color: hexToColor('#343434'),
            borderRadius: BorderRadius.circular(12),
          ),
          labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
          labelStyle: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w900,
          ),
          indicatorSize: TabBarIndicatorSize.label,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          dividerColor: Colors.transparent,
          tabs: <Widget>[
            OptionTab('Topwear', hexToColor('#343434')),
            OptionTab('Bottomwear', hexToColor('#343434')),
            OptionTab('Footwear', hexToColor('#343434')),
          ],
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
            controller: sizeTabController,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    topwearSizes.length,
                    (index) => CheckboxListTile(
                      title: Text(
                        topwearSizes[index],
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      checkColor: Colors.white,
                      activeColor: Theme.of(context).primaryColor,
                      value: selectedSizes.contains(topwearSizes[index]),
                      onChanged: (value) {
                        onSizeSelected(topwearSizes[index]);
                      },
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    bottomwearSizes.length,
                    (index) => CheckboxListTile(
                      title: Text(
                        bottomwearSizes[index],
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      checkColor: Colors.white,
                      activeColor: Theme.of(context).primaryColor,
                      value: selectedSizes.contains(bottomwearSizes[index]),
                      onChanged: (value) {
                        onSizeSelected(bottomwearSizes[index]);
                      },
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    footwearSizes.length,
                    (index) => CheckboxListTile(
                      title: Text(
                        footwearSizes[index],
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      checkColor: Colors.white,
                      activeColor: Theme.of(context).primaryColor,
                      value: selectedSizes.contains(footwearSizes[index]),
                      onChanged: (value) {
                        onSizeSelected(footwearSizes[index]);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WeightTabView extends StatelessWidget {
  final TabController weightTabController;
  final List<String> selectedWeights;
  final Function(String) onWeightSelected;

  WeightTabView({
    Key? key,
    required this.weightTabController,
    required this.selectedWeights,
    required this.onWeightSelected,
  }) : super(key: key);

  final List<String> gramOptions = [
    '50g',
    '100g',
    '200g',
    '500g',
  ];

  final List<String> kilogramOptions = [
    '1kg',
    '2kg',
    '5kg',
    '10kg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Weight',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 20),
        TabBar(
          controller: weightTabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          unselectedLabelColor: hexToColor('#737373'),
          labelColor: Colors.white,
          indicator: BoxDecoration(
            color: hexToColor('#343434'),
            borderRadius: BorderRadius.circular(12),
          ),
          labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
          labelStyle: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w900,
          ),
          indicatorSize: TabBarIndicatorSize.label,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          dividerColor: Colors.transparent,
          tabs: <Widget>[
            OptionTab('Gram', hexToColor('#343434')),
            OptionTab('Kilogram', hexToColor('#343434')),
          ],
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
            controller: weightTabController,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    gramOptions.length,
                    (index) => CheckboxListTile(
                      title: Text(
                        gramOptions[index],
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      checkColor: Colors.white,
                      activeColor: Theme.of(context).primaryColor,
                      value: selectedWeights.contains(gramOptions[index]),
                      onChanged: (value) {
                        onWeightSelected(gramOptions[index]);
                      },
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    kilogramOptions.length,
                    (index) => CheckboxListTile(
                      title: Text(
                        kilogramOptions[index],
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      checkColor: Colors.white,
                      activeColor: Theme.of(context).primaryColor,
                      value: selectedWeights.contains(kilogramOptions[index]),
                      onChanged: (value) {
                        onWeightSelected(kilogramOptions[index]);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class VolumeTabView extends StatelessWidget {
  final TabController volumeTabController;
  final List<String> selectedVolumes;
  final Function(String) onVolumeSelected;

  VolumeTabView({
    Key? key,
    required this.volumeTabController,
    required this.selectedVolumes,
    required this.onVolumeSelected,
  }) : super(key: key);

  final List<String> literOptions = [
    '1L',
    '2L',
    '5L',
    '10L',
  ];

  final List<String> mililiterOptions = [
    '50ml',
    '100ml',
    '200ml',
    '500ml',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Volume',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 20),
        TabBar(
          controller: volumeTabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          unselectedLabelColor: hexToColor('#737373'),
          labelColor: Colors.white,
          indicator: BoxDecoration(
            color: hexToColor('#343434'),
            borderRadius: BorderRadius.circular(12),
          ),
          labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
          labelStyle: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w900,
          ),
          indicatorSize: TabBarIndicatorSize.label,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          dividerColor: Colors.transparent,
          tabs: <Widget>[
            OptionTab('Mililiter', hexToColor('#343434')),
            OptionTab('Liter', hexToColor('#343434')),
          ],
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
            controller: volumeTabController,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    mililiterOptions.length,
                    (index) => CheckboxListTile(
                      title: Text(
                        mililiterOptions[index],
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      checkColor: Colors.white,
                      activeColor: Theme.of(context).primaryColor,
                      value: selectedVolumes.contains(mililiterOptions[index]),
                      onChanged: (value) {
                        onVolumeSelected(mililiterOptions[index]);
                      },
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    literOptions.length,
                    (index) => CheckboxListTile(
                      title: Text(
                        literOptions[index],
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      checkColor: Colors.white,
                      activeColor: Theme.of(context).primaryColor,
                      value: selectedVolumes.contains(literOptions[index]),
                      onChanged: (value) {
                        onVolumeSelected(literOptions[index]);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BakeryTabView extends StatelessWidget {
  final TabController bakeryTabController;
  final List<String> selectedBakeries;
  final Function(String) onBakerySelected;

  BakeryTabView({
    Key? key,
    required this.bakeryTabController,
    required this.selectedBakeries,
    required this.onBakerySelected,
  }) : super(key: key);

  final List<String> poundOptions = [
    '1 Pound',
    '2 Pound',
    '5 Pound',
    '10 Pound',
  ];

  final List<String> gramOptions = [
    '50g',
    '100g',
    '200g',
    '500g',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Bakery',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 20),
        TabBar(
          controller: bakeryTabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          unselectedLabelColor: hexToColor('#737373'),
          labelColor: Colors.white,
          indicator: BoxDecoration(
            color: hexToColor('#343434'),
            borderRadius: BorderRadius.circular(12),
          ),
          labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
          labelStyle: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w900,
          ),
          indicatorSize: TabBarIndicatorSize.label,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          dividerColor: Colors.transparent,
          tabs: <Widget>[
            OptionTab('Pound', hexToColor('#343434')),
            OptionTab('Gram/KG', hexToColor('#343434')),
          ],
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
            controller: bakeryTabController,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    poundOptions.length,
                    (index) => CheckboxListTile(
                      title: Text(
                        poundOptions[index],
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      checkColor: Colors.white,
                      activeColor: Theme.of(context).primaryColor,
                      value: selectedBakeries.contains(poundOptions[index]),
                      onChanged: (value) {
                        onBakerySelected(poundOptions[index]);
                      },
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    gramOptions.length,
                    (index) => CheckboxListTile(
                      title: Text(
                        gramOptions[index],
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      checkColor: Colors.white,
                      activeColor: Theme.of(context).primaryColor,
                      value: selectedBakeries.contains(gramOptions[index]),
                      onChanged: (value) {
                        onBakerySelected(gramOptions[index]);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StorageTabView extends StatelessWidget {
  final TabController storageTabController;
  final List<String> selectedStorages;
  final Function(String) onStorageSelected;

  StorageTabView({
    Key? key,
    required this.storageTabController,
    required this.selectedStorages,
    required this.onStorageSelected,
  }) : super(key: key);

  final List<String> capacityOptions = [
    '8GB + 64GB',
    '8GB + 128GB',
    '8GB + 256GB',
    '12GB + 128GB',
    '12GB + 256GB',
    '12GB + 512GB',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Storage',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 20),
        TabBar(
          controller: storageTabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          unselectedLabelColor: hexToColor('#737373'),
          labelColor: Colors.white,
          indicator: BoxDecoration(
            color: hexToColor('#343434'),
            borderRadius: BorderRadius.circular(12),
          ),
          labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
          labelStyle: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w900,
          ),
          indicatorSize: TabBarIndicatorSize.label,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          dividerColor: Colors.transparent,
          tabs: <Widget>[
            OptionTab('Capacity', hexToColor('#343434')),
          ],
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
          child: TabBarView(controller: storageTabController, children: [
            SingleChildScrollView(
              child: Column(
                children: List.generate(
                  capacityOptions.length,
                  (index) => CheckboxListTile(
                    title: Text(
                      capacityOptions[index],
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    checkColor: Colors.white,
                    activeColor: Theme.of(context).primaryColor,
                    value: selectedStorages.contains(capacityOptions[index]),
                    onChanged: (value) {
                      onStorageSelected(capacityOptions[index]);
                    },
                  ),
                ),
              ),
            )
          ]),
        ),
      ],
    );
  }
}

class OptionalsPriceScreen extends StatefulWidget {
  final List<String> selectedSizes;
  final List<String> selectedWeights;
  final List<String> selectedVolumes;
  final List<String> selectedBakeries;
  final List<String> selectedStorages;

  OptionalsPriceScreen({
    Key? key,
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
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
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
                    title: items[index],
                    onDeletePressed: () {
                      setState(() {
                        items.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
            Center(
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
                        fontSize: 16.0),
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
    double discount = double.parse(_discountController.text);
    double mrp = double.parse(_mrpController.text);
    double itemPrice = double.parse(_itemPriceController.text);

    if (discount != 0 && mrp != 0) {
      itemPrice = mrp - (mrp * discount / 100);
      _itemPriceController.text = itemPrice.toStringAsFixed(2);
    } else if (itemPrice != 0 && mrp != 0) {
      discount = ((mrp - itemPrice) / mrp) * 100;
      _discountController.text = discount.toStringAsFixed(2);
    } else if (itemPrice != 0 && discount != 0) {
      mrp = itemPrice / (1 - discount / 100);
      _mrpController.text = mrp.toStringAsFixed(2);
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
