class CartItem {
  final int id;
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
}
