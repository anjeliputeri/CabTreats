import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlineshop_app/core/assets/assets.gen.dart';
import 'package:flutter_onlineshop_app/core/components/buttons.dart';
import 'package:flutter_onlineshop_app/core/constants/colors.dart';
import 'package:flutter_onlineshop_app/presentation/orders/models/cart_item.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_onlineshop_app/presentation/product/pages/product_page.dart';
import 'package:flutter_onlineshop_app/presentation/product/pages/product_seller.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

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
  quill.QuillController? _controller;

   @override
  void initState() {
    super.initState();
    final doc = quill.Document.fromJson(widget.product['description']);
    setState(() {
      _controller =  quill.QuillController(
            document: doc,
            selection: TextSelection.collapsed(offset: 0),
          );
    });
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

  Stream<Map<String, dynamic>> sellerProfileImage(String email) {
    return FirebaseFirestore.instance
        .collection('accounts')
        .doc(email)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return {
          'profile_image': '',
          'name': 'Data not found',
          'address': 'Data not found',
          'province': 'Data not found',
          'city': 'Data not found',
        };
      }
      var accountData = snapshot.data() as Map<String, dynamic>;
      return {
        'profile_image': accountData['profile_image'] ?? '',
        'name': accountData['name'] ?? 'Data not found',
        'address': accountData['address'] ?? 'Data not found',
        'province': accountData['province'] ?? 'Data not found',
        'city': accountData['city'] ?? 'Data not found',
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
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      StreamBuilder<Map<String, dynamic>>(
                        stream: sellerProfileImage(widget.product['added_by']),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var profileImage = snapshot.data!['profile_image'];
                            var name = snapshot.data!['name'];
                            var address = snapshot.data!['address'];
                            var province = snapshot.data!['province'];
                            var city = snapshot.data!['city'];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductSeller(
                                      addedBy: widget.product['added_by'],
                                      name: name,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: profileImage.isNotEmpty
                                          ? NetworkImage(profileImage)
                                          : null,
                                      backgroundColor: profileImage.isEmpty
                                          ? Colors.grey[300]
                                          : Colors.transparent,
                                      child: profileImage.isEmpty
                                          ? Icon(Icons.person, color: Colors.white)
                                          : null,
                                    ),
                                    SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name.isNotEmpty ? name : 'Data not found',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '${province.isNotEmpty ? province : 'Data not found'}, ${city.isNotEmpty ? city : 'Data not found'}\n${address.isNotEmpty ? address : 'Data not found'}',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
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
                child: quill.QuillEditor.basic(configurations: quill.QuillEditorConfigurations(
                  controller: _controller!,
                  showCursor: false,
                  disableClipboard: true,
                  readOnlyMouseCursor: SystemMouseCursors.forbidden
              
                  ),)
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
