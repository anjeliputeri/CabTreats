import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'cart_item.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  List<CartItem> get items => _items;

  void setCartItems(List<CartItem> items) {
    _items = items;
    notifyListeners();
  }

  Future<void> updateQuantityInFirestore(int index, int quantity) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartDoc = FirebaseFirestore.instance.collection('cart').doc(user.email);
      final snapshot = await cartDoc.get();
      if (snapshot.exists) {
        var cartData = snapshot.data() as Map<String, dynamic>;
        var products = cartData['products'] as List;
        products[index]['quantity'] = quantity;

        await cartDoc.update({'products': products});
      }
    }
  }

  void incrementQuantity(int index) {
    _items[index].quantity += 1;
    updateQuantityInFirestore(index, _items[index].quantity);
    notifyListeners();
  }

  void decrementQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity -= 1;
      updateQuantityInFirestore(index, _items[index].quantity);
      notifyListeners();
    }
  }
}
