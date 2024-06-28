import '../../../core/extensions/int_ext.dart';
import 'store_model.dart';

class Product {
  final String name;
  final String imageUrl;
  final int price;

  Product({required this.name, required this.imageUrl, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price'],
    );
  }
}