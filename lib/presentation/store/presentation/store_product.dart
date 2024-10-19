import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlineshop_app/presentation/orders/models/cart_item.dart';
import 'package:flutter_onlineshop_app/presentation/product/pages/detail_product.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../orders/pages/keranjang_page.dart';
import 'package:badges/badges.dart' as badges;

class StoreProduct extends StatefulWidget {
  final String email;
  final String name;

  const StoreProduct({Key? key, required this.email, required this.name}) : super(key: key);

  @override
  State<StoreProduct> createState() => _StoreProductState();
}

class _StoreProductState extends State<StoreProduct> {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  bool isSeller = false;

  @override
  void initState() {
    super.initState();
    fetchUserRole();
  }

  void addToCart(Map<String, dynamic> product) async {
    if (user != null) {

       if(user!.email == product["added_by"]) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anda tidak bisa membeli produk sendiri')),
        );
      } else {
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
            SnackBar(content: Text('Produk ditambahkan ke keranjang')),
          );
        } else {
          await cartDoc.set({
            'products': [
              {
                ...product,
                'quantity': 1,
              }
            ],
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Produk ditambahkan ke keranjang')),
          );
        }

      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda harus masuk untuk menambahkan ke keranjang')),
      );
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

  void fetchUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final userRole = userDoc.data()?['role'] as String?;
      setState(() {
        isSeller = userRole == 'Seller';
      });
    }
  }

  String formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  Stream<List<Map<String, dynamic>>> fetchBeverage() {
    return db
        .collection('Beverage')
        .where('added_by', isEqualTo: widget.email) // Filter by email
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
  }

  Stream<List<Map<String, dynamic>>> fetchCatering() {
    return db
        .collection('Catering & Snack')
        .where('added_by', isEqualTo: widget.email) // Filter by email
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
  }

  Stream<List<Map<String, dynamic>>> fetchCake() {
    return db
        .collection('Cake & Bakery')
        .where('added_by', isEqualTo: widget.email) // Filter by email
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
  }

  Stream<List<Map<String, dynamic>>> fetchIce() {
    return db
        .collection('Ice Cream')
        .where('added_by', isEqualTo: widget.email) // Filter by email
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
  }

  Stream<List<Map<String, dynamic>>> fetchCombinedProducts() {
    final cateringStream = fetchCatering();
    final cakeStream = fetchCake();
    final beverageStream = fetchBeverage();
    final iceStream = fetchIce();

    return Rx.combineLatest4(
      cateringStream,
      cakeStream,
      beverageStream,
      iceStream,
          (List<Map<String, dynamic>> catering, List<Map<String, dynamic>> cake, List<Map<String, dynamic>> beverage, List<Map<String, dynamic>> ice) {
        return [...catering, ...cake, ...beverage, ...ice];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
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
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: fetchCombinedProducts(),
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

            var data = snapshot.data ?? [];
            if (data.isEmpty) {
              return Center(
                child: Text(
                  'No product available',
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of cards per row
                  childAspectRatio: 2 / 3, // Adjust aspect ratio as needed
                  mainAxisSpacing: 8.0, // Spacing between rows
                  crossAxisSpacing: 16.0, // Spacing between columns
                ),
                itemBuilder: (context, index) {
                  var product = data[index];
                  var nama = product['name'];
                  var harga = product['price'];
                  var gambar = product['image'];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailProduct(product: product),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Stack(
                                children: [
                                  Image.network(
                                    gambar,
                                    width: double.infinity,
                                    height: 125.0,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          width: double.infinity,
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
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
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
                                  child: Assets.icons.order
                                      .svg(), // Replace with your add to cart icon or button
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
      ),
    );
  }
}
