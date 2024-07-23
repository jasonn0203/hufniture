class CartItem {
  final String id;
  final String image;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['productId'],
      image: map['imageUrl'],
      name: map['productName'],
      price: map['price'],
      quantity: map.containsKey('quantity')
          ? map['quantity']
          : 1, // Set default quantity to 1 if not provided
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': id,
      'imageUrl': image,
      'productName': name,
      'price': price,
      'quantity': quantity,
    };
  }
}
