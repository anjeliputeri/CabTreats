import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onlineshop_app/core/router/app_router.dart';
import 'package:flutter_onlineshop_app/presentation/home/bloc/all_product/all_product_bloc.dart';
import 'package:flutter_onlineshop_app/presentation/home/widgets/beverage_card.dart';
import 'package:flutter_onlineshop_app/presentation/home/widgets/cake_card.dart';
import 'package:flutter_onlineshop_app/presentation/home/widgets/catering_card.dart';
import 'package:flutter_onlineshop_app/presentation/home/widgets/ice_cream_card.dart';
import 'package:flutter_onlineshop_app/presentation/orders/pages/keranjang_page.dart';
import 'package:flutter_onlineshop_app/presentation/product/pages/add_product_page.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/search_input.dart';
import '../../../core/components/spaces.dart';
import '../../../data/models/responses/product_response_model.dart';
import '../../category/presentation/beverage_category.dart';
import '../../category/presentation/cake_category.dart';
import '../../category/presentation/catering_category.dart';
import '../../category/presentation/ice_category.dart';
import '../../orders/models/cart_item.dart';
import '../../orders/models/cart_provider.dart';
import '../bloc/best_seller_product/best_seller_product_bloc.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../bloc/special_offer_product/special_offer_product_bloc.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';
import '../widgets/banner_slider.dart';
import '../widgets/organism/menu_categories.dart';
import '../widgets/title_content.dart';

import 'package:badges/badges.dart' as badges;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController searchController;
  bool isSeller = false;
  final user = FirebaseAuth.instance.currentUser;

  final List<String> banners1 = [
    Assets.images.banner1.path,
    Assets.images.banner2.path,
    Assets.images.banner3.path,
  ];
  final List<String> banners2 = [
    Assets.images.banner2.path,
    Assets.images.banner2.path,
    Assets.images.banner2.path,
  ];

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    fetchUserRole();
  }

  Future<void> fetchUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final userRole = userDoc.data()?['role'] as String?;
      setState(() {
        isSeller = userRole == 'Seller';
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CabTreats'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Assets.icons.notification.svg(height: 24.0),
          ),
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SearchInput(
            controller: searchController,
            onTap: () {
              context.pushReplacementNamed(
                RouteConstants.root,
                pathParameters: PathParameters(
                  rootTab: RootTab.explore,
                ).toMap(),
              );
            },
          ),
          const SpaceHeight(16.0),
          BannerSlider(items: banners1),
          const SpaceHeight(12.0),
          TitleContent(
            title: 'Categories',
            onSeeAllTap: () {},
          ),
          const SpaceHeight(12.0),
          const MenuCategories(),
          const SpaceHeight(12.0),
          TitleContent(
            title: 'Catering & Snack Menu',
            onSeeAllTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder:
                    (context) => CateringCategory(),
                ),
              );
            },
          ),
          const SpaceHeight(12.0),
          CateringCard(),
          const SpaceHeight(12.0),
          TitleContent(
            title: 'Cake & Bakery Menu',
            onSeeAllTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder:
                    (context) => CakeCategory(),
                ),
              );
            },
          ),
          const SpaceHeight(12.0),
          CakeCard(),
          const SpaceHeight(12.0),
          TitleContent(
            title: 'Beverage Menu',
            onSeeAllTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder:
                    (context) => BeverageCategory(),
                ),
              );
            },
          ),
          BeverageCard(),
          const SpaceHeight(12.0),
          TitleContent(
            title: 'Ice Cream Menu',
            onSeeAllTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder:
                    (context) => IceCreamCategory(),
                ),
              );
            },
          ),
          IceCreamCard(),
          const SpaceHeight(50.0),
        ],
      ),
      floatingActionButton: isSeller
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      )
          : null,
    );
  }
}
