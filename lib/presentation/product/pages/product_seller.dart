import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onlineshop_app/core/router/app_router.dart';
import 'package:flutter_onlineshop_app/presentation/explore/widget/beverage_explore.dart';
import 'package:flutter_onlineshop_app/presentation/explore/widget/cake_explore.dart';
import 'package:flutter_onlineshop_app/presentation/explore/widget/catering_explore.dart';
import 'package:flutter_onlineshop_app/presentation/explore/widget/ice_explore.dart';
import 'package:flutter_onlineshop_app/presentation/home/bloc/all_product/all_product_bloc.dart';
import 'package:flutter_onlineshop_app/presentation/home/widgets/beverage_card.dart';
import 'package:flutter_onlineshop_app/presentation/home/widgets/cake_card.dart';
import 'package:flutter_onlineshop_app/presentation/home/widgets/catering_card.dart';
import 'package:flutter_onlineshop_app/presentation/home/widgets/ice_cream_card.dart';
import 'package:flutter_onlineshop_app/presentation/orders/pages/keranjang_page.dart';
import 'package:flutter_onlineshop_app/presentation/orders/widgets/tile_cart.dart';
import 'package:flutter_onlineshop_app/presentation/product/pages/add_product_page.dart';
import 'package:flutter_onlineshop_app/presentation/product/widget/beverage_product.dart';
import 'package:flutter_onlineshop_app/presentation/product/widget/cake_product.dart';
import 'package:flutter_onlineshop_app/presentation/product/widget/ice_product.dart';
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
import '../../home/widgets/banner_slider.dart';
import '../../home/widgets/organism/menu_categories.dart';
import '../../home/widgets/title_content.dart';
import '../../orders/models/cart_item.dart';
import '../../orders/models/cart_provider.dart';

import 'package:badges/badges.dart' as badges;

import '../widget/catering_product.dart';

class ProductSeller extends StatefulWidget {
  final String addedBy;

  const ProductSeller({Key? key, required this.addedBy}) : super(key: key);

  @override
  State<ProductSeller> createState() => _ProductSellerState();
}

class _ProductSellerState extends State<ProductSeller> {
  late TextEditingController searchController;
  bool isSeller = false;
  final user = FirebaseAuth.instance.currentUser;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SearchInput(
            controller: searchController,
            onTap: () {
            },
          ),
          CateringProduct(searchQuery: searchQuery),
          CakeProduct(searchQuery: searchQuery),
          BeverageProduct(searchQuery: searchQuery),
          IceProduct(searchQuery: searchQuery),
        ],
      ),
    );
  }
}
