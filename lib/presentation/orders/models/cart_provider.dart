import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void setCartItems(List<CartItem> items) {
    _items = items;
    notifyListeners();
  }

  void decrementQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
    _updateDatabase();
  }

  void incrementQuantity(int index) {
    _items[index].quantity++;
    notifyListeners();
    _updateDatabase();
  }

  void deleteItem(int index) {
    _items.removeAt(index);
    notifyListeners();
    _updateDatabase();
  }

  void _updateDatabase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var cartData = {
        'products': _items.map((item) => item.toMap()).toList(),
      };
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.email)
          .set(cartData);
    }
  }
}

extension on CartItem {
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
      'added_by': addedBy,
      'weight': weight,
      'original_price': originalPrice
    };
  }
}
