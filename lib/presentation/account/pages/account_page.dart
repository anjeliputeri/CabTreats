import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onlineshop_app/presentation/account/pages/add_account.dart';
import 'package:flutter_onlineshop_app/presentation/orders/pages/order_page.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core.dart';
import '../../../core/router/app_router.dart';
import '../../auth/bloc/logout/logout_bloc.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Assets.icons.user.svg(),
            title: const Text(
              'Profile',
              style: TextStyle(
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
          ListTile(
            leading: Assets.icons.bag.svg(),
            title: const Text(
              'Order',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
              MaterialPageRoute(builder:
              (context) => OrderPage(),
              ),
              );
            },
          ),
          ListTile(
            leading: Assets.icons.creditcard.svg(),
            title: const Text(
              'Payment',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {},
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
                  });
            },
            builder: (context, state) {
              return state.maybeWhen(orElse: () {
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
                    context.read<LogoutBloc>().add(const LogoutEvent.logout());
                  },
                );
              }, loading: () {
                return const CircularProgressIndicator();
              });
            },
          )
        ],
      ),
    );
  }
}
