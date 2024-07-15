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

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _loading = true;
    });

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc(user.email)
          .collection('user_orders')
          .get();

      var products = snapshot.docs.map((doc) {
        var data = doc.data();
        var items = (data['items'] as List)
            .map((item) => OrderItem(
          name: item['name'],
          price: item['price'],
          image: item['image'],
          quantity: item['quantity'],
        ))
            .toList();
        return items;
      }).expand((element) => element).toList();

      setState(() {
        _orderItems = products.cast<OrderItem>();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      // Handle error
    }
  }

  void _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Warning"),
          content: const Text("There are no items in the cart. Please, add items before checkout."),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          OrderCart(), // Assuming this widget displays the list of order items
          const SpaceHeight(50.0),
          // Row(
          //   children: [
          //     const Text(
          //       'Total',
          //       style: TextStyle(
          //         fontSize: 16,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //     const Spacer(),
          //     StreamBuilder<Map<String, String>>(
          //       stream: orderTotalStream(),
          //       builder: (context, snapshot) {
          //         if (snapshot.connectionState == ConnectionState.waiting) {
          //           return const CircularProgressIndicator();
          //         }
          //         if (snapshot.hasError) {
          //           return const Text('Error');
          //         }
          //         if (!snapshot.hasData) {
          //           return const Text('No item in the cart');
          //         }
          //         String totalPrice = snapshot.data!['totalPrice']!;
          //
          //         return Text(
          //           totalPrice,
          //           style: const TextStyle(
          //             fontSize: 16,
          //             fontWeight: FontWeight.w600,
          //           ),
          //         );
          //       },
          //     ),
          //   ],
          // ),
          // const SpaceHeight(40.0),
          // StreamBuilder<Map<String, String>>(
          //   stream: orderTotalStream(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Button.filled(
          //         onPressed: () async {
          //           final isAuth = await AuthLocalDatasource().isAuth();
          //           if (!isAuth) {
          //             context.pushNamed(RouteConstants.login);
          //           } else {
          //             context.goNamed(
          //               RouteConstants.address,
          //               pathParameters: PathParameters(
          //                 rootTab: RootTab.order,
          //               ).toMap(),
          //             );
          //           }
          //         },
          //         label: 'Checkout (0 item)', // Default label saat loading
          //       );
          //     }
          //     if (snapshot.hasError) {
          //       return Button.filled(
          //         onPressed: () async {
          //           final isAuth = await AuthLocalDatasource().isAuth();
          //           if (!isAuth) {
          //             _showWarningDialog(context);
          //           } else {
          //             _showWarningLogin(context);
          //           }
          //         },
          //         label: 'Checkout (0 item)', // Default label saat error
          //       );
          //     }
          //     if (!snapshot.hasData || snapshot.data!['totalItem'] == '0') {
          //       return Button.filled(
          //         onPressed: () async {
          //           final isAuth = await AuthLocalDatasource().isAuth();
          //           if (!isAuth) {
          //             _showWarningDialog(context);
          //           } else {
          //             _showWarningLogin(context);
          //           }
          //         },
          //         label: 'Checkout (0 item)',
          //       );
          //     }
          //
          //     String totalProducts = snapshot.data!['totalItem']!;
          //     return Button.filled(
          //       onPressed: () async {
          //         final isAuth = await AuthLocalDatasource().isAuth();
          //         if (!isAuth) {
          //           context.pushNamed(RouteConstants.address);
          //         } else {
          //           _showWarningLogin(context);
          //         }
          //       },
          //       label: 'Checkout ($totalProducts items)',
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  // Stream<Map<String, String>> orderTotalStream() {
  //   final user = FirebaseAuth.instance.currentUser;
  //
  //   return FirebaseFirestore.instance
  //       .collection('orders')
  //       .doc(user!.email)
  //       .collection('user_orders')
  //       .snapshots()
  //       .map((snapshot) {
  //     var items = snapshot.docs.map((doc) {
  //       var data = doc.data();
  //       return (data['items'] as List).map((item) => OrderItem(
  //         name: item['name'],
  //         price: item['price'],
  //         image: item['image'],
  //         quantity: item['quantity'],
  //       )).toList();
  //     }).expand((element) => element).toList();
  //
  //     int total = items.fold(0, (previousValue, item) => previousValue + (item.price * item.quantity));
  //
  //     return {
  //       "totalItem": items.length.toString(),
  //       "totalPrice": NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(total)
  //     };
  //   });
  // }
}
