import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onlineshop_app/core/constants/variables.dart';
import 'package:flutter_onlineshop_app/core/core.dart';
import 'package:flutter_onlineshop_app/data/models/requests/courier_cost_request_model.dart';
import 'package:flutter_onlineshop_app/data/models/responses/courier_cost_response_model.dart';
import 'package:flutter_onlineshop_app/presentation/orders/bloc/cost/cost_bloc.dart';
import 'package:flutter_onlineshop_app/presentation/orders/models/cart_item.dart';
import 'package:flutter_onlineshop_app/presentation/orders/widgets/tile_cart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/router/app_router.dart';
import '../../home/bloc/checkout/checkout_bloc.dart';
import '../../home/models/product_model.dart';
import '../../home/models/store_model.dart';
import '../models/shipping_model.dart';
import '../widgets/cart_tile.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  List<CartItem> _cartItems = [];
  bool _loading = true;
  final user = FirebaseAuth.instance.currentUser;
  var subtotal = 0;
  var deliveryMethod = "";
  var _orderTime = "now";
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
     context.read<CheckoutBloc>()
          .add(const CheckoutEvent.addOrderTime('now'));
    final dMethod = context.read<CheckoutBloc>().state.maybeWhen(
        orElse: () => "",
        loaded: (_, addressId, __, ___, ____, _____, ______, delivery, _________, __________) {
          return delivery;
        });
    setState(() {
      deliveryMethod = dMethod;
    });
  }

  Stream<Map<String, String>> cartTotalStream() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Orders'),
        actions: [
          IconButton(
            onPressed: () {
              context.goNamed(
                RouteConstants.keranjang,
                pathParameters: PathParameters().toMap(),
              );
            },
            icon: Assets.icons.cart.svg(height: 24.0),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          TileCart(),
          const SpaceHeight(36.0),
          deliveryMethod == 'Delivery' ? _SelectShipping() : Container(),
          // const _ShippingSelected(),
          SizedBox(height: 16),
          Column(
          children: [

            _buildOptionCard('Order Sekarang', 'now'),
            SizedBox(height: 16),
            _buildOptionCard('Order Nanti', 'later'),
          ],
        ),
          
          const SpaceHeight(36.0),
          const Divider(),
          const SpaceHeight(8.0),
          const Text(
            'Detail Belanja :',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SpaceHeight(12.0),
          Row(
            children: [
              const Text(
                'Waktu Order',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
               Text(
                _orderTime == 'now' ? 'Sekarang': "${_formatDate(_selectedDate!)} - ${_formatTime(_selectedTime!)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                'Total Harga (Produk)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              StreamBuilder<Map<String, String>>(
                stream: cartTotalStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text('Error');
                  }
                  if (!snapshot.hasData) {
                    return const Text('No item in the cart');
                  }
                  String totalPrice = snapshot.data!['totalPrice']!;
                  subtotal =
                      int.parse(totalPrice.split('Rp ')[1].replaceAll('.', ''));

                  return Text(
                    totalPrice,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ],
          ),
          const SpaceHeight(5.0),
          Row(
            children: [
              const Text(
                'Total Ongkos Kirim',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              BlocBuilder<CheckoutBloc, CheckoutState>(
                builder: (context, state) {
                  final shippingCost = state.maybeWhen(
                    orElse: () => 0,
                    loaded: (_, __, ___, ____, shippingCost, ______, _______,
                        ________, _________, __________) {
                      return shippingCost;
                    },
                  );
                  return Text(
                    shippingCost.currencyFormatRp,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ],
          ),
          const SpaceHeight(8.0),
          Row(
            children: [
              const Text(
                'Biaya Layanan',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                4000.currencyFormatRp,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                'Pilihan Kurir',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              BlocBuilder<CheckoutBloc, CheckoutState>(
                builder: (context, state) {
                  final shippingCost = state.maybeWhen(
                    orElse: () => 0,
                    loaded: (_, __, ___, ____, shippingCost, ______, _______,
                        ________, _________, __________) {
                      return shippingCost;
                    },
                  );
                  final shippingProvider = state.maybeWhen(
                    orElse: () => '',
                    loaded: (_, __, ___, shipperName, _____, ______, _______,
                        ________, _________, __________) {
                      return shipperName;
                    },
                  );
                  return Text(
                    shippingProvider == "" ? "-": shippingProvider,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ],
          ),
          const Divider(),
          const SpaceHeight(24.0),
          Row(
            children: [
              const Text(
                'Total Belanja',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              BlocBuilder<CheckoutBloc, CheckoutState>(
                builder: (context, state) {
                  final total = state.maybeWhen(
                    orElse: () => 0,
                    loaded: (products, addressId, __, ___, shippingCost, ______,
                        total, ________, _________, __________) {
                      return shippingCost + total + 4000;
                    },
                  );
                  return Column(
                    children: [
                      Text(
                        total.currencyFormatRp,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          const SpaceHeight(20.0),
          BlocBuilder<CheckoutBloc, CheckoutState>(builder: (context, state) {
            final shippingCost = state.maybeWhen(
              orElse: () => 0,
              loaded: (_, ___, __, shippingService, shippingCost, _____, ______,
                  ________, _________, __________) {
                return shippingCost;
              },
            );
            return Button.filled(
              disabled: shippingCost == 0 && deliveryMethod == "Delivery",
              onPressed: () {
                context.goNamed(
                  RouteConstants.payment,
                  pathParameters: PathParameters().toMap(),
                );
              },
              label: 'Lanjut Bayar',
            );
          }),
        ],
      ),
    );
  }


  Widget _buildOptionCard(String title, String value) {
    return GestureDetector(
      onTap: () {
        if (value == 'later') {
          _showDateTimePicker(context);
        } else {
          context.read<CheckoutBloc>()
          .add(const CheckoutEvent.addOrderTime('now'));
          setState(() {
            _orderTime = value;
          });
        }
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: _orderTime == value ? AppColors.primary : Colors.grey,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 18)),
              Radio<String>(
                value: value,
                groupValue: _orderTime,
                onChanged: (String? newValue) {
                  if (newValue == 'later') {
                    _showDateTimePicker(context);
                  } else {
                    setState(() {
                      _orderTime = newValue!;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

   Future<void> _showDateTimePicker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        context.read<CheckoutBloc>()
          .add(CheckoutEvent.addOrderTime("${_formatDate(pickedDate)} - ${_formatTime(pickedTime)}"));
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
          _orderTime = 'later'; 
        });
      } else {
        _resetSelection();
      }
    } else {
      _resetSelection();
    }
  }

  void _resetSelection() {
    context.read<CheckoutBloc>()
          .add(const CheckoutEvent.addOrderTime('now'));
    setState(() {
      _orderTime = 'now'; // Revert to 'now' if date or time is not selected
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date); 
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt); 
  }
}

class _SelectShipping extends StatefulWidget {
  const _SelectShipping();

  @override
  State<_SelectShipping> createState() => _SelectShippingState();
}

class _SelectShippingState extends State<_SelectShipping> {
  List<CourierCost> courierCostList = [];
  bool isLoading = false;
  List<CartItem> _cartItems = [];
  bool isCourierFetched = false;
  bool _loading = true;

  @override
  initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadCart();
    final addressId = context.read<CheckoutBloc>().state.maybeWhen(
        orElse: () => "",
        loaded: (_, addressId, __, ___, ____, _____, ______, ________, _________, __________) {
          return addressId;
        });

    DocumentSnapshot addressSnapshot = await FirebaseFirestore.instance
        .collection('address')
        .doc(addressId)
        .get();

    if (addressSnapshot.exists) {
      var addressData = addressSnapshot.data() as Map<String, dynamic>;
      var destinationLatitude = addressData['latitude'].toString();
      var destinationLongitude = addressData['longitude'].toString();
      _fetchCourierCosts(destinationLatitude, destinationLongitude);
    }
  }

  Future<void> _loadCart() async {
    print("-------load cart----------");
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not logged in");
      return;
    }

    print("email--------");
    print(user.email);

    setState(() {
      _loading = true;
    });

    try {
      print("get data cart using ${user.email}");
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.email)
          .get();

      if (!doc.exists) {
        print("document not found");
        setState(() {
          _loading = false;
        });
        return;
      }

      print("document found");

      var cartData = doc.data() as Map<String, dynamic>;
      var products = (cartData['products'] as List).map((product) {
        return CartItem(
          name: product['name'],
          price: product['price'],
          originalPrice: product['original_price'],
          weight: product['weight'],
          image: product['image'],
          quantity: product['quantity'],
          addedBy: product['added_by'],
        );
      }).toList();

      print("get data from firebase");

      for (var item in products) {
        print('Name: ${item.name}');
        print('-------------------------');
      }

      setState(() {
        _cartItems = products.cast<CartItem>();
        _loading = false;
      });
    } catch (e) {
      print("Error loading cart: $e");
      setState(() {
        _loading = false;
      });
    }
  }

  Future<List<CourierCost>> checkCourierCost(
      CourierCostRequestModel requestModel) async {
    final url = Uri.parse('https://api.biteship.com/v1/rates/couriers');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': Variables.biteShipKey,
      },
      body: jsonEncode(requestModel.toJson()),
    );

    print("courier request body-----");

    print(jsonEncode(requestModel.toJson()));

    if (response.statusCode == 200) {
      print("-------fetch courier response 200----------");
      final data = jsonDecode(response.body);
      List<dynamic> pricingList = data['pricing'];
      print(data['pricing']);
      return pricingList.map((json) => CourierCost.fromJson(json)).toList();
    } else {
      print("-------fetch courier response failed----------");
      print(response.body);
      // Handle error response
      throw Exception('Failed to load pricing');
    }
  }

  Future<void> _fetchCourierCosts(
      String destinationLatitude, String destinationLongitude) async {
    // await _loadCart();

    print("-------fetch courier----------");

    final orderItems = CartItem.convertCartItemsToOrderItems(_cartItems, 200);
    print(_cartItems.length);
    print(orderItems.length);
    String vendorEmail = orderItems[0].vendorEmail;
    print(vendorEmail);
    print("convert cart items to order item");

    DocumentSnapshot vendorSnapshot = await FirebaseFirestore.instance
        .collection('accounts')
        .doc(vendorEmail)
        .get();

    if (vendorSnapshot.exists) {
      var vendorData = vendorSnapshot.data() as Map<String, dynamic>;
      var originLatitude = vendorData['latitude'].toString();
      var originLongitude = vendorData['longitude'].toString();

      try {
        print("call api courier");
        final courierCostRequest = CourierCostRequestModel(
            originLatitude: originLatitude,
            originLongitude: originLongitude,
            destinationLatitude: destinationLatitude,
            destinationLongitude: destinationLongitude,
            courier: "grab,gojek",
            orderItems: orderItems);
        List<CourierCost> costs = await checkCourierCost(courierCostRequest);
        for (var item in costs) {
          print('Courier: ${item.company}');
          print('Cost: ${item.price}');
          print('-------------------------');
        }
        setState(() {
          courierCostList = costs;
          isLoading = false;
          isCourierFetched = true;
        });
      } catch (e) {
        print(e);
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('Vendor data not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onSelectShippingTap() async {
      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: AppColors.white,
        builder: (BuildContext context) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    child: ColoredBox(
                      color: AppColors.light,
                      child: SizedBox(height: 8.0, width: 55.0),
                    ),
                  ),
                ),
                const SpaceHeight(20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Metode Pengiriman',
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
                const SpaceHeight(18.0),
                const SpaceHeight(30.0),
                const Divider(color: AppColors.stroke),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: courierCostList.length,
                        separatorBuilder: (context, index) =>
                            const Divider(color: AppColors.stroke),
                        itemBuilder: (context, index) {
                          final item = courierCostList[index];
                          return ListTile(
                            onTap: () => {
                              context.read<CheckoutBloc>().add(
                                  CheckoutEvent.addShippingService(
                                      "${item.courierName} - ${item.type}",
                                      item.price)),
                              context.pop()
                            },
                            title: Text(
                              '${item.courierName} - ${item.type} (${item.price.currencyFormatRp})',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Estimasi ${item.duration}'),
                          );
                        },
                      ),
                BlocBuilder<CostBloc, CostState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () {
                        return const SizedBox();
                      },
                      loaded: (costResponseModel) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = costResponseModel
                                .rajaongkir!.results![0].costs![index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: () {
                                context.read<CheckoutBloc>().add(
                                      CheckoutEvent.addShippingService(
                                          'jne', item.cost![0].value!),
                                    );
                                context.pop();
                              },
                              title: Text(
                                  '${item.service} - ${item.description} (${item.cost![0].value!.currencyFormatRp})'),
                              subtitle:
                                  Text('Estimasi ${item.cost![0].etd} Hari'),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const Divider(color: AppColors.stroke),
                          itemCount: costResponseModel
                              .rajaongkir!.results![0].costs!.length,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return GestureDetector(
      onTap: onSelectShippingTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.stroke),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pilih Pengiriman',
              style: TextStyle(fontSize: 16),
            ),
            Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _ShippingSelected extends StatelessWidget {
  const _ShippingSelected();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.stroke),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Reguler',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                Text(
                  'Edit',
                  style: TextStyle(fontSize: 16),
                ),
                SpaceWidth(4.0),
                Icon(Icons.chevron_right),
              ],
            ),
            SpaceHeight(12.0),
            Text(
              'JNE (Rp. 25.000)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text('Estimasi tiba 2 Januari 2024'),
          ],
        ),
      ),
    );
  }
}
