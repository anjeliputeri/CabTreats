import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlineshop_app/core/assets/assets.gen.dart';
import 'package:flutter_onlineshop_app/core/components/buttons.dart';
import 'package:flutter_onlineshop_app/core/constants/colors.dart';
import 'package:flutter_onlineshop_app/presentation/orders/models/cart_item.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_onlineshop_app/presentation/product/pages/product_page.dart';
import 'package:get/get.dart';
import '../../orders/pages/keranjang_page.dart';

class DetailProduct extends StatefulWidget {
  final Map<String, dynamic> product;

  const DetailProduct({Key? key, required this.product}) : super(key: key);

  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  String formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
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
            'added_by': product['added_by'],
          });
        }
        await cartDoc.update({'products': products});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produk ditambahkan ke keranjang')),
        );
      } else {
        await cartDoc.set({
          'products': [{
            ...product,
            'quantity': 1,
            'added_by': product['added_by'],
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

  Stream<Map<String, dynamic>> accountProfileImage() {
    return FirebaseFirestore.instance
        .collection('accounts')
        .doc(user!.email)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return {'profile_image': '', 'name': '', 'address': '', 'province': '', 'city': ''};
      }
      var accountData = snapshot.data() as Map<String, dynamic>;
      return {
        'profile_image': accountData['profile_image'] ?? '',
        'name': accountData['name'] ?? '',
        'address': accountData['address'] ?? '',
        'province': accountData['province'] ?? '',
        'city': accountData['city'] ?? '',
      };
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Product'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.network(
                      widget.product['image'],
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width * 0.5,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: null, // Allows the text to wrap to multiple lines
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Tersedia : 50',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  formatPrice(widget.product['price']),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          StreamBuilder<Map<String, dynamic>>(
                            stream: accountProfileImage(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data!['profile_image'].isNotEmpty) {
                                return CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: NetworkImage(snapshot.data!['profile_image']),
                                  backgroundColor: Colors.transparent,
                                );
                              } else {
                                return CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor: Colors.grey[300],
                                  child: Icon(Icons.person, color: Colors.white),
                                );
                              }
                            },
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder<Map<String, dynamic>>(
                                stream: accountProfileImage(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData && snapshot.data!['name'].isNotEmpty || snapshot.hasData && snapshot.data!['address'].isNotEmpty) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProductPage(),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!['name'] ?? 'Data not found',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '${snapshot.data!['province'] ?? 'Data not found'}, ${snapshot.data!['city'] ?? 'Data not found'}\n${snapshot.data!['address'] ?? 'Data not found'}',
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Description Product',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Button.outlined(
                          onPressed: (){
                            addToCart(widget.product);
                          },
                          label: 'Add Cart'
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Button.filled(
                        onPressed: () {
                          addToCart(widget.product);
                          Navigator.push(context,
                          MaterialPageRoute(builder:
                          (context) => KeranjangPage(),
                          ),
                          );
                        },
                        label: 'Checkout Now',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

            ],
          ),
        ),
      ),
    );
  }
}
