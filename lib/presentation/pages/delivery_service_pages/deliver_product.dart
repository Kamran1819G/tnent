import 'package:flutter/material.dart';
import 'package:tnent/models/location_details_model.dart';
import 'package:tnent/presentation/pages/delivery_service_pages/upload_and_verify_document.dart';
import '../../../core/helpers/color_utils.dart';

class DeliverProduct extends StatefulWidget {
  const DeliverProduct({super.key});

  @override
  State<DeliverProduct> createState() => _DeliverProductState();
}

class _DeliverProductState extends State<DeliverProduct> {
  String _selectedParcelType = '';
  LocationDetails? _pickupDetails;
  LocationDetails? _dropDetails;

  final TextEditingController _pickupLocationController =
      TextEditingController();
  final TextEditingController _dropLocationController = TextEditingController();

  @override
  void dispose() {
    _pickupLocationController.dispose();
    _dropLocationController.dispose();
    super.dispose();
  }

  void _setPickupLocation(LocationDetails pickupDetails) {
    setState(() {
      _pickupDetails = pickupDetails;
      _pickupLocationController.text = pickupDetails.addressLine1;
    });
  }

  void _setDropLocation(LocationDetails dropDetails) {
    setState(() {
      _dropDetails = dropDetails;
      _dropLocationController.text = dropDetails.addressLine1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/delivery_service_bg_1.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    height: 75,
                    padding: EdgeInsets.only(left: 16, right: 8),
                    child: Row(
                      children: [
                        Image.asset('assets/black_tnent_logo.png',
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
                  Container(
                    alignment: Alignment(0, 0.1),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Text(
                      'Enter Your Delivery Address & Parcel Details',
                      style: TextStyle(
                        color: hexToColor('#2A2A2A'),
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/delivery_service_bg_2.png'),
                              fit: BoxFit.fill,
                              colorFilter: ColorFilter.mode(
                                  Colors.white.withOpacity(0.1),
                                  BlendMode.softLight),
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 150,
                              width: 20,
                              margin: EdgeInsets.only(left: 16, right: 8),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/src_to_dest_graphic.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pickup Details',
                                    style: TextStyle(
                                      color: hexToColor('#2A2A2A'),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: TextField(
                                          controller: _pickupLocationController,
                                          cursorColor:
                                              Theme.of(context).primaryColor,
                                          style: TextStyle(
                                            fontFamily: 'Gotham',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                          onTap: () async {
                                            final pickupDetails =
                                                await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EnterLocationDetails(
                                                  onSubmit: _setPickupLocation,
                                                  type: "Pickup",
                                                ),
                                              ),
                                            );
                                            if (pickupDetails != null) {
                                              _setPickupLocation(pickupDetails);
                                            }
                                          },
                                          decoration: InputDecoration(
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            label: Text('Location'),
                                            labelStyle: TextStyle(
                                              color: hexToColor('#545454'),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 16,
                                            ),
                                            focusColor:
                                                Theme.of(context).primaryColor,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            prefixIcon: Image.asset(
                                              'assets/icons/globe.png',
                                              width: 16,
                                              height: 16,
                                            ),
                                            prefixIconConstraints:
                                                BoxConstraints(
                                              minWidth: 40,
                                            ),
                                            hintText: 'Pickup item from...',
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Gotham',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: hexToColor('#848484'),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          keyboardType: TextInputType.none,
                                        ),
                                      ),
                                      if (_pickupLocationController
                                              .text.isNotEmpty &&
                                          _pickupDetails != null)
                                        IconButton(
                                          icon: Image.asset(
                                            'assets/icons/delete.png',
                                            width: 20,
                                          ),
                                          onPressed: () {
                                            _pickupLocationController.clear();
                                            _pickupDetails = null;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EnterLocationDetails(
                                                  onSubmit: _setPickupLocation,
                                                  type: "Pickup",
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Text(
                                    'Shipment Details',
                                    style: TextStyle(
                                      color: hexToColor('#2A2A2A'),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: TextField(
                                          controller: _dropLocationController,
                                          cursorColor:
                                              Theme.of(context).primaryColor,
                                          style: TextStyle(
                                            fontFamily: 'Gotham',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                          onTap: () async {
                                            final dropDetails =
                                                await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EnterLocationDetails(
                                                  onSubmit: _setDropLocation,
                                                  type: "Shipment",
                                                ),
                                              ),
                                            );
                                            if (dropDetails != null) {
                                              _setDropLocation(dropDetails);
                                            }
                                          },
                                          decoration: InputDecoration(
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            label: Text('Location'),
                                            labelStyle: TextStyle(
                                              color: hexToColor('#545454'),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 16,
                                            ),
                                            prefixIcon: Image.asset(
                                              'assets/icons/globe.png',
                                              width: 16,
                                              height: 16,
                                            ),
                                            prefixIconConstraints:
                                                BoxConstraints(
                                              minWidth: 40,
                                            ),
                                            hintText: 'Drop item to...',
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Gotham',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                            focusColor:
                                                Theme.of(context).primaryColor,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: hexToColor('#848484'),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          keyboardType: TextInputType.none,
                                        ),
                                      ),
                                      if (_dropLocationController
                                              .text.isNotEmpty &&
                                          _dropDetails != null)
                                        IconButton(
                                          icon: Image.asset(
                                            'assets/icons/delete.png',
                                            width: 20,
                                          ),
                                          onPressed: () {
                                            _dropLocationController.clear();
                                            _dropDetails = null;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EnterLocationDetails(
                                                  onSubmit: _setDropLocation,
                                                  type: "Shipment",
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Text(
                            'Parcel Details',
                            style: TextStyle(
                              color: hexToColor('#2A2A2A'),
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                          ),
                          height: 175,
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 2.5,
                            children: [
                              _buildParcelDetailCard(
                                  'Small', '10gm - 500gm', 'assets/weight.png'),
                              _buildParcelDetailCard(
                                  'Medium', '500gm - 3kg', 'assets/weight.png'),
                              _buildParcelDetailCard(
                                  'Large', '3kg - 7kg', 'assets/weight.png'),
                              _buildParcelDetailCard('Extra Large',
                                  '7kg - 14kg', 'assets/weight.png'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Text(
                            'Parcel Worth',
                            style: TextStyle(
                              color: hexToColor('#2A2A2A'),
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 100,
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            style: TextStyle(
                              fontFamily: 'Gotham',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              label: Text('Enter Parcel Worth'),
                              labelStyle: TextStyle(
                                color: hexToColor('#545454'),
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.currency_rupee,
                                size: 20,
                              ),
                              prefixIconConstraints: BoxConstraints(
                                minWidth: 40,
                              ),
                              prefixIconColor: Theme.of(context).primaryColor,
                              hintText: '100 - 10,000',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: hexToColor('#848484'),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadAndVerifyDocument(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: hexToColor('#2D332F'),
                  // Set the button color to black
                  foregroundColor: Colors.white,
                  // Set the text color to white
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 18),
                  // Set the padding
                  textStyle: TextStyle(
                    fontSize: 16, // Set the text size
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w500, // Set the text weight
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        100), // Set the button corner radius
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Next Process', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  _buildParcelDetailCard(String title, String value, String iconPath) {
    bool isSelected = title == _selectedParcelType;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedParcelType = isSelected ? '' : title;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : hexToColor('#848484'),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : hexToColor('#545454'),
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              'Wt. $value',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EnterLocationDetails extends StatefulWidget {
  final Function(LocationDetails) onSubmit;
  final String type;

  EnterLocationDetails({super.key, required this.onSubmit, required this.type});

  @override
  State<EnterLocationDetails> createState() => _EnterLocationDetailsState();
}

class _EnterLocationDetailsState extends State<EnterLocationDetails> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _zipController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressLine1Controller = TextEditingController();
    _addressLine2Controller = TextEditingController();
    _zipController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 75,
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Row(
                  children: [
                    Image.asset('assets/black_tnent_logo.png',
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  'Enter ${widget.type} Details',
                  style: TextStyle(
                    color: hexToColor('#2A2A2A'),
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: _buildTextField(
                        controller: _nameController,
                        labelText: 'Name',
                        hintText: 'Enter Name',
                        prefixIcon: Icons.person_outline,
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    SizedBox(height: 35),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: _buildTextField(
                        controller: _phoneController,
                        labelText: 'Mobile Number',
                        hintText: 'XXXXX-XXXXX',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    SizedBox(height: 35),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: _buildTextField(
                        controller: _addressLine1Controller,
                        labelText: 'Flat/ Housing No./ Building/ Apartment',
                        hintText: 'Address Line 1',
                        prefixIcon: Icons.location_on_outlined,
                        keyboardType: TextInputType.streetAddress,
                      ),
                    ),
                    SizedBox(height: 35),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: _buildTextField(
                        controller: _addressLine2Controller,
                        labelText: 'Area/ Street/ Sector',
                        hintText: 'Address Line 2',
                        prefixIcon: Icons.location_on_outlined,
                        keyboardType: TextInputType.streetAddress,
                      ),
                    ),
                    SizedBox(height: 35),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: _buildTextField(
                        controller: _zipController,
                        labelText: 'Pincode',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: _buildTextField(
                            controller: _cityController,
                            labelText: 'City',
                            keyboardType: TextInputType.name,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: _buildTextField(
                            controller: _stateController,
                            labelText: 'State',
                            keyboardType: TextInputType.name,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hexToColor('#2D332F'),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 100, vertical: 20),
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Text('Proceed', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? labelText,
    String? hintText,
    IconData? prefixIcon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: hexToColor('#2A2A2A'),
        fontFamily: 'Gotham',
        fontSize: 14,
        fontWeight: FontWeight.w900,
      ),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        prefixIconColor: Theme.of(context).primaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: hexToColor('#2A2A2A')),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: hexToColor('#2A2A2A')),
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  void _submit() {
    final locationDetails = LocationDetails(
      name: _nameController.text,
      phone: _phoneController.text,
      addressLine1: _addressLine1Controller.text,
      addressLine2: _addressLine2Controller.text,
      zip: _zipController.text,
      city: _cityController.text,
      state: _stateController.text,
    );

    widget.onSubmit(locationDetails);
    Navigator.pop(context);
  }
}
