import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlineshop_app/core/constants/variables.dart';
import 'package:flutter_onlineshop_app/presentation/orders/pages/cart_page.dart';
import 'package:flutter_onlineshop_app/presentation/orders/widgets/cart_tile.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/components/spaces.dart';
import '../../../core/core.dart';
import '../../orders/pages/keranjang_page.dart';
import '../../orders/pages/order_detail_page.dart';

class CateringCard extends StatefulWidget {
  const CateringCard({Key? key}) : super(key: key);

  @override
  State<CateringCard> createState() => _CateringCorouselState();
}

class _CateringCorouselState extends State<CateringCard> {
  var db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  void addToCart(Map<String, dynamic> product) async {
    if (user != null) {
      final cartDoc = db.collection('cart').doc(user!.email);
      final snapshot = await cartDoc.get();

      if (snapshot.exists) {
        var products = List<Map<String, dynamic>>.from(snapshot.data()!['products'] ?? []);
        var existingProductIndex = products.indexWhere((item) => item['name'] == product['name']);

        if (existingProductIndex != -1) {
          products[existingProductIndex]['quantity'] += 1;
        } else {
          products.add({
            ...product,
            'quantity': 1,
          });
        }
        await cartDoc.update({'products': products});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(existingProductIndex != -1 ? 'Produk ditambahkan ke keranjang' : 'Produk ditambahkan ke keranjang')),
        );
      } else {
        await cartDoc.set({
          'products': [{
            ...product,
            'quantity': 1,
          }],
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produk ditambahkan ke keranjang')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda harus masuk untuk menambahkan ke keranjang')),
      );
    }
  }

  String formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 7.0,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: db.collection('Catering & Snack').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }

          var _data = snapshot.data!.docs;
          return SizedBox(
            height: 230.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _data.length,
              itemBuilder: (context, index) {
                var product = _data[index].data();
                var nama = product['name'];
                var harga = product['price'];
                var gambar = product['image'];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 150.0,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.05),
                          blurRadius: 7.0,
                          spreadRadius: 0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Stack(
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    width: 125.0,
                                    height: 125.0,
                                    color: Colors.white,
                                  ),
                                ),
                                Image.network(
                                  gambar,
                                  width: 125.0,
                                  height: 125.0,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        width: 125.0,
                                        height: 125.0,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SpaceHeight(14.0),
                        Text(
                          nama ?? 'Cookies',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              harga != null ? formatPrice(harga) : 'Rp 10.000',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                addToCart(product);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => KeranjangPage(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: AppColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.black.withOpacity(0.1),
                                      blurRadius: 10.0,
                                      offset: const Offset(0, 2),
                                      blurStyle: BlurStyle.outer,
                                    ),
                                  ],
                                ),
                                child: Assets.icons.order.svg(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}