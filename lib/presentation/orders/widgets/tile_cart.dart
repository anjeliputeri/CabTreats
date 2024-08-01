import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onlineshop_app/core/constants/variables.dart';
import 'package:flutter_onlineshop_app/presentation/home/models/product_quantity.dart';
import 'package:flutter_onlineshop_app/presentation/orders/models/cart_provider.dart';
import 'package:flutter_onlineshop_app/presentation/orders/models/model_cart.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/components/spaces.dart';
import '../../../core/core.dart';
import '../../home/bloc/checkout/checkout_bloc.dart';
import '../models/cart_item.dart';
import '../models/cart_model.dart';

class TileCart extends StatefulWidget {
  @override
  State<TileCart> createState() => _TileCartState();
}

class _TileCartState extends State<TileCart> {
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(
        child: Text('No user logged in'),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: StreamBuilder<DocumentSnapshot>(
        stream: db.collection('cart').doc(user.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No item in the cart'));
          }

          var cartData = snapshot.data!.data() as Map<String, dynamic>;
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

          Provider.of<CartProvider>(context, listen: false)
              .setCartItems(products);

          print("Products count: ${products.length}");

          return Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: cartProvider.items.length,
                itemBuilder: (context, index) {
                  var item = cartProvider.items[index];
                  var totalPrice = item.price * item.quantity;

                  return Padding(
                    key: ValueKey('$index-${item.quantity}'),
                    padding: const EdgeInsets.only(top: 5.0),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      child: Slidable(
                        endActionPane: ActionPane(
                          extentRatio: 0.25,
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                cartProvider.deleteItem(index);
                              },
                              backgroundColor:
                                  AppColors.primary.withOpacity(0.44),
                              foregroundColor: AppColors.red,
                              icon: Icons.delete_outlined,
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(10.0),
                              ),
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14.0, vertical: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.stroke),
                          ),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    child: Image.network(
                                      item.image,
                                      width: 68.0,
                                      height: 68.0,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 5.0),
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
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                    child: InkWell(
                                      onTap: () {
                                        cartProvider.decrementQuantity(index);
                                      },
                                      child: const ColoredBox(
                                        color: AppColors.primary,
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.remove,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SpaceWidth(4.0),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Center(
                                          child: Text(
                                            item.quantity.toString(),
                                            textAlign: TextAlign.center,
                                          ),
                                        )),
                                  ),
                                  const SpaceWidth(4.0),
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                    child: InkWell(
                                      onTap: () {
                                        cartProvider.incrementQuantity(index);
                                      },
                                      child: const ColoredBox(
                                        color: AppColors.primary,
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.add,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
          );
        },
      ),
    );
  }
}
