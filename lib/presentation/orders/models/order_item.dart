class OrderItem {
  final String name;
  final int price;
  final String image;
  int quantity;

  OrderItem({
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }
}