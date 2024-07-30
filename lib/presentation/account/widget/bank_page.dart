import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/spaces.dart';

class AccountBankPage extends StatefulWidget {
  const AccountBankPage({super.key});

  @override
  State<AccountBankPage> createState() => _AccountBankPageState();
}

class _AccountBankPageState extends State<AccountBankPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadBankAccountData();
  }

  Future<void> _loadBankAccountData() async {
    final user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    final email = user.email; // Use email as the document ID

    try {
      final doc = await _firestore.collection('bankAccounts').doc(email).get();

      if (doc.exists) {
        final data = doc.data()!;
        nameController.text = data['name'] ?? '';
        bankController.text = data['bank'] ?? '';
        accountNumberController.text = data['accountNumber'] ?? '';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: ${e.toString()}')),
      );
    }
  }

  Future<void> _registerBankAccount() async {
    final user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    final email = user.email; // Use email as the document ID
    final name = nameController.text.trim();
    final bank = bankController.text.trim();
    final accountNumber = accountNumberController.text.trim();

    if (name.isEmpty || bank.isEmpty || accountNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      await _firestore.collection('bankAccounts').doc(email!).set({
        'name': name,
        'bank': bank,
        'accountNumber': accountNumber,
        'email': user.email,
      });

      // Show a success dialog
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Bank account details saved successfully'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Navigate back to the previous page
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Bank'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        children: [
          const SpaceHeight(24.0),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image(
                      image: AssetImage('assets/images/coin.png'),
                      height: 30,
                      width: 30,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Income',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Rp 20.000',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SpaceHeight(24.0),
          CustomTextField(
            controller: nameController,
            keyboardType: TextInputType.name,
            label: 'Nama Pemilik Rekening',
          ),
          const SpaceHeight(20.0),
          CustomTextField(
            controller: bankController,
            keyboardType: TextInputType.text,
            label: 'Rekening Bank',
          ),
          const SpaceHeight(20.0),
          CustomTextField(
            controller: accountNumberController,
            keyboardType: TextInputType.number,
            label: 'Nomor Rekening',
          ),
          const SpaceHeight(50.0),
          Button.filled(
            onPressed: _registerBankAccount,
            label: 'Submit',
          ),
        ],
      ),
    );
  }
}
