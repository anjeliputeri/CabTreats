import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlineshop_app/presentation/auth/pages/login_page.dart';
import 'package:flutter_onlineshop_app/presentation/home/pages/home_page.dart';
import 'package:flutter_onlineshop_app/presentation/orders/widgets/order_cart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/core.dart';
import '../../../core/router/app_router.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../models/order_item.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<OrderItem> _orderItems = [];
  bool _loading = true;
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  List<Map<String, dynamic>> processOrderData(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'waybill_id': data['waybill_id'] ?? 'Pickup',
        'status': data['status'] ?? 'Unknown',
        'itemCount': data['totalItem'] ?? 0,
        'price': data['totalPrice'] ?? 0.0,
      };
    }).toList();
  }

  void _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Warning"),
          content: const Text(
              "There are no items in the cart. Please, add items before checkout."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        body: Center(
          child: Text('No user logged in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db
            .collection('orders')
            .doc(user!.email)
            .collection('user_orders')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No orders found'));
          }

          var orders = processOrderData(snapshot.data!);

          if (orders.isEmpty) {
            return Center(child: Text('No item in the cart'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      RouteConstants.trackingOrder,
                      pathParameters: PathParameters().toMap(),
                      extra: order['id'],
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'NO RESI: ${order['waybill_id']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                height: 20,
                                child: Button.filled(
                                  onPressed: () => {},
                                  label: "Lacak",
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Status',
                                ),
                              ),
                              Text(order['status'])
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Item',
                                ),
                              ),
                              Text(order['itemCount'].toString())
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Total Harga',
                                ),
                              ),
                              Text(
                                  'Rp ${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(order['price'])}')
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
