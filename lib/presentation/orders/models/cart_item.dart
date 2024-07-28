import 'package:flutter_onlineshop_app/data/models/requests/courier_cost_request_model.dart';

class CartItem {
  final String name;
  final int price;
  final String image;
  final String addedBy;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.image,
    required this.addedBy,
    this.quantity = 1,
});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
      'added_by': addedBy,
    };
  }

  static List<OrderItem>  convertCartItemsToOrderItems(List<CartItem> cartItems, double itemWeight) {
  return cartItems.map((cartItem) {
    return OrderItem(
      name: cartItem.name,
      weight: itemWeight,
      quantity: cartItem.quantity,
      vendorEmail: cartItem.addedBy
    );
  }).toList();
}
}