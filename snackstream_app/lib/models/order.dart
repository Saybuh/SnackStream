class Order {
  final String id;
  final String restaurantId;
  final String userId;
  final List<Map<String, dynamic>> items;
  final String status;

  Order(
      {required this.id,
      required this.restaurantId,
      required this.userId,
      required this.items,
      required this.status});

  factory Order.fromFirestore(Map<String, dynamic> data, String id) {
    return Order(
      id: id,
      restaurantId: data['restaurantId'],
      userId: data['userId'],
      items: List<Map<String, dynamic>>.from(data['items']),
      status: data['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'userId': userId,
      'items': items,
      'status': status,
    };
  }
}
