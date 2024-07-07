import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onlineshop_app/presentation/address/pages/add_address.dart';
import 'package:flutter_onlineshop_app/presentation/address/widgets/tile_address.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart'; // Import collection package

import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/core.dart';
import '../../../core/router/app_router.dart';
import '../../home/bloc/checkout/checkout_bloc.dart';

class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
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

          // Sort the addresses, putting primaryAddress at the top
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
            itemCount: addresses.length + 1, // Tambahkan satu untuk tombol add address
            itemBuilder: (context, index) {
              if (index < addresses.length) {
                // Menampilkan tile address
                return TileAddress(
                  addressData: addresses[index],
                  isPrimary: addresses[index]['primaryAddress'] == true,
                );
              } else {
                // Menampilkan tombol add address
                return Column(
                  children: [
                    Text('No address found. Please, add an address'),
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
            separatorBuilder: (context, index) => const SizedBox(height: 12.0), // SizedBox sebagai separator
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal (Estimate)',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                BlocBuilder<CheckoutBloc, CheckoutState>(
                  builder: (context, state) {
                    final subtotal = state.maybeWhen(
                      orElse: () => 0,
                      loaded: (checkout, _, __, ___, ____, _____) {
                        return checkout.fold<int>(
                          0,
                              (previousValue, element) =>
                          previousValue +
                              (element.quantity * element.product.price!),
                        );
                      },
                    );
                    return Text(
                      subtotal.currencyFormatRp,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SpaceHeight(50.0),
            Button.filled(
              onPressed: () {
                context.goNamed(
                  RouteConstants.orderDetail,
                  pathParameters: PathParameters(
                    rootTab: RootTab.order,
                  ).toMap(),
                );
              },
              label: 'Continue',
            ),
          ],
        ),
      ),
    );
  }
}
