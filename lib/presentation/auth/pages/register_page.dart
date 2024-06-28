import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlineshop_app/core/components/components.dart';
import 'package:go_router/go_router.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/core.dart';
import '../../../core/router/app_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  String selectedRole = 'Buyer';
  bool _obscurePassword = true;

  final List<String> role = [
    'Buyer',
    'Seller'
  ];

  Future<void> _addUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty || nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hello, please complete the data below to register a new account'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      String uid = userCredential.user!.uid;

      await db.collection('users').doc(uid).set({
        'name': nameController.text,
        'email': emailController.text,
        'role': selectedRole,
      });

      Navigator.of(context).pop();
      _showSuccessDialog();

      nameController.clear();
      emailController.clear();
      passwordController.clear();
      setState(() {
        selectedRole = 'Buyer';
      });

      context.goNamed(
        RouteConstants.login,
      );

    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'An error occurred'),
        ),
      );
    }
  }

  void _showSuccessDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('User added successfully'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
              ),
            ],
          );
        },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
        children: [
          const Text(
            'Register Account',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Text(
            'Hello, please complete the data below to register a new account',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SpaceHeight(50.0),
          CustomTextField(
            controller: nameController,
            suffixIcon: Icon(Icons.person, color: Colors.grey),
            keyboardType: TextInputType.name,
            label: 'Name',
          ),
          const SpaceHeight(20.0),
          CustomTextField(
            controller: emailController,
            suffixIcon: Icon(Icons.email_outlined, color: Colors.grey),
            keyboardType: TextInputType.emailAddress,
            label: 'Email',
          ),
          const SpaceHeight(20.0),
          CustomTextField(
            controller: passwordController,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            keyboardType: TextInputType.visiblePassword,
            label: 'Password',
          ),
          const SpaceHeight(20.0),
          CustomDropdown<String>(
            value: selectedRole,
            items: role,
            label: 'Role',
            onChanged: (value) {
              setState(() {
                selectedRole = value!;
              });
            },
          ),
          const SpaceHeight(50.0),
          Button.filled(
            onPressed: _addUser,
            label: 'Register',
          ),
          const SpaceHeight(50.0),
          InkWell(
            onTap: () {
              context.goNamed(RouteConstants.login);
            },
            child: const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Already Account? ',
                    style: TextStyle(
                      color: AppColors.primary,
                    ),
                  ),
                  TextSpan(
                    text: 'Login Now',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
