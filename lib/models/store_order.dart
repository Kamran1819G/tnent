class StoreOrder {
  final String id;
  final double total;
  String status;

  StoreOrder({required this.id, required this.total, required this.status});

  factory StoreOrder.fromJson(Map<String, dynamic> json) {
    return StoreOrder(
      id: json['id'],
      total: double.parse(json['total']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total': total.toString(),
      'status': status,
    };
  }
}