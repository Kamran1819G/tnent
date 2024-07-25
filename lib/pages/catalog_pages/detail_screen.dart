import 'package:flutter/material.dart';
import 'package:tnennt/helpers/color_utils.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  DetailScreen({required this.order});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductDetails(),
                    SizedBox(height: 40.0),
                    if (widget.order['providedMiddleman'] != null &&
                        widget.order['providedMiddleman'].isNotEmpty)
                      _buildProvidedMiddleman(),
                    SizedBox(height: 40.0),
                    _buildAmountDetails(),
                    SizedBox(height: 40.0),
                    _buildPaymentDetails(),
                    SizedBox(height: 40.0),
                    _buildDeliveryDetails(),
                    SizedBox(height: 30.0),
                    _buildCancelOrderButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Row(
            children: [
              Text(
                'Details'.toUpperCase(),
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
                  color: hexToColor('#42FF00'),
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
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 125,
            width: 125,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(widget.order['productImage']),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.order['productName'],
                style: TextStyle(color: hexToColor('#343434'), fontSize: 16.0),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Text(
                    'Order ID:',
                    style: TextStyle(color: hexToColor('#878787'), fontSize: 14.0),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    widget.order['orderId'],
                    style: TextStyle(color: hexToColor('#A9A9A9'), fontSize: 14.0),
                  ),
                ],
              ),
              SizedBox(height: 50.0),
              Text(
                '₹ ${widget.order['priceDetails']['price']}',
                style: TextStyle(color: hexToColor('#343434'), fontSize: 16.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProvidedMiddleman() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Provided Middlemen:',
            style: TextStyle(color: hexToColor('#343434'), fontSize: 16.0),
          ),
          SizedBox(height: 15.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.order['providedMiddleman']['name'] ?? '',
                    style: TextStyle(
                      color: hexToColor('#727272'),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 1.0),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: hexToColor('#727272'),
                        size: 14,
                      ),
                      Text(
                        widget.order['providedMiddleman']['phone'] ?? '',
                        style: TextStyle(
                          color: hexToColor('#727272'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              if (widget.order['providedMiddleman']['image'] != null)
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    image: DecorationImage(
                      image: NetworkImage(widget.order['providedMiddleman']['image']),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amount Details:',
            style: TextStyle(color: hexToColor('#343434'), fontSize: 16.0),
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                _buildAmountRow('Subtotal', widget.order['priceDetails']['price']),
                _buildAmountRow('MRP', widget.order['priceDetails']['mrp']),
                _buildAmountRow('Discount', '- ${widget.order['priceDetails']['discount']}'),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15.0),
            height: 0.75,
            color: hexToColor('#2B2B2B'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(color: hexToColor('#343434'), fontSize: 16.0),
              ),
              Text(
                '₹ ${widget.order['priceDetails']['price']}',
                style: TextStyle(color: hexToColor('#838383'), fontSize: 16.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, dynamic value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: hexToColor('#727272'),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
        ),
        Text(
          '₹ $value',
          style: TextStyle(
            color: hexToColor('#727272'),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Details:',
            style: TextStyle(color: hexToColor('#343434'), fontSize: 16.0),
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                _buildDetailRow('Payment Mode', widget.order['payment']['method']),
                _buildDetailRow('Payment Status', widget.order['payment']['status']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Details:',
            style: TextStyle(color: hexToColor('#343434'), fontSize: 16.0),
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shipping Address',
                  style: TextStyle(
                    color: hexToColor('#2D332F'),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(widget.order['shippingAddress']['name'] ?? '',
                    style: _addressTextStyle()),
                Text(widget.order['shippingAddress']['addressLine1'] ?? '',
                    style: _addressTextStyle()),
                Text(widget.order['shippingAddress']['addressLine2'] ?? '',
                    style: _addressTextStyle()),
                Text(
                  '${widget.order['shippingAddress']['city'] ?? ''}, ${widget.order['shippingAddress']['state'] ?? ''} - ${widget.order['shippingAddress']['zip'] ?? ''}',
                  style: _addressTextStyle(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _addressTextStyle() {
    return TextStyle(
      color: hexToColor('#727272'),
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: _addressTextStyle()),
        Text(value, style: _addressTextStyle()),
      ],
    );
  }

  Widget _buildCancelOrderButton() {
    return Center(
      child: Container(
        height: 50,
        width: 150,
        margin: EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          color: hexToColor('#2B2B2B'),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: Text(
            'Cancel Order',
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        ),
      ),
    );
  }
}