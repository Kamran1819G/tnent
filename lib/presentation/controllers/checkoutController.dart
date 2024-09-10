import 'package:get/get.dart';

class CheckoutController extends GetxController {
  final RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;
  final RxString note = ''.obs;

  double get totalAmount => items.fold(0,
      (sum, item) => sum + (item['variationDetails'].price * item['quantity']));

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
