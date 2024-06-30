import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    return FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.email)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return {
          "totalItem": "0",
          "totalPrice": NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(0)
        };
      }
      var cartData = snapshot.data() as Map<String, dynamic>;
      var products =(cartData['products'] as List)
          .map((product) => CartItem(
        name: product['name'],
        price: product['price'],
        image: product['image'],
        quantity: product['quantity'],
      ))
          .toList();

      int total = 0;
      for (var item in products) {
        total += item.price * item.quantity;
      }

      return {
        "totalItem": (products.length).toString(),
        "totalPrice": NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(total)
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
          .map((product) => CartItem(
        name: product['name'],
        price: product['price'],
        image: product['image'],
        quantity: product['quantity'],
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _loading = true;
    });

    try {

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.email)
          .get();

      if (!doc.exists) {
      }

      var cartData = doc.data() as Map<String, dynamic>;
      var products = (cartData['products'] as List)
          .map((product) => CartItem(
        name: product['name'],
        price: product['price'],
        image: product['image'],
        quantity: product['quantity'],
      ))
          .toList();
      print("get data from firebase");


      for (var item in products) {
        print('Name: ${item.name}');
        print('-------------------------');
      }

      setState(() {
        _cartItems = products.cast<CartItem>();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          StreamBuilder<int>(
            stream: cartTotalQuantityStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == 0) {
                return IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => KeranjangPage()),
                    );
                  },
                  icon: Assets.icons.cart.svg(height: 24.0),
                );
              } else {
                return badges.Badge(
                  badgeContent: Text(
                    snapshot.data.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => KeranjangPage()),
                      );
                    },
                    icon: Assets.icons.cart.svg(height: 24.0),
                  ),
                );
              }
            },
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // ListView.separated(
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemCount: 0,
          //   itemBuilder: (context, index) => TileCart(),
          //   separatorBuilder: (context, index) => SpaceHeight(16.0),
          // ),
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
              // Text(
              //   _calculateTotal(),
              //   style: const TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
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
          // Button.filled(
          //   onPressed: () async {
          //     final isAuth = await AuthLocalDatasource().isAuth();
          //     if (!isAuth) {
          //       context.pushNamed(
          //         RouteConstants.login,
          //       );
          //     } else {
          //       context.goNamed(
          //         RouteConstants.address,
          //         pathParameters: PathParameters(
          //           rootTab: RootTab.order,
          //         ).toMap(),
          //       );
          //     }
          //   },
          //   label: 'Checkout (${_cartItems.length} items)',
          // ),
          StreamBuilder<Map<String, String>>(
            stream: cartTotalStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Button.filled(
                  onPressed: () async {
                    final isAuth = await AuthLocalDatasource().isAuth();
                    if (!isAuth) {
                      context.pushNamed(
                        RouteConstants.login,
                      );
                    } else {
                      context.goNamed(
                        RouteConstants.address,
                        pathParameters: PathParameters(
                          rootTab: RootTab.order,
                        ).toMap(),
                      );
                    }
                  },
                  label: 'Checkout (0 items)', // Default label saat loading
                );
              }
              if (snapshot.hasError) {
                return Button.filled(
                  onPressed: () async {
                    final isAuth = await AuthLocalDatasource().isAuth();
                    if (!isAuth) {
                      context.pushNamed(
                        RouteConstants.login,
                      );
                    } else {
                      context.goNamed(
                        RouteConstants.address,
                        pathParameters: PathParameters(
                          rootTab: RootTab.order,
                        ).toMap(),
                      );
                    }
                  },
                  label: 'Checkout (0 items)', // Default label saat error
                );
              }
              if (!snapshot.hasData || snapshot.data!['totalItem'] == '0') {
                return Button.filled(
                  onPressed: () async {
                    final isAuth = await AuthLocalDatasource().isAuth();
                    if (!isAuth) {
                      context.pushNamed(
                        RouteConstants.login,
                      );
                    } else {
                      context.goNamed(
                        RouteConstants.address,
                        pathParameters: PathParameters(
                          rootTab: RootTab.order,
                        ).toMap(),
                      );
                    }
                  },
                  label: 'Checkout (0 items)', // Default label saat tidak ada produk
                );
              }

              String totalProducts = snapshot.data!['totalItem']!;
              return Button.filled(
                onPressed: () async {
                  final isAuth = await AuthLocalDatasource().isAuth();
                  if (!isAuth) {
                    context.pushNamed(
                      RouteConstants.login,
                    );
                  } else {
                    context.goNamed(
                      RouteConstants.address,
                      pathParameters: PathParameters(
                        rootTab: RootTab.order,
                      ).toMap(),
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

