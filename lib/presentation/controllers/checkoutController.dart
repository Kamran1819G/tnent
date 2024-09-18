import 'package:get/get.dart';

class CheckoutController extends GetxController {
  final RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;
  final RxString note = ''.obs;
  final double deliveryCharge = 15.0;

  // Existing getter for subtotal (renamed for clarity)
  double get subtotal => items.fold(0,
          (sum, item) => sum + (item['variationDetails'].price * item['quantity']));

  // New getter for total amount including platform fee
  double get totalAmountWithFee {
    double platformFee = PlatformFeeCalculator.calculateFee(subtotal);
    return subtotal + platformFee + deliveryCharge;
  }


  void updateNote(String value) {
    note.value = value;
  }

  void addItem(Map<String, dynamic> item) {
    items.add(item);
  }

  void removeItem(Map<String, dynamic> item) {
    items.remove(item);
  }

  void updateQuantity(int index, int newQuantity) {
    if (newQuantity > 0) {
      items[index]['quantity'] = newQuantity;
    } else {
      items.removeAt(index);
    }
    items.refresh();
  }

  void clear() {
    items.clear();
  }
}

// Assuming PlatformFeeCalculator is defined elsewhere in your project
class PlatformFeeCalculator {
  static double calculateFee(double totalAmount) {
    double feePercentage;

    if (totalAmount <= 1) {
      return 1; // Minimum fee of 0.05 rounded up to 1
    } else if (totalAmount <= 499) {
      feePercentage = 0.05;
    } else if (totalAmount <= 500) {
      feePercentage = 0.048;
    } else if (totalAmount <= 750) {
      feePercentage = 0.045;
    } else if (totalAmount <= 1000) {
      feePercentage = 0.042;
    } else if (totalAmount <= 1250) {
      feePercentage = 0.039;
    } else if (totalAmount <= 1500) {
      feePercentage = 0.035;
    } else if (totalAmount <= 1750) {
      feePercentage = 0.032;
    } else if (totalAmount <= 2000) {
      feePercentage = 0.030;
    } else {
      feePercentage = 0.030; // Default to 3% for totals above 2000
    }

    double fee = totalAmount * feePercentage;

    // Round up to the next whole number
    return fee.ceil().toDouble();
  }
}