import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/spaces.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({super.key});

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  final TextEditingController withdrawAmountController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String balance = 'Loading...';
  String name = '';
  String bank = '';
  String accountNumber = '';
  bool withdrawAll = false;

  @override
  void initState() {
    super.initState();
    _loadBankAccountData();
    _loadWalletBalance();
  }

  String formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  Future<void> _loadWalletBalance() async {
    final user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    final email = user.email;

    try {
      final doc = await _firestore.collection('accounts').doc(email).get();

      if (doc.exists) {
        final data = doc.data()!;
        final walletBalance = data['wallet'] as int;
        setState(() {
          balance = formatPrice(walletBalance);
        });
      } else {
        setState(() {
          balance = 'Rp 0';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading balance: ${e.toString()}')),
      );
    }
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
        setState(() {
          name = data['name'] ?? '';
          bank = data['bank'] ?? '';
          accountNumber = data['accountNumber'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Image(
                          image: AssetImage('assets/images/coin.png'),
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 8.0),
                        const Text(
                          'Balance',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      balance,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SpaceHeight(24.0),
                _buildDetailRow('Nama Pemilik Rekening', name),
                const SpaceHeight(20.0),
                _buildDetailRow('Rekening Bank', bank),
                const SpaceHeight(20.0),
                _buildDetailRow('Nomor Rekening', accountNumber),
                const SpaceHeight(30.0),
              ],
            ),
          ),
          const SpaceHeight(30.0),
          SwitchListTile(
            title: const Text('Withdraw All Balance'),
            value: withdrawAll,
            onChanged: (bool value) {
              setState(() {
                withdrawAll = value;
                if (withdrawAll) {
                  withdrawAmountController.text = balance.replaceAll('Rp ', '').replaceAll('.', '');
                } else {
                  withdrawAmountController.clear();
                }
              });
            },
          ),
          const SpaceHeight(20.0),
          CustomTextField(
            controller: withdrawAmountController,
            keyboardType: TextInputType.number,
            label: 'Nominal Uang yang Diambil',// Disable input if withdrawAll is true
          ),
          const SpaceHeight(50.0),
          Button.filled(
            onPressed: () {
              // Implement withdrawal logic
            },
            label: 'Withdraw',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16.0),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
