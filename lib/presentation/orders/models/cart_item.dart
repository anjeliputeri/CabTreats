import 'package:flutter_onlineshop_app/data/models/requests/courier_cost_request_model.dart';

class CartItem {
  final String name;
  final int price;
  final int weight;
  final int originalPrice;
  final String image;
  final String addedBy;

  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.weight,
    required this.image,
    required this.addedBy,
    required this.originalPrice,
    this.quantity = 1,
});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'image': image,
      'weight': weight,
      'quantity': quantity,
      'added_by': addedBy,
      'original_price': originalPrice,
    };
  }

  static List<OrderItem>  convertCartItemsToOrderItems(List<CartItem> cartItems, double itemWeight) {
  return cartItems.map((cartItem) {
    return OrderItem(
      name: cartItem.name,
      weight: cartItem.weight,
      quantity: cartItem.quantity,
      vendorEmail: cartItem.addedBy,
      originalPrice: cartItem.originalPrice,
    );
  }).toList();
}
}