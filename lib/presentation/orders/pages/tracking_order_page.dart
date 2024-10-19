import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlineshop_app/core/components/buttons.dart';
import 'package:flutter_onlineshop_app/core/core.dart';
import 'package:flutter_onlineshop_app/core/router/app_router.dart';
import 'package:flutter_onlineshop_app/data/models/requests/courier_cost_request_model.dart';
import 'package:flutter_onlineshop_app/presentation/orders/pages/tracking_order_webview.dart';
import 'package:flutter_onlineshop_app/presentation/orders/widgets/product_tile.dart';
import 'package:go_router/go_router.dart';
import '../../../core/components/spaces.dart';

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
  Map<String, dynamic> order = {};
  bool _isLoading = true;

  final user = FirebaseAuth.instance.currentUser;

  var orderID = "";

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() {
      _isLoading = true;
    });

    print("Fetching orders--------");
    print(widget.orderId);
    var orderId = widget.orderId.split('-')[0];
    var email = widget.orderId.split('-')[1];

    setState(() {
      orderID = orderId;
    });

    final fetchedOrders = await fetchOrderItems(orderId, email);

    setState(() {
      orders = fetchedOrders;
      _isLoading = false;
    });
  }

  Future<List<OrderItem>> fetchOrderItems(String orderId, email) async {
    final orderSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc(email)
        .collection('user_orders')
        .doc(orderId)
        .get();

    if (orderSnapshot.exists) {
      final data = orderSnapshot.data() as Map<String, dynamic>;
      setState(() {
        order = data;
      });
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

  Future<void> updateOrderStatus({
    required String customerEmail,
    required String orderId,
    required String status,
  }) async {
    try {
      final orderDocRef = FirebaseFirestore.instance
          .collection('orders')
          .doc(customerEmail)
          .collection('user_orders')
          .doc(orderId);

      await orderDocRef.update({
        'status': status,
      });
    } catch (error) {
      print("Error updating status: $error");
    }
  }

  var statusColors = {
    "waiting verification": Color.fromARGB(255, 243, 149, 33),
    "paid": Color.fromARGB(255, 16, 185, 109),
    "vendor approved": Color.fromARGB(255, 149, 33, 243),
    "order processed": Color.fromARGB(255, 33, 149, 243),
    "shipping": Color.fromARGB(255, 243, 149, 33),
    "delivered": Color.fromARGB(255, 243, 33, 149),
    "completed": Color.fromARGB(255, 33, 243, 149),
    "rejected": Color.fromARGB(255, 243, 33, 33),
  };

  var statusMessages = {
    "waiting verification": "Menunggu verifikasi pembayaran",
    "paid": "Pembayaran diterima, menunggu persetujuan vendor",
    "vendor approved": "Vendor telah menyetujui pesanan Anda",
    "order processed": "Pesanan Anda sedang diproses",
    "shipping": "Pesanan Anda sedang dikirim",
    "delivered": "Pesanan Anda telah sampai",
    "completed": "Pesanan selesai",
    "rejected": "Pesanan ditolak",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Orders'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  statusColors[order["status"]] ?? Colors.grey,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                order["status"]
                                        ?.replaceAll("_", " ")
                                        .toUpperCase() ??
                                    "",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                      statusMessages[order["status"]] ?? "")),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Divider(
                  color: const Color.fromARGB(255, 215, 213, 213),
                  height: 20,
                ),
                order["delivery_method"] == 'Delivery'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildSection(
                            iconColor: Colors.red,
                            title: 'Diambil dari',
                            placeName: "${order["origin"]["contact_name"]}",
                            address: order["origin"]["address"],
                          ),
                          buildSection(
                            iconColor: Colors.green,
                            title: 'Diantar ke',
                            placeName: order["destination"]["address"],
                            address:
                                "${order["destination"]["contact_name"]} (${order["destination"]["contact_phone"]})",
                          ),
                        ],
                      )
                    : buildSection(
                        iconColor: Colors.green,
                        title: 'Ambil pesananmu di',
                        placeName: "${order["vendor_phone"]}",
                        address: order["vendor_address"],
                      ),
                Divider(
                  color: const Color.fromARGB(255, 215, 213, 213),
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: const Text(
                    'Rincian Pesananmu',
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  itemBuilder: (context, index) => ProductTile(
                    data: orders[index],
                  ),
                  separatorBuilder: (context, index) => const SpaceHeight(16.0),
                ),
                Divider(
                  color: const Color.fromARGB(255, 215, 213, 213),
                  height: 20,
                ),
                _buildRow("Pengiriman",
                    "${order["order_time"] == 'now' ? 'Sekarang' : order["order_time"]}",
                    childTextEnabled: order["vendor_email"] == user!.email),
                _buildRow("Subtotal Pesanan (${order["totalItem"]} menu)",
                    "${(order["sub_total_price"] as int).currencyFormatRp}"),
                _buildRow("Biaya Pengiriman",
                    "${(order["shipping_cost"] as int).currencyFormatRp}"),
                _buildRow("Biaya Layanan", "${4000.currencyFormatRp}"),
                _buildRow(
                    "Total", "${(order["totalPrice"] as int).currencyFormatRp}",
                    isTotal: true),
                SizedBox(height: 20),
                Button.outlined(
                    onPressed: () {
                      context.pushNamed(
                        RouteConstants.shippingDetail,
                        pathParameters: PathParameters().toMap(),
                        extra:
                            "${order["waybill_id"]}_${order["courier"]["company"]}",
                      );
                    },
                    label: 'Lacak Pengiriman'),
                SizedBox(
                  height: 10,
                ),
                if(order["courier"]["link"] != null)
                Button.filled(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackingOrderWebview(
                            url:
                                order["courier"]["link"],
                          ),
                        ),
                      );
                    },
                    label: 'Lacak Live Tracking'),
                SizedBox(
                  height: 10,
                ),
                if (order["vendor_email"] == user!.email)
                  order["status"] == "paid"
                      ? Button.filled(
                          onPressed: () async {
                            await updateOrderStatus(
                                customerEmail: order["customer_email"],
                                orderId: orderID,
                                status: "order processed");
                            context.pop();
                          },
                          label: 'Proses pesanan')
                      : SizedBox(),
                order["status"] == "order processed"
                    ? Button.filled(
                        onPressed: () async {
                          await showModalBottomSheet(
                          context: context, 
                          useSafeArea: true,
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                              ), 
                              child: LiveTrackingInputForm(orderId: orderID, customerEmail: order["customer_email"],),
                            );
                          });
                          context.pop();
                          // await updateOrderStatus(
                          //     customerEmail: order["customer_email"],
                          //     orderId: orderID,
                          //     status: "shipping");
                        },
                        label: 'Pesanan siap dikirimkan')
                    : SizedBox()
              ],
            ),
    );
  }

  Widget buildSection({
    required Color iconColor,
    required String title,
    required String placeName,
    required String address,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.circle,
                  color: iconColor,
                  size: 10,
                ),
                SizedBox(width: 5),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              placeName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              address,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value,
      {bool isDiscount = false,
      bool isTotal = false,
      bool childTextEnabled = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isTotal ? 18 : 16,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isTotal ? 18 : 16,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isDiscount ? Colors.red : Colors.black,
                  decoration: isDiscount
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ],
          ),
          if (childTextEnabled == true)
            const Text(
                "Pesankan jasa kirim untuk antar pesanan pelanggan ke alamat tujuan",
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 18, 17, 17),
                )),
        ],
      ),
    );
  }
}


class LiveTrackingInputForm extends StatefulWidget {
  final String orderId;
  final String customerEmail;

  const LiveTrackingInputForm({Key? key, required this.orderId, required this.customerEmail}) : super(key: key);

  @override
  _LiveTrackingInputFormState createState() => _LiveTrackingInputFormState();
}

class _LiveTrackingInputFormState extends State<LiveTrackingInputForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _trackingLinkController = TextEditingController();


  Future<void> updateLinkTracking({
    required String customerEmail,
    required String orderId,
  }) async {
    try {
      final orderDocRef = FirebaseFirestore.instance
          .collection('orders')
          .doc(customerEmail)
          .collection('user_orders')
          .doc(orderId);

      await orderDocRef.update({
        'courier': {
          'link': _trackingLinkController.text,
        },
        'status': 'shipping'
      });

    } catch (error) {
      print("Error updating status: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Agar bottom sheet menyesuaikan konten
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
            'Live Tracking Pengiriman (Gojek, Grab)',
            style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
          ),
            ],
          ),
         
          SizedBox(height: 10),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _trackingLinkController,
              decoration: InputDecoration(
                labelText: 'Link Tracking',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Link tracking tidak boleh kosong';
                }
                if (!Uri.parse(value).isAbsolute) {
                  return 'Masukkan link yang valid';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 20),
          Button.filled(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                String link = _trackingLinkController.text;
                await updateLinkTracking(
                  customerEmail: widget.customerEmail,
                  orderId: widget.orderId,
                );
                // Lakukan sesuatu dengan link, seperti navigasi ke halaman lain atau penyimpanan
                Navigator.pop(context); // Menutup bottom sheet
              }
            },
            label: 'Submit',
          ),
        ],
      ),
    );
  }
}
