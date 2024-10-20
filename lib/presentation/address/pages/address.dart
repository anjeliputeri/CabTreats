import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_onlineshop_app/core/constants/colors.dart';
import 'package:flutter_onlineshop_app/presentation/orders/models/cart_item.dart';
import 'package:intl/intl.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../address/pages/add_address.dart';
import '../../address/widgets/tile_address.dart';
import '../../orders/pages/payment_page.dart';

class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  String _deliveryMethod = 'Pick Up';

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: Row(
                key: ValueKey<String>(_deliveryMethod),
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _deliveryMethod == 'Pick Up' ? AppColors.primary : Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: AppColors.primary, width: 1),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _deliveryMethod = 'Pick Up';
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.store,
                            color: _deliveryMethod == 'Pick Up' ? Colors.white : AppColors.primary,
                          ),
                          SizedBox(width: 8.0),
                          Text('Pick Up',
                            style: TextStyle(
                              color: _deliveryMethod == 'Pick Up' ? Colors.white : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SpaceWidth(8.0),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _deliveryMethod == 'Delivery' ?  AppColors.primary : Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: AppColors.primary, width: 1),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _deliveryMethod = 'Delivery';
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delivery_dining,
                            color: _deliveryMethod == 'Delivery' ? Colors.white : AppColors.primary,
                          ),
                          SizedBox(width: 8.0),
                          Text('Delivery',
                            style: TextStyle(
                              color: _deliveryMethod == 'Delivery' ? Colors.white : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
          ),
        ],
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(),
                      ),
                    );
                  },
                  label: 'Checkout ($totalItem items)',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
