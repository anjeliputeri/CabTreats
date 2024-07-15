import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../../core/components/spaces.dart';
import '../../../core/core.dart';
import '../models/order_item.dart';

class OrderCart extends StatefulWidget {
  @override
  State<OrderCart> createState() => _OrderCartState();
}

class _OrderCartState extends State<OrderCart> {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Center(
        child: Text('No user logged in'),
      );
    }

    return StreamBuilder<QuerySnapshot>(
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
          return Center(child: Text('No item in the cart'));
        }

        List<Map<String, dynamic>> orders = [];

        snapshot.data!.docs.forEach((order) {
          var orderData = order.data() as Map<String, dynamic>;
          var date = orderData['date'] as Timestamp;
          var items = orderData['items'] as List<dynamic>;
          var status = orderData['status'];

          items.forEach((item) {
            orders.add({
              'name': item['name'],
              'price': item['price'],
              'image': item['image'],
              'quantity': item['quantity'],
              'date': date,
              'status': status,
            });
          });
        });

        if (orders.isEmpty) {
          return Center(child: Text('No item in the cart'));
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: orders.length,
          itemBuilder: (context, index) {
            var item = orders[index];
            var totalPrice = item['price'] * item['quantity'];
            var date = (item['date'] as Timestamp).toDate();
            var formattedDate = DateFormat('dd MMM yyyy HH:mm').format(date);

            return Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Slidable(
                  endActionPane: ActionPane(
                    extentRatio: 0.25,
                    motion: StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          // Implement delete action here
                        },
                        backgroundColor: AppColors.primary.withOpacity(0.44),
                        foregroundColor: AppColors.red,
                        icon: Icons.delete_outlined,
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(10.0),
                        ),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.stroke),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Image.network(
                            item['image'],
                            width: 68.0,
                            height: 68.0,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 68.0,
                                    height: 68.0,
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
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Text(
                                    'Rp ${totalPrice.toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    item['status'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
    );
  }
}
