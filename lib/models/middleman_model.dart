import 'new_delivery_model.dart';

class Middleman {
  String id;
  String name;
  String username;
  String phoneNo;
  List<NewDelivery> newDeliveries;

  Middleman({
    required this.id,
    required this.name,
    required this.username,
    required this.phoneNo,
    required this.newDeliveries,
  });
}