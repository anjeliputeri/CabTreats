import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlineshop_app/presentation/home/pages/home_page.dart';
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

  File? _paymentProof;
  final picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
          padding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
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
                        MaterialPageRoute(builder:
                        (context) => DashboardPage(currentTab: 1),
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
                        Navigator.of(context).popUntil((route) => route.isFirst);
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

  Future<void> _uploadPayment(BuildContext context) async {
    setState(() {
      _loading = true; // Start loading indicator
    });

    if (_paymentProof == null) {
      setState(() {
        _loading = false; // Stop loading indicator
      });
      return;
    }

    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final String email = user.email!;
        final String fileName = 'payment_proof_${DateTime.now().millisecondsSinceEpoch}.png';
        final Reference storageRef = FirebaseStorage.instance.ref().child('payment_proofs/$fileName');
        await storageRef.putFile(_paymentProof!);
        final String downloadURL = await storageRef.getDownloadURL();

        // Save order directly instead of moving from cart
        final cartSnapshot = await _firestore.collection('cart').doc(email).get();
        if (cartSnapshot.exists) {
          final cartData = cartSnapshot.data() as Map<String, dynamic>;
          final products = (cartData['products'] as List).map((product) => CartItem(
            name: product['name'],
            price: product['price'],
            image: product['image'],
            quantity: product['quantity'],
          )).toList();

          int total = 0;
          for (var item in products) {
            total += item.price * item.quantity;
          }

          final DateTime now = DateTime.now();
          final CollectionReference userOrdersRef =
          _firestore.collection('orders').doc(email).collection('user_orders');

          await userOrdersRef.add({
            'items': products.map((item) => {
              'name': item.name,
              'price': item.price,
              'image': item.image,
              'quantity': item.quantity,
            }).toList(),
            'totalItem': products.length,
            'totalPrice': total,
            'payment_proof_url': downloadURL,
            'date': now,
            'status': 'Waiting Verification',
          });
          await _firestore.collection('cart').doc(email).delete();

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
    } finally {
      setState(() {
        _loading = false; // Stop loading indicator
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
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
                      label: _paymentProof == null ? 'Upload Image' : 'Submit Payment',
                      onPressed: _paymentProof == null ? _pickImage : () => _uploadPayment(context),
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
