import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlineshop_app/core/router/app_router.dart';
import 'package:flutter_onlineshop_app/data/models/requests/courier_cost_request_model.dart';
import 'package:flutter_onlineshop_app/presentation/orders/widgets/product_tile.dart';

import 'package:go_router/go_router.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/core.dart';
import '../models/track_record_model.dart';

class TrackingOrderPage extends StatefulWidget {
  final String orderId;
  const TrackingOrderPage({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  State<TrackingOrderPage> createState() => _TrackingOrderPageState();
}

class _TrackingOrderPageState extends State<TrackingOrderPage> {
  List<OrderItem> orders = [];
  
  final List<TrackRecordModel> trackRecords = [
    TrackRecordModel(
      title: 'Pesanan Anda belum dibayar',
      status: TrackRecordStatus.belumBayar,
      isActive: true,
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    TrackRecordModel(
      title: 'Pesanan Anda sedang disiapkan',
      status: TrackRecordStatus.dikemas,
      isActive: true,
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    TrackRecordModel(
      title: 'Pesanan Anda dalam pengiriman',
      status: TrackRecordStatus.dikirim,
      isActive: true,
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    TrackRecordModel(
      title: 'Pesanan Anda telah tiba',
      status: TrackRecordStatus.selesai,
      isActive: true,
      updatedAt: DateTime.now(),
    ),
  ];

  final user = FirebaseAuth.instance.currentUser;

    @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final fetchedOrders = await fetchOrderItems(widget.orderId);
    setState(() {
      orders = fetchedOrders;
    });
  }



  Future<List<OrderItem>> fetchOrderItems(String orderId) async {
    final orderSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc(user!.email) 
        .collection('user_orders')
        .doc(orderId)
        .get();

    if (orderSnapshot.exists) {
      final data = orderSnapshot.data() as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>;

      return items.map((item) {
        return OrderItem(
         name: item['name'],
         quantity: item['quantity'],
         price: item['price'],
         image: item['image'],
         
        );
      }).toList();
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Orders'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
           ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  itemBuilder: (context, index) => ProductTile(
                    data: orders[index],
                  ),
                  separatorBuilder: (context, index) =>
                      const SpaceHeight(16.0),
                ),
          const SpaceHeight(20.0),
                  // TrackingHorizontal(trackRecords: trackRecords),
                  Button.outlined(
                    onPressed: () {
                      context.pushNamed(
                        RouteConstants.shippingDetail,
                        pathParameters: PathParameters().toMap(),
                        extra: "resi",
                      );
                    },
                    label: 'Detail pelacakan pengiriman',
                  ),
                  const SpaceHeight(20.0),
                  const Text(
                    'Info Pengiriman',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SpaceHeight(20.0),
                  const Text(
                    'Alamat Pesanan',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "jalan raya ciputat",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SpaceHeight(16.0),
                  const Text(
                    'Penerima',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "ihsan",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
        ],
      )
    );
  }
}



// BlocBuilder<OrderDetailBloc, OrderDetailState>(
//         builder: (context, state) {
//           return state.maybeWhen(
//             orElse: () {
//               return const Center(
//                 child: Text('No Data'),
//               );
//             },
//             loaded: (orderDetail) {
//               return ListView(
//                 padding: const EdgeInsets.all(20.0),
//                 children: [
//                   ListView.separated(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: orders.length,
//                     itemBuilder: (context, index) => ProductTile(
//                       data: orderDetail.orderItems![index],
//                     ),
//                     separatorBuilder: (context, index) =>
//                         const SpaceHeight(16.0),
//                   ),
//                   const SpaceHeight(20.0),
//                   // TrackingHorizontal(trackRecords: trackRecords),
//                   Button.outlined(
//                     onPressed: () {
//                       context.pushNamed(
//                         RouteConstants.shippingDetail,
//                         pathParameters: PathParameters().toMap(),
//                         extra: orderDetail.shippingResi.toString(),
//                       );
//                     },
//                     label: 'Detail pelacakan pengiriman',
//                   ),
//                   const SpaceHeight(20.0),
//                   const Text(
//                     'Info Pengiriman',
//                     style: TextStyle(
//                       fontSize: 20,
//                     ),
//                   ),
//                   const SpaceHeight(20.0),
//                   const Text(
//                     'Alamat Pesanan',
//                     style: TextStyle(
//                       fontSize: 16,
//                     ),
//                   ),
//                   Text(
//                     orderDetail.address!.fullAddress!,
//                     style: TextStyle(
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SpaceHeight(16.0),
//                   const Text(
//                     'Penerima',
//                     style: TextStyle(
//                       fontSize: 16,
//                     ),
//                   ),
//                   Text(
//                     orderDetail.user!.name!,
//                     style: TextStyle(
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
