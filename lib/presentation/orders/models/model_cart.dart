import '../../home/models/product.dart';

class ModelCart {
  final Product product;
  final int quantity;

  ModelCart({required this.product, required this.quantity});

  factory ModelCart.fromJson(Map<String, dynamic> json) {
    return ModelCart(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}