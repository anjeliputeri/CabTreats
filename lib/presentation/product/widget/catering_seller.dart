import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../orders/pages/keranjang_page.dart';

class CateringSeller extends StatefulWidget {
  final String searchQuery;
  final String addedBy;

  CateringSeller({required this.searchQuery, required this.addedBy});

  @override
  State<CateringSeller> createState() => _CateringSellerState();
}

class _CateringSellerState extends State<CateringSeller> {
  var db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  void addToCart(Map<String, dynamic> product) async {
    if (user != null) {
      final cartDoc = db.collection('cart').doc(user!.email);
      final snapshot = await cartDoc.get();

      final productWithDetails = {
        ...product,
        'quantity': 1,
        'added_by': product['added_by'],
      };

      if (snapshot.exists) {
        var products = List<Map<String, dynamic>>.from(snapshot.data()!['products'] ?? []);
        var existingProductIndex = products.indexWhere((item) => item['name'] == product['name']);

        if (existingProductIndex != -1) {
          products[existingProductIndex]['quantity'] += 1;
        } else {
          products.add(productWithDetails);
        }
        await cartDoc.update({'products': products});
      } else {
        await cartDoc.set({
          'products': [productWithDetails],
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk ditambahkan ke keranjang')),
      );
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
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: db
          .collection('Catering & Snack')
          .where('added_by', isEqualTo: widget.addedBy)
          .snapshots(),
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

        var data = snapshot.data!.docs;
        var filteredData = data.where((doc) {
          var product = doc.data();
          var nama = product['name'].toString().toLowerCase();
          var query = widget.searchQuery.toLowerCase();
          return nama.contains(query);
        }).toList();

        return SingleChildScrollView(
          child: Column(
            children: filteredData.map((doc) {
              var product = doc.data();
              var nama = product['name'];
              var harga = product['price'];
              var gambar = product['image'];

              return Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.stroke),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          child: Image.network(
                            gambar,
                            width: 58.0,
                            height: 58.0,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 58.0,
                                    height: 58.0,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SpaceWidth(14.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nama,
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                formatPrice(harga),
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
                            child: Assets.icons.order.svg(), // Replace with your add to cart icon or button
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
