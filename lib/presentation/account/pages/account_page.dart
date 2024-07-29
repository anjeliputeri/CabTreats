import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onlineshop_app/presentation/account/pages/add_account.dart';
import 'package:flutter_onlineshop_app/presentation/account/pages/balance_page.dart';
import 'package:flutter_onlineshop_app/presentation/orders/pages/order_page.dart';
import 'package:flutter_onlineshop_app/presentation/orders/pages/payment_page.dart';
import 'package:flutter_onlineshop_app/presentation/product/pages/product_page.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core.dart';
import '../../../core/router/app_router.dart';
import '../../auth/bloc/logout/logout_bloc.dart';
import 'bank_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  var db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  bool isSeller = false;

  @override
  void initState() {
    super.initState();
    fetchUserRole();
  }

  void fetchUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final userRole = userDoc.data()?['role'] as String?;
      setState(() {
        isSeller = userRole == 'Seller';
      });
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    context.goNamed(RouteConstants.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              isSeller ? Icons.storefront : Icons.person_outlined,
              color: AppColors.primary,
            ),
            title: Text(
              isSeller ? 'Store' : 'Profile',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAccount(),
                ),
              );
            },
          ),
          if (isSeller)
            ListTile(
            leading: Icon(
              Icons.file_copy_outlined,
              color: AppColors.primary,
            ),
            title: const Text(
              'Product',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(),
                ),
              );
            },
          ),
          if (isSeller)
            ListTile(
            leading: Assets.icons.creditcard.svg(),
            title: const Text(
              'Account Bank',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountBankPage(),
                ),
              );
            },
          ),
          if (isSeller)
            ListTile(
              leading: Icon(
                Icons.monetization_on_outlined,
                color: AppColors.primary,
              ),
              title: const Text(
                'Balance',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BalancePage(),
                  ),
                );
              },
            ),
          BlocConsumer<LogoutBloc, LogoutState>(
            listener: (context, state) {
              state.maybeWhen(
                  orElse: () {},
                  loaded: () {
                    context.goNamed(
                      RouteConstants.root,
                      pathParameters: PathParameters().toMap(),
                    );
                  },
                  error: (message) {
                    context.goNamed(
                      RouteConstants.login,
                    );
                  }
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                  orElse: () {
                    return ListTile(
                      leading: const Icon(
                        Icons.login_outlined,
                        color: AppColors.primary,
                      ),
                      title: const Text(
                        'Logout',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () {
                        logout();
                      },
                    );
                  },
                  loading: () {
                    return const CircularProgressIndicator();
                  }
              );
            },
          ),
        ],
      ),
    );
  }
}