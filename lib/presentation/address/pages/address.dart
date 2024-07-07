import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onlineshop_app/presentation/address/pages/add_address.dart';
import 'package:flutter_onlineshop_app/presentation/address/widgets/tile_address.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart'; // Import collection package
import 'package:intl/intl.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/core.dart';
import '../../../core/router/app_router.dart';
import '../../home/bloc/checkout/checkout_bloc.dart';
import '../../orders/models/cart_item.dart';

class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  Stream<Map<String, String>> cartTotalStream() {
    final user = FirebaseAuth.instance.currentUser;

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
      var products = (cartData['products'] as List)
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

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Address'),
        ),
        body: const Center(
          child: Text('Please log in to see your addresses'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Address'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('address')
            .where('email', isEqualTo: user.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var addresses = snapshot.data?.docs.map((doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList() ?? [];

          addresses.sort((a, b) {
            if (a['primaryAddress'] == true && b['primaryAddress'] != true) {
              return -1;
            } else if (a['primaryAddress'] != true && b['primaryAddress'] == true) {
              return 1;
            }
            return 0;
          });

          return ListView.separated(
            padding: const EdgeInsets.all(20.0),
            itemCount: addresses.length + 1,
            itemBuilder: (context, index) {
              if (index < addresses.length) {
                return TileAddress(
                  addressData: addresses[index],
                  isPrimary: addresses[index]['primaryAddress'] == true,
                );
              } else {
                return Column(
                  children: [
                    if (addresses.isEmpty)
                      const Text('No address found. Please, add an address'),
                    SizedBox(height: 24.0),
                    Button.outlined(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddAddress(),
                          ),
                        );
                      },
                      label: 'Add address',
                    ),
                  ],
                );
              }
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12.0),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<Map<String, String>>(
              stream: cartTotalStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('No item in the cart'));
                }

                String totalPrice = snapshot.data!['totalPrice']!;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Subtotal (Estimate)',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      totalPrice,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                );
              },
            ),
            const SpaceHeight(50.0),
            StreamBuilder<Map<String, String>>(
              stream: cartTotalStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Button.filled(
                    onPressed: () {},
                    label: 'Continue',
                  );
                }
                if (snapshot.hasError) {
                  return Button.filled(
                    onPressed: () {},
                    label: 'Continue',
                  );
                }
                if (!snapshot.hasData) {
                  return Button.filled(
                    onPressed: () {},
                    label: 'Continue',
                  );
                }

                String totalItem = snapshot.data!['totalItem']!;
                return Button.filled(
                  onPressed: () {
                    context.goNamed(
                      RouteConstants.orderDetail,
                      pathParameters: PathParameters(
                        rootTab: RootTab.order,
                      ).toMap(),
                    );
                  },
                  label: 'Chekout ($totalItem items)',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
