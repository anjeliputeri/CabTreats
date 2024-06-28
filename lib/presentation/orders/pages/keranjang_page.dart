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

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({super.key});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  List<ModelCart> _cartItems = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _loading = true;
    });

    try {
      print("get data from firebase");
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('userEmail', isEqualTo: user.email)
          .get();
      print(cartSnapshot);

      final cartItems = cartSnapshot.docs
          .map((doc) => ModelCart.fromJson(doc.data()))
          .toList();

      for (var item in cartItems) {
        print('Name: ${item.product.price}');
        print('-------------------------');
      }

      setState(() {
        _cartItems = cartItems.cast<ModelCart>();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  String _calculateTotal() {
    int total = 0;
    for (var item in _cartItems) {
      total += item.quantity * item.product.price!;
    }
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(total);
  }

  @override
  Widget build(BuildContext context) {
    final totalQuantity = _cartItems.fold<int>(
      0,
          (previousValue, element) => previousValue + element.quantity,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          if (totalQuantity > 0)
            badges.Badge(
              badgeContent: Text(
                totalQuantity.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              child: IconButton(
                onPressed: () {
                  context.goNamed(
                    RouteConstants.cart,
                    pathParameters: PathParameters().toMap(),
                  );
                },
                icon: Assets.icons.cart.svg(height: 24.0),
              ),
            )
          else
            IconButton(
              onPressed: () {
                context.goNamed(
                  RouteConstants.cart,
                  pathParameters: PathParameters().toMap(),
                );
              },
              icon: Assets.icons.cart.svg(height: 24.0),
            ),
          const SizedBox(width: 16.0),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _cartItems.length,
            itemBuilder: (context, index) => TileCart(),
            separatorBuilder: (context, index) => SpaceHeight(16.0),
          ),
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
              Text(
                _calculateTotal(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SpaceHeight(40.0),
          Button.filled(
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
            label: 'Checkout (${_cartItems.length} items)',
          ),
        ],
      ),
    );
  }
}

