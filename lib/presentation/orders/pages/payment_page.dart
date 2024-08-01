import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onlineshop_app/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_onlineshop_app/presentation/home/pages/home_page.dart';
import 'package:flutter_onlineshop_app/presentation/orders/models/order_request.dart';
import 'package:flutter_onlineshop_app/presentation/orders/models/order_response.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../../core/router/app_router.dart';
import '../../home/pages/dashboard_page.dart';
import '../models/cart_item.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onlineshop_app/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_onlineshop_app/presentation/home/pages/home_page.dart';
import 'package:flutter_onlineshop_app/presentation/orders/models/order_request.dart';
import 'package:flutter_onlineshop_app/presentation/orders/models/order_response.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../../core/assets/assets.gen.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../../core/router/app_router.dart';
import '../../home/pages/dashboard_page.dart';
import '../models/cart_item.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _loading = false; // Track loading state
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
          "totalPrice":
              NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(0)
        };
      }
      var cartData = snapshot.data() as Map<String, dynamic>;
      var products = (cartData['products'] as List)
          .map((product) => CartItem(
                name: product['name'],
                price: product['price'],
                originalPrice: product['original_price'],
                weight: product['weight'],
                image: product['image'],
                quantity: product['quantity'],
                addedBy: product['added_by'],
              ))
          .toList();

      int total = 0;
      for (var item in products) {
        total += item.price * item.quantity;
      }

      return {
        "totalItem": (products.length).toString(),
        "totalPrice": NumberFormat.currency(
                locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
            .format(total)
      };
    });
  }

  var deliveryMethod = "";

  File? _paymentProof;
  List<CartItem> _cartItems = [];
  final picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var destinationLatitude = 0.0;
  var destinationLongitude = 0.0;
  var destinationContactName = "";
  var destinationContactPhone = "";
  var destinationAddress = "";
  var destinationEmail = "";
  var biteshipId = "";
  // late Origin origin;
  // late Destination destination;
  // late Courier courier;
  var waybillId = "";
  // late Delivery delivery;

  @override
  initState() {
    super.initState();
    _initialize();
  }

  Future<void> _loadCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.email)
          .get();

      if (!doc.exists) {}

      var cartData = doc.data() as Map<String, dynamic>;
      var products = (cartData['products'] as List)
          .map((product) => CartItem(
                name: product['name'],
                price: product['price'],
                originalPrice: product['original_price'],
                weight: product['weight'],
                image: product['image'],
                quantity: product['quantity'],
                addedBy: product['added_by'],
              ))
          .toList();
      print("get data from firebase");

      for (var item in products) {
        print('Name: ${item.name}');
        print('-------------------------');
      }

      setState(() {
        _cartItems = products.cast<CartItem>();
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _initialize() async {
    final addressId = context.read<CheckoutBloc>().state.maybeWhen(
        orElse: () => "",
        loaded:
            (_, addressId, __, ___, ____, _____, ______, ________, _________) {
          return addressId;
        });
    final dMethod = context.read<CheckoutBloc>().state.maybeWhen(
        orElse: () => "",
        loaded:
            (_, addressId, __, ___, ____, _____, ______, delivery, _________) {
          return delivery;
        });
    setState(() {
      deliveryMethod = dMethod;
    });

    DocumentSnapshot addressSnapshot = await FirebaseFirestore.instance
        .collection('address')
        .doc(addressId)
        .get();

    if (addressSnapshot.exists) {
      var addressData = addressSnapshot.data() as Map<String, dynamic>;
      setState(() {
        destinationLatitude = addressData['latitude'];
        destinationLongitude = addressData['longitude'];
        destinationContactName = addressData['name'];
        destinationContactPhone = addressData['phoneNumber'];
        destinationEmail = addressData['email'];

        destinationAddress = addressData['address'];
      });
    } else {
      setState(() {
        destinationEmail = _auth.currentUser!.email!;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _paymentProof = File(pickedFile.path);
      }
    });
  }

  void buyNowTap(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      builder: (BuildContext modalContext) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                child: ColoredBox(
                  color: AppColors.light,
                  child: SizedBox(height: 8.0, width: 55.0),
                ),
              ),
              const SpaceHeight(20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pesananmu dalam Proses',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.light,
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SpaceHeight(20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Assets.images.processOrder.image(),
              ),
              const SpaceHeight(50.0),
              Row(
                children: [
                  Flexible(
                    child: Button.outlined(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardPage(currentTab: 2),
                          ),
                        );
                      },
                      label: 'Order Status',
                    ),
                  ),
                  const SpaceWidth(20.0),
                  Flexible(
                    child: Button.filled(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      label: 'Back to Home',
                    ),
                  ),
                ],
              ),
              const SpaceHeight(20.0),
            ],
          ),
        );
      },
    );
  }

  Future<OrderResponse> createOrder(OrderRequest orderRequest) async {
    final url = Uri.parse('https://api.biteship.com/v1/orders');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'biteship_test.eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoidGVzdGluZyIsInVzZXJJZCI6IjY2OThkOGQ2Y2U1MGNmMDAxMjU5OWI0MiIsImlhdCI6MTcyMTQ4NTQ5NX0.Aah5_jvzMG_6P7dNIT98IIVr0bo9vrWcDXC-9p81dKc', // Replace with your actual token
      },
      body: jsonEncode(orderRequest.toJson()),
    );

    print("order request body-----");

    print(jsonEncode(orderRequest.toJson()));

    if (response.statusCode == 200) {
      return OrderResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  }

  Future<void> _uploadPayment(BuildContext context) async {
    // Mulai indikator loading
    setState(() {
      _loading = true;
    });

    try {
      await _loadCart();
      final orderItems = CartItem.convertCartItemsToOrderItems(_cartItems, 200);

      if (_paymentProof == null) {
        // Jika tidak ada bukti pembayaran, hentikan indikator loading
        setState(() {
          _loading = false;
        });
        return;
      }

      var shippingService = "";
      var shippingCost = 0;
      var deliveryMethod = "";
      var subTotalPrice = 0;
      var oriSubTotalPrice = 0;
      var addressId = "";
      var serviceFee = 4000;
      var vendorEmail = orderItems[0].vendorEmail;

      context.read<CheckoutBloc>().state.maybeWhen(
        orElse: () {
          shippingService = "";
          shippingCost = 0;
          subTotalPrice = 0;
          deliveryMethod = "";
          oriSubTotalPrice = 0;
        },
        loaded: (_, address, ___, shippService, shippCost, ____, subTotal,
            dmethod, oriSubTotal) {
          print("shippingService: $shippingService");
          setState(() {
            shippingService = shippService;
            shippingCost = shippCost;
            subTotalPrice = subTotal;
            addressId = address;
            deliveryMethod = dmethod;
            oriSubTotalPrice = oriSubTotal;
          });
        },
      );

      DocumentSnapshot vendorSnapshot = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(vendorEmail)
          .get();

      if (vendorSnapshot.exists) {
        var vendorData = vendorSnapshot.data() as Map<String, dynamic>;

        var originLatitude = vendorData['latitude'];
        var originLongitude = vendorData['longitude'];

        if (deliveryMethod == 'Delivery') {
          final orderRequest = OrderRequest(
            shipperContactName: vendorData['name'],
            shipperContactPhone: vendorData['phone_number'],
            shipperContactEmail: vendorEmail,
            shipperOrganization: 'CapTreats',
            originContactName: vendorData['name'],
            originContactPhone: vendorData['phone_number'],
            originAddress: vendorData['address'],
            originNote: '',
            originCoordinate: Coordinate(
                latitude: originLatitude, longitude: originLongitude),
            destinationContactName: destinationContactName,
            destinationContactPhone: destinationContactPhone,
            destinationContactEmail: destinationEmail,
            destinationAddress: destinationAddress,
            destinationCoordinate: Coordinate(
                latitude: destinationLatitude, longitude: destinationLongitude),
            courierCompany:
                shippingService.split('-')[0].toLowerCase().replaceAll(" ", ""),
            courierType:
                shippingService.split('-')[1].toLowerCase().replaceAll(" ", ""),
            deliveryType: 'now',
            items: orderItems,
          );

          final orderResponse = await createOrder(orderRequest);
          setState(() {
            biteshipId = orderResponse.id;
            waybillId = orderResponse.courier.waybillId;
          });

          try {
            final User? user = _auth.currentUser;
            if (user != null) {
              final String email = user.email!;
              final String fileName =
                  'payment_proof_${DateTime.now().millisecondsSinceEpoch}.png';
              final Reference storageRef = FirebaseStorage.instance
                  .ref()
                  .child('payment_proofs/$fileName');
              await storageRef.putFile(_paymentProof!);
              final String downloadURL = await storageRef.getDownloadURL();

              final cartSnapshot =
                  await _firestore.collection('cart').doc(email).get();
              if (cartSnapshot.exists) {
                final cartData = cartSnapshot.data() as Map<String, dynamic>;
                final products = (cartData['products'] as List)
                    .map((product) => CartItem(
                          name: product['name'],
                          price: product['price'],
                          originalPrice: product['original_price'],
                          weight: product['weight'],
                          image: product['image'],
                          quantity: product['quantity'],
                          addedBy: product['added_by'],
                        ))
                    .toList();

                int total = 0;
                for (var item in products) {
                  total += item.price * item.quantity;
                }

                final DateTime now = DateTime.now();
                final CollectionReference userOrdersRef = _firestore
                    .collection('orders')
                    .doc(email)
                    .collection('user_orders');

                await userOrdersRef.add({
                  'items': products
                      .map((item) => {
                            'name': item.name,
                            'price': item.price,
                            'original_price': item.originalPrice,
                            'image': item.image,
                            'quantity': item.quantity,
                          })
                      .toList(),
                  'totalItem': products.length,
                  'totalPrice': shippingCost + subTotalPrice + serviceFee,
                  'payment_proof_url': downloadURL,
                  'delivery_method': deliveryMethod,
                  'customer_email': user.email,
                  'customer_phone': destinationContactPhone,
                  'vendor_email': vendorEmail,
                  'vendor_phone': vendorData['phone_number'],
                  'vendor_address': vendorData['address'],
                  'date': now,
                  'status': 'waiting verification',
                  'shipping_service': shippingService,
                  'service_fee': serviceFee,
                  'shipping_cost': shippingCost,
                  'sub_total_price': subTotalPrice,
                  'ori_sub_total_price': oriSubTotalPrice,
                  'biteship_id': biteshipId,
                  'waybill_id': waybillId,
                  'origin': {
                    'contact_name': orderResponse.origin.contactName,
                    'contact_phone': orderResponse.origin.contactPhone,
                    'address': orderResponse.origin.address,
                    'note': orderResponse.origin.note,
                    'coordinate': {
                      'latitude': orderResponse.origin.coordinate.latitude,
                      'longitude': orderResponse.origin.coordinate.longitude,
                    },
                  },
                  'destination': {
                    'contact_name': orderResponse.destination.contactName,
                    'contact_phone': orderResponse.destination.contactPhone,
                    'contact_email': orderResponse.destination.contactEmail,
                    'address': orderResponse.destination.address,
                    'note': orderResponse.destination.note,
                    'coordinate': {
                      'latitude': orderResponse.destination.coordinate.latitude,
                      'longitude':
                          orderResponse.destination.coordinate.longitude,
                    },
                  },
                  'delivery': {
                    'datetime': orderResponse.delivery.datetime,
                    'note': orderResponse.delivery.note,
                    'type': orderResponse.delivery.type,
                    'distance': orderResponse.delivery.distance,
                    'distance_unit': orderResponse.delivery.distanceUnit,
                  },
                  'shipper': {
                    'name': orderResponse.shipper.name,
                    'phone': orderResponse.shipper.phone,
                    'email': orderResponse.shipper.email,
                    'organization': orderResponse.shipper.organization,
                  },
                  'courier': {
                    'tracking_id': orderResponse.courier.trackingId,
                    'waybill_id': orderResponse.courier.waybillId,
                    'company': orderResponse.courier.company,
                    'name': orderResponse.courier.name,
                    'phone': orderResponse.courier.phone,
                    'type': orderResponse.courier.type,
                    'link': orderResponse.courier.link,
                    'routing_code': orderResponse.courier.routingCode,
                  },
                });
                await _firestore.collection('orders').doc(email).set({});
                await _firestore.collection('cart').doc(email).delete();
                print("Order successfully placed");
                context.read<CheckoutBloc>().add(CheckoutEvent.submitOrder());
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('Success'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Please wait for payment verification.'),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          buyNowTap(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            }
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to upload payment proof.')),
            );
          }
        } else {
          try {
            final User? user = _auth.currentUser;
            if (user != null) {
              final String email = user.email!;
              final String fileName =
                  'payment_proof_${DateTime.now().millisecondsSinceEpoch}.png';
              final Reference storageRef = FirebaseStorage.instance
                  .ref()
                  .child('payment_proofs/$fileName');
              await storageRef.putFile(_paymentProof!);
              final String downloadURL = await storageRef.getDownloadURL();

              final cartSnapshot =
                  await _firestore.collection('cart').doc(email).get();
              if (cartSnapshot.exists) {
                final cartData = cartSnapshot.data() as Map<String, dynamic>;
                final products = (cartData['products'] as List)
                    .map((product) => CartItem(
                          name: product['name'],
                          price: product['price'],
                          originalPrice: product['original_price'],
                          weight: product['weight'],
                          image: product['image'],
                          quantity: product['quantity'],
                          addedBy: product['added_by'],
                        ))
                    .toList();

                int total = 0;
                for (var item in products) {
                  total += item.price * item.quantity;
                }

                final DateTime now = DateTime.now();
                final CollectionReference userOrdersRef = _firestore
                    .collection('orders')
                    .doc(email)
                    .collection('user_orders');

                await userOrdersRef.add({
                  'items': products
                      .map((item) => {
                            'name': item.name,
                            'price': item.price,
                            'original_price': item.originalPrice,
                            'image': item.image,
                            'quantity': item.quantity,
                          })
                      .toList(),
                  'totalItem': products.length,
                  'totalPrice': shippingCost + subTotalPrice + serviceFee,
                  'payment_proof_url': downloadURL,
                  'delivery_method': deliveryMethod,
                  'customer_email': user.email,
                  'customer_phone': destinationContactPhone,
                  'vendor_email': vendorEmail,
                  'vendor_phone': vendorData['phone_number'],
                  'vendor_address': vendorData['address'],
                  'date': now,
                  'status': 'waiting verification',
                  'shipping_service': shippingService,
                  'service_fee': serviceFee,
                  'shipping_cost': shippingCost,
                  'sub_total_price': subTotalPrice,
                  'ori_sub_total_price': oriSubTotalPrice,
                  'biteship_id': biteshipId,
                  'waybill_id': waybillId,
                });
                await _firestore.collection('orders').doc(email).set({});
                await _firestore.collection('cart').doc(email).delete();
                print("Order successfully placed");
                context.read<CheckoutBloc>().add(CheckoutEvent.submitOrder());
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('Success'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Please wait for payment verification.'),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          buyNowTap(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            }
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to upload payment proof.')),
            );
          }
        }
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('An error occurred while processing your order.')),
      );
      // Hentikan indikator loading jika terjadi kesalahan
      setState(() {
        _loading = false;
      });
    }
  }




  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.all(16.0),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Panduan Pembayaran:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '1. Transfer total pembelian Anda ke rekening bank berikut:',
                          style: TextStyle(fontSize: 14),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ' • Bank Mandiri',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                ' • Nama Pemilik Rekening: Sulthon',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                ' • Nomor Rekening: xxxx',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '2. Unggah bukti pembayaran Anda.',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.all(16.0),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: _paymentProof == null
                        ? const Image(
                            image: AssetImage('assets/images/payment.png'),
                            height: 400,
                            width: 300,
                          )
                        : Image.file(
                            _paymentProof!,
                            height: 400,
                            width: 300,
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Button.filled(
                      label: _paymentProof == null
                          ? 'Upload Image'
                          : 'Submit Payment',
                      onPressed: _paymentProof == null
                          ? _pickImage
                          : () => _uploadPayment(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_loading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
