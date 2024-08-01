import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlineshop_app/presentation/home/pages/home_page.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import '../../../core/router/app_router.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> _orderStream() {
    var email = user!.email;

    return db.collection('orders').snapshots().switchMap((ordersSnapshot) {
      var userOrdersStreams = ordersSnapshot.docs.map((orderDoc) {
        return orderDoc.reference.collection('user_orders').snapshots().map((userOrdersSnapshot) {
          return userOrdersSnapshot.docs.map((orderSubDoc) {
            var data = orderSubDoc.data() as Map<String, dynamic>;
            var vendorEmail = data['vendor_email'] as String?;
            var customerEmail = data['customer_email'] as String?;

            if ((vendorEmail == email && data["status"] != "waiting verification") || customerEmail == email) {
              return {
                "id": orderSubDoc.id,
                "waybillId": data['waybill_id'] ?? 'PICKUP',
                "status": data['status'] ?? 'Unknown',
                "itemCount": data['totalItem'] ?? 0,
                "price": data['totalPrice'] ?? 0.0,
                "vendor_email": data['vendor_email'] ?? '',
                "customer_email": data['customer_email'] ?? '',
              };
            } else {
              return null;
            }
          }).where((order) => order != null).toList();
        });
      }).toList();

      return CombineLatestStream.list(userOrdersStreams).map((ordersList) {
        return ordersList.expand((orders) => orders!).whereType<Map<String, dynamic>>().toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
        ),
        body: const Center(
          child: Text('No user logged in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _orderStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No orders found'),
            );
          }

          var allOrders = snapshot.data!;

          return ListView.builder(
            itemCount: allOrders.length,
            itemBuilder: (context, index) {
              var order = allOrders[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      RouteConstants.trackingOrder,
                      pathParameters: PathParameters().toMap(),
                      extra: "${order['id']}-${order['customer_email']}",
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
                                  'NO RESI: ${order['waybillId']}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              user!.email! == order['vendor_email']
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                        child: Center(
                                          child: Text(
                                            "From your customer",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: Colors.lightBlue,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                        child: Center(
                                          child: Text(
                                            "Your order",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Expanded(
                                child: Text('Status'),
                              ),
                              Text(order['status'])
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Expanded(
                                child: Text('Item'),
                              ),
                              Text(order['itemCount'].toString())
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Expanded(
                                child: Text('Total Harga'),
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
