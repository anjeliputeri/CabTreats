import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlineshop_app/presentation/address/pages/add_address.dart';
import 'package:flutter_onlineshop_app/presentation/address/pages/address.dart';
import 'package:flutter_onlineshop_app/presentation/auth/pages/login_page.dart';
import 'package:flutter_onlineshop_app/presentation/home/pages/home_page.dart';
import 'package:flutter_onlineshop_app/presentation/orders/widgets/cart_tile.dart';
import 'package:flutter_onlineshop_app/presentation/orders/widgets/tile_cart.dart';
import 'package:badges/badges.dart' as badges;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/core.dart';
import '../../../core/router/app_router.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../models/model_cart.dart';
import '../models/cart_item.dart';

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({super.key});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  List<CartItem> _cartItems = [];
  bool _loading = true;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Stream<Map<String, String>> cartTotalStream() {

     if (user == null) {
      return Stream.value({
        "totalItem": "0",
        "totalPrice": NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ')
            .format(0)
      });
    }
    return FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.email)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return {
          "totalItem": "0",
          "totalPrice": NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ')
              .format(0)
        };
      }
      var cartData = snapshot.data() as Map<String, dynamic>;
      var products = (cartData['products'] as List)
          .map((product) =>
          CartItem(
              name: product['name'],
              price: product['price'],
              originalPrice: product['original_price'],
              weight: product['weight'],
              image: product['image'],
              quantity: product['quantity'],
              addedBy: product['added_by'],
          ))
          .toList();

      int total = 0;
      for (var item in products) {
        total += item.price * item.quantity;
      }

      return {
        "totalItem": (products.length).toString(),
        "totalPrice": NumberFormat.currency(
            locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(total)
      };
    });
  }

  Stream<int> cartTotalQuantityStream() {
    return FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.email)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return 0;
      }
      var cartData = snapshot.data() as Map<String, dynamic>;
      var products = (cartData['products'] as List)
          .map((product) =>
          CartItem(
              name: product['name'],
              price: product['price'],
              originalPrice: product['original_price'],
              weight: product['weight'],
              image: product['image'],
              quantity: product['quantity'],
              addedBy: product['added_by'],
          ))
          .toList();

      int totalQuantity = 0;
      for (var item in products) {
        totalQuantity += item.quantity;
      }
      return totalQuantity;
    });
  }

  Future<void> _loadCart() async {
    setState(() {
      _loading = true;
    });

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user!.email)
          .get();

      if (!doc.exists) {
        setState(() {
          _cartItems = [];
        });
        return;
      }

      var cartData = doc.data() as Map<String, dynamic>;
      var products = (cartData['products'] as List)
          .map((product) =>
      {
        "name": product['name'],
        "price": product['price'],
        "image": product['image'],
        "quantity": product['quantity'],
        "added_by": product['added_by'] // Capture the added_by field separately
      })
          .toList();

      setState(() {
        _cartItems = products.map((data) =>
            CartItem(
              name: data['name'],
              price: data['price'],
              originalPrice: data['original_price'],
              weight: data['weight'],
              image: data['image'],
              quantity: data['quantity'],
              addedBy: data['added_by'],
            )).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print("Error loading cart: $e");
    }
  }

  void _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Warning"),
          content: Text(
              "There are no item in the cart. Please, add item before checkout"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => HomePage(),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Warning"),
          content: Text(
              "Please, add products from the same store."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showWarningLogin(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Warning"),
          content: Text("Please, login to proceed with checkout"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          TileCart(),
          const SpaceHeight(50.0),
          Row(
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              StreamBuilder<Map<String, String>>(
                stream: cartTotalStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text('Error');
                  }
                  if (!snapshot.hasData) {
                    return const Text('No item in the cart');
                  }
                  String totalPrice = snapshot.data!['totalPrice']!;

                  return Text(
                    totalPrice,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ],
          ),
          const SpaceHeight(40.0),
          StreamBuilder<Map<String, String>>(
            stream: cartTotalStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Button.filled(
                  onPressed: () async {
                    final isAuth = await AuthLocalDatasource().isAuth();
                    if (!isAuth) {
                      context.pushNamed(RouteConstants.login);
                    } else {
                      context.goNamed(
                        RouteConstants.address,
                        pathParameters: PathParameters(
                          rootTab: RootTab.order,
                        ).toMap(),
                      );
                    }
                  },
                  label: 'Checkout (0 item)', // Default label saat loading
                );
              }
              if (snapshot.hasError) {
                return Button.filled(
                  onPressed: () async {
                    final isAuth = await AuthLocalDatasource().isAuth();
                    if (!isAuth) {
                      _showWarningDialog(context);
                    } else {
                      _showWarningLogin(context);
                    }
                  },
                  label: 'Checkout (0 item)', // Default label saat error
                );
              }
              if (!snapshot.hasData || snapshot.data!['totalItem'] == '0') {
                return Button.filled(
                  onPressed: () async {
                    final isAuth = await AuthLocalDatasource().isAuth();
                    if (!isAuth) {
                      _showWarningDialog(context);
                    } else {
                      _showWarningLogin(context);
                    }
                  },
                  label: 'Checkout (0 item)',
                );
              }

              String totalProducts = snapshot.data!['totalItem']!;
              return Button.filled(
                onPressed: () async {
                    // Load cart items and show product dialog if needed
                    DocumentSnapshot doc = await FirebaseFirestore.instance
                        .collection('cart')
                        .doc(user!.email)
                        .get();

                    if (doc.exists) {
                      var cartData = doc.data() as Map<String, dynamic>;
                      var products = (cartData['products'] as List)
                          .map((product) =>
                      {
                        "name": product['name'],
                        "price": product['price'],
                        "image": product['image'],
                        "quantity": product['quantity'],
                        "added_by": product['added_by'],
                        "weight": product['weight'],
                        "original_price": product['original_price'],
                        // Capture the added_by field separately
                      })
                          .toList();

                      Set<String> addedBySet = {};
                      for (var item in products) {
                        addedBySet.add(item['added_by']);
                      }

                      if (addedBySet.length > 1) {
                        _showProductDialog(context);
                      } else {
                        // Proceed to address page if no product dialog needed
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Address(),
                          ),
                        );
                      }
                    } else {
                      // Proceed to address page if cart is empty
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Address(),
                        ),
                      );
                    }
                  },
                label: 'Checkout ($totalProducts items)',
              );
            },
          ),
        ],
      ),
    );
  }
}
