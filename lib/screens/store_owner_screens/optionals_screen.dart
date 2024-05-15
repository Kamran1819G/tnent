import 'package:flutter/material.dart';
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
                              }
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
                              }
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
                  Navigator.pop(context);
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

  const SizeTabView({
    Key? key,
    required this.sizeTabController,
    required this.selectedSizes,
    required this.onSizeSelected,
  }) : super(key: key);

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
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                FilterChip(
                  label: Text(
                    'XS',
                    style: TextStyle(
                      color: selectedSizes.contains('XS')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('XS'),
                  onSelected: (value) {
                    onSizeSelected('XS');
                  },
                ),
                FilterChip(
                  label: Text(
                    'S',
                    style: TextStyle(
                      color: selectedSizes.contains('S')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('S'),
                  onSelected: (value) {
                    onSizeSelected('S');
                  },
                ),
                FilterChip(
                  label: Text(
                    'M',
                    style: TextStyle(
                      color: selectedSizes.contains('M')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('M'),
                  onSelected: (value) {
                    onSizeSelected('M');
                  },
                ),
                FilterChip(
                  label: Text(
                    'L',
                    style: TextStyle(
                      color: selectedSizes.contains('L')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('L'),
                  onSelected: (value) {
                    onSizeSelected('L');
                  },
                ),
                FilterChip(
                  label: Text(
                    'XL',
                    style: TextStyle(
                      color: selectedSizes.contains('XL')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('XL'),
                  onSelected: (value) {
                    onSizeSelected('XL');
                  },
                ),
              ],
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                FilterChip(
                  label: Text(
                    '20',
                    style: TextStyle(
                      color: selectedSizes.contains('20')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('20'),
                  onSelected: (value) {
                    onSizeSelected('20');
                  },
                ),
                FilterChip(
                  label: Text(
                    '22',
                    style: TextStyle(
                      color: selectedSizes.contains('22')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('22'),
                  onSelected: (value) {
                    onSizeSelected('22');
                  },
                ),
                FilterChip(
                  label: Text(
                    '24',
                    style: TextStyle(
                      color: selectedSizes.contains('24')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('24'),
                  onSelected: (value) {
                    onSizeSelected('24');
                  },
                ),
                FilterChip(
                  label: Text(
                    '26',
                    style: TextStyle(
                      color: selectedSizes.contains('26')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('26'),
                  onSelected: (value) {
                    onSizeSelected('26');
                  },
                ),
                FilterChip(
                  label: Text(
                    '28',
                    style: TextStyle(
                      color: selectedSizes.contains('28')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('28'),
                  onSelected: (value) {
                    onSizeSelected('28');
                  },
                ),
                FilterChip(
                  label: Text(
                    '30',
                    style: TextStyle(
                      color: selectedSizes.contains('30')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('30'),
                  onSelected: (value) {
                    onSizeSelected('30');
                  },
                ),
                FilterChip(
                  label: Text(
                    '32',
                    style: TextStyle(
                      color: selectedSizes.contains('32')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('32'),
                  onSelected: (value) {
                    onSizeSelected('32');
                  },
                ),
                FilterChip(
                  label: Text(
                    '34',
                    style: TextStyle(
                      color: selectedSizes.contains('34')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('34'),
                  onSelected: (value) {
                    onSizeSelected('34');
                  },
                ),
                FilterChip(
                  label: Text(
                    '36',
                    style: TextStyle(
                      color: selectedSizes.contains('36')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('36'),
                  onSelected: (value) {
                    onSizeSelected('36');
                  },
                ),
              ],
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                FilterChip(
                  label: Text(
                    'US 5',
                    style: TextStyle(
                      color: selectedSizes.contains('US 5')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('US 5'),
                  onSelected: (value) {
                    onSizeSelected('US 5');
                  },
                ),
                FilterChip(
                  label: Text(
                    'US 6',
                    style: TextStyle(
                      color: selectedSizes.contains('US 6')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('US 6'),
                  onSelected: (value) {
                    onSizeSelected('US 6');
                  },
                ),
                FilterChip(
                  label: Text(
                    'US 7',
                    style: TextStyle(
                      color: selectedSizes.contains('US 7')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('US 7'),
                  onSelected: (value) {
                    onSizeSelected('US 7');
                  },
                ),
                FilterChip(
                  label: Text(
                    'US 8',
                    style: TextStyle(
                      color: selectedSizes.contains('US 8')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('US 8'),
                  onSelected: (value) {
                    onSizeSelected('US 8');
                  },
                ),
                FilterChip(
                  label: Text(
                    'US 9',
                    style: TextStyle(
                      color: selectedSizes.contains('US 9')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('US 9'),
                  onSelected: (value) {
                    onSizeSelected('US 9');
                  },
                ),
                FilterChip(
                  label: Text(
                    'US 10',
                    style: TextStyle(
                      color: selectedSizes.contains('US 10')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedSizes.contains('US 10'),
                  onSelected: (value) {
                    onSizeSelected('US 10');
                  },
                ),
              ],
            ),
          ],
        )),
      ],
    );
  }
}

class WeightTabView extends StatelessWidget {
  final TabController weightTabController;
  final List<String> selectedWeights;
  final Function(String) onWeightSelected;

  const WeightTabView({
    Key? key,
    required this.weightTabController,
    required this.selectedWeights,
    required this.onWeightSelected,
  }) : super(key: key);

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
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                FilterChip(
                  label: Text(
                    '50g',
                    style: TextStyle(
                      color: selectedWeights.contains('50g')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedWeights.contains('50g'),
                  onSelected: (value) {
                    onWeightSelected('50g');
                  },
                ),
                FilterChip(
                  label: Text(
                    '100g',
                    style: TextStyle(
                      color: selectedWeights.contains('100g')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedWeights.contains('100g'),
                  onSelected: (value) {
                    onWeightSelected('100g');
                  },
                ),
                FilterChip(
                  label: Text(
                    '200g',
                    style: TextStyle(
                      color: selectedWeights.contains('200g')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedWeights.contains('200g'),
                  onSelected: (value) {
                    onWeightSelected('200g');
                  },
                ),
                FilterChip(
                  label: Text(
                    '500g',
                    style: TextStyle(
                      color: selectedWeights.contains('500g')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedWeights.contains('500g'),
                  onSelected: (value) {
                    onWeightSelected('500g');
                  },
                ),
              ],
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                FilterChip(
                  label: Text(
                    '1kg',
                    style: TextStyle(
                      color: selectedWeights.contains('1kg')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedWeights.contains('1kg'),
                  onSelected: (value) {
                    onWeightSelected('1kg');
                  },
                ),
                FilterChip(
                  label: Text(
                    '2kg',
                    style: TextStyle(
                      color: selectedWeights.contains('2kg')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedWeights.contains('2kg'),
                  onSelected: (value) {
                    onWeightSelected('2kg');
                  },
                ),
                FilterChip(
                  label: Text(
                    '5kg',
                    style: TextStyle(
                      color: selectedWeights.contains('5kg')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedWeights.contains('5kg'),
                  onSelected: (value) {
                    onWeightSelected('5kg');
                  },
                ),
                FilterChip(
                  label: Text(
                    '10kg',
                    style: TextStyle(
                      color: selectedWeights.contains('10kg')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedWeights.contains('10kg'),
                  onSelected: (value) {
                    onWeightSelected('10kg');
                  },
                ),
              ],
            ),
          ],
        )),
      ],
    );
  }
}

class VolumeTabView extends StatelessWidget {
  final TabController volumeTabController;
  final List<String> selectedVolumes;
  final Function(String) onVolumeSelected;

  const VolumeTabView({
    Key? key,
    required this.volumeTabController,
    required this.selectedVolumes,
    required this.onVolumeSelected,
  }) : super(key: key);

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
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                FilterChip(
                  label: Text(
                    '50ml',
                    style: TextStyle(
                      color: selectedVolumes.contains('50ml')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedVolumes.contains('50ml'),
                  onSelected: (value) {
                    onVolumeSelected('50ml');
                  },
                ),
                FilterChip(
                  label: Text(
                    '100ml',
                    style: TextStyle(
                      color: selectedVolumes.contains('100ml')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedVolumes.contains('100ml'),
                  onSelected: (value) {
                    onVolumeSelected('100ml');
                  },
                ),
                FilterChip(
                  label: Text(
                    '200ml',
                    style: TextStyle(
                      color: selectedVolumes.contains('200ml')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedVolumes.contains('200ml'),
                  onSelected: (value) {
                    onVolumeSelected('200ml');
                  },
                ),
                FilterChip(
                  label: Text(
                    '500ml',
                    style: TextStyle(
                      color: selectedVolumes.contains('500ml')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedVolumes.contains('500ml'),
                  onSelected: (value) {
                    onVolumeSelected('500ml');
                  },
                ),
              ],
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                FilterChip(
                  label: Text(
                    '1L',
                    style: TextStyle(
                      color: selectedVolumes.contains('1L')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedVolumes.contains('1L'),
                  onSelected: (value) {
                    onVolumeSelected('1L');
                  },
                ),
                FilterChip(
                  label: Text(
                    '2L',
                    style: TextStyle(
                      color: selectedVolumes.contains('2L')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedVolumes.contains('2L'),
                  onSelected: (value) {
                    onVolumeSelected('2L');
                  },
                ),
                FilterChip(
                  label: Text(
                    '5L',
                    style: TextStyle(
                      color: selectedVolumes.contains('5L')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedVolumes.contains('5L'),
                  onSelected: (value) {
                    onVolumeSelected('5L');
                  },
                ),
                FilterChip(
                  label: Text(
                    '10L',
                    style: TextStyle(
                      color: selectedVolumes.contains('10L')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  checkmarkColor: Colors.white,
                  selectedColor: Theme.of(context).primaryColor,
                  selected: selectedVolumes.contains('10L'),
                  onSelected: (value) {
                    onVolumeSelected('10L');
                  },
                ),
              ],
            ),
          ],
        )),
      ],
    );
  }
}

class BakeryTabView extends StatelessWidget {
  final TabController bakeryTabController;
  final List<String> selectedBakeries;
  final Function(String) onBakerySelected;

  const BakeryTabView({
    Key? key,
    required this.bakeryTabController,
    required this.selectedBakeries,
    required this.onBakerySelected,
  }) : super(key: key);

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
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  FilterChip(
                    label: Text(
                      '1 Pound',
                      style: TextStyle(
                        color: selectedBakeries.contains('1 Pound')
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    checkmarkColor: Colors.white,
                    selectedColor: Theme.of(context).primaryColor,
                    selected: selectedBakeries.contains('1 Pound'),
                    onSelected: (value) {
                      onBakerySelected('1 Pound');
                    },
                  ),
                  FilterChip(
                    label: Text(
                      '2 Pound',
                      style: TextStyle(
                        color: selectedBakeries.contains('2 Pound')
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    checkmarkColor: Colors.white,
                    selectedColor: Theme.of(context).primaryColor,
                    selected: selectedBakeries.contains('2 Pound'),
                    onSelected: (value) {
                      onBakerySelected('2 Pound');
                    },
                  ),
                  FilterChip(
                    label: Text(
                      '5 Pound',
                      style: TextStyle(
                        color: selectedBakeries.contains('5 Pound')
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    checkmarkColor: Colors.white,
                    selectedColor: Theme.of(context).primaryColor,
                    selected: selectedBakeries.contains('5 Pound'),
                    onSelected: (value) {
                      onBakerySelected('5 Pound');
                    },
                  ),
                  FilterChip(
                    label: Text(
                      '10 Pound',
                      style: TextStyle(
                        color: selectedBakeries.contains('10 Pound')
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    checkmarkColor: Colors.white,
                    selectedColor: Theme.of(context).primaryColor,
                    selected: selectedBakeries.contains('10 Pound'),
                    onSelected: (value) {
                      onBakerySelected('10 Pound');
                    },
                  ),
                ],
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  FilterChip(
                    label: Text(
                      '50g',
                      style: TextStyle(
                        color: selectedBakeries.contains('50g')
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    checkmarkColor: Colors.white,
                    selectedColor: Theme.of(context).primaryColor,
                    selected: selectedBakeries.contains('50g'),
                    onSelected: (value) {
                      onBakerySelected('50g');
                    },
                  ),
                  FilterChip(
                    label: Text(
                      '100g',
                      style: TextStyle(
                        color: selectedBakeries.contains('100g')
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    checkmarkColor: Colors.white,
                    selectedColor: Theme.of(context).primaryColor,
                    selected: selectedBakeries.contains('100g'),
                    onSelected: (value) {
                      onBakerySelected('100g');
                    },
                  ),
                  FilterChip(
                    label: Text(
                      '200g',
                      style: TextStyle(
                        color: selectedBakeries.contains('200g')
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    checkmarkColor: Colors.white,
                    selectedColor: Theme.of(context).primaryColor,
                    selected: selectedBakeries.contains('200g'),
                    onSelected: (value) {
                      onBakerySelected('200g');
                    },
                  ),
                  FilterChip(
                    label: Text(
                      '500g',
                      style: TextStyle(
                        color: selectedBakeries.contains('500g')
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    checkmarkColor: Colors.white,
                    selectedColor: Theme.of(context).primaryColor,
                    selected: selectedBakeries.contains('500g'),
                    onSelected: (value) {
                      onBakerySelected('500g');
                    },
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

class StorageTabView extends StatelessWidget {
  final TabController storageTabController;
  final List<String> selectedStorages;
  final Function(String) onStorageSelected;

  const StorageTabView({
    Key? key,
    required this.storageTabController,
    required this.selectedStorages,
    required this.onStorageSelected,
  }) : super(key: key);

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
          child: TabBarView(
            controller: storageTabController,
            children: [
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  FilterChip(
                    label: Text('8GB + 64GB',
                      style: TextStyle(
                        color: selectedStorages.contains('8GB + 64GB')
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    checkmarkColor: Colors.white,
                    selectedColor: Theme.of(context).primaryColor,
                    selected: selectedStorages.contains('8GB + 64GB'),
                    onSelected: (value) {
                      onStorageSelected('8GB + 64GB');
                    },
                  ),
                  FilterChip(
                    label: Text('8GB + 128GB',
                      style: TextStyle(
                        color: selectedStorages.contains('8GB + 128GB')
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    checkmarkColor: Colors.white,
                    selectedColor: Theme.of(context).primaryColor,
                    selected: selectedStorages.contains('8GB + 128GB'),
                    onSelected: (value) {
                      onStorageSelected('8GB + 128GB');
                    },
                  ),
                  FilterChip(
                    label: Text('8GB + 256GB',
                      style: TextStyle(
                        color: selectedStorages.contains('8GB + 256GB')
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    checkmarkColor: Colors.white,
                    selectedColor: Theme.of(context).primaryColor,
                    selected: selectedStorages.contains('8GB + 256GB'),
                    onSelected: (value) {
                      onStorageSelected('8GB + 256GB');
                    },
                  ),
                  FilterChip(
                    label: Text('8GB + 512GB',
                      style: TextStyle(
                        color: selectedStorages.contains('8GB + 512GB')
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    checkmarkColor: Colors.white,
                    selectedColor: Theme.of(context).primaryColor,
                    selected: selectedStorages.contains('8GB + 512GB'),
                    onSelected: (value) {
                      onStorageSelected('8GB + 512GB');
                    },
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
