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

  bool isDataLoaded = false; // Flag to check if data is loaded

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

    final email = user.email;

    try {
      final doc = await _firestore.collection('bankAccounts').doc(email).get();

      if (doc.exists) {
        final data = doc.data()!;
        nameController.text = data['name'] ?? '';
        bankController.text = data['bank'] ?? '';
        accountNumberController.text = data['accountNumber'] ?? '';
        isDataLoaded = true; // Set the flag to true once data is loaded
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

    final email = user.email;
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
      await _firestore.collection('bankAccounts').doc(email).set({
        'name': name,
        'bank': bank,
        'accountNumber': accountNumber,
        'email': user.email,
      }, SetOptions(merge: true)); // Merge the data if the document already exists

      // Show a success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
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
            label: isDataLoaded ? 'Update' : 'Submit', // Change label if data exists
          ),
        ],
      ),
    );
  }
}
