class Order {
  final String id;
  final String userId;
  final DateTime orderDate;
  final List<OrderItem> orderItems;
  final List<OrderStatus> orderStatuses;

  Order({
    required this.id,
    required this.userId,
    required this.orderDate,
    required this.orderItems,
    required this.orderStatuses,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      orderDate: DateTime.parse(json['orderDate']),
      orderItems: (json['orderItems'] as List)
          .map((i) => OrderItem.fromJson(i))
          .toList(),
      orderStatuses: (json['orderStatuses'] as List)
          .map((s) => OrderStatus.fromJson(s))
          .toList(),
    );
  }
}

class OrderItem {
  final String id;
  final String orderId;
  final FurnitureProduct furnitureProduct;
  final int quantity;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.furnitureProduct,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['orderId'],
      furnitureProduct: FurnitureProduct.fromJson(json['furnitureProduct']),
      quantity: json['quantity'],
    );
  }
}

class FurnitureProduct {
  final String id;
  final String name;
  final String description;
  final String imageURL;
  final double price;

  FurnitureProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.imageURL,
    required this.price,
  });

  factory FurnitureProduct.fromJson(Map<String, dynamic> json) {
    return FurnitureProduct(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageURL: json['imageURL'],
      price: json['price'],
    );
  }
}

class OrderStatus {
  final String id;
  final String orderId;
  final String status;
  final DateTime statusChangedDate;

  OrderStatus({
    required this.id,
    required this.orderId,
    required this.status,
    required this.statusChangedDate,
  });

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      id: json['id'],
      orderId: json['orderId'],
      status: json['status'],
      statusChangedDate: DateTime.parse(json['statusChangedDate']),
    );
  }
}
