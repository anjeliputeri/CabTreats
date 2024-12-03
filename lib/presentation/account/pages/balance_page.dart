import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlineshop_app/presentation/account/pages/add_account.dart';
import 'package:flutter_onlineshop_app/presentation/account/pages/bank_page.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/spaces.dart';
import '../../../core/core.dart';

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
  bool _loading = true;
  bool _isButtonDisabled = true;

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
    setState(() {
      _loading = true;
    });

    final user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      setState(() {
        _loading = false;
      });
      return;
    }

    final email = user.email;

    try {
      final doc = await _firestore.collection('accounts').doc(email).get();

      if (doc.exists) {
        final data = doc.data()!;
        final walletBalance = data['wallet'] as int?;

        setState(() {
          _loading = false;
          balance = walletBalance != null ? formatPrice(walletBalance) : 'Rp 0';
          _isButtonDisabled = walletBalance == null || walletBalance <= 0;
        });
      } else {
        setState(() {
          _showAccountDataIncompleteDialog();
          _loading = false;
          balance = 'Rp 0';
          _isButtonDisabled = true;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
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

  void _showAccountDataIncompleteDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Acoount Incomplete'),
            content: Text('You need to complete your account data to proceed!'),
            actions: <Widget>[
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    _navigateToAccountDataPage();
                  },
                  child: Text('OK'),
              ),
            ],
          );
        },
    );
  }

  void _showAccountBankIncompleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bank Data Incomplete'),
          content: Text('You need to complete your bank data.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToBankDataPage();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToAccountDataPage() {
    Navigator.push(
        context,
    MaterialPageRoute(builder: (context) => AddAccount()),
    );
  }

  void _navigateToBankDataPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountBankPage()), // Ganti sesuai dengan rute yang sesuai
    );
  }

  Future<void> _updateWalletBalance(int newBalance) async {
    final user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    final email = user.email;

    try {
      await _firestore.collection('accounts').doc(email).update({'wallet': newBalance});
      // Reload the wallet balance after the update
      await _loadWalletBalance();
      // Optionally, show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Withdrawal successful!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating balance: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance'),
      ),
      body: _loading
        ? Center(child: CircularProgressIndicator())
      : ListView(
        children: [
          const SpaceHeight(24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
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
          ),
          const SpaceHeight(12.0),
          SwitchListTile(
            title: const Text('Pengambilan Semua'),
            value: withdrawAll,
            onChanged: (bool value) {
              setState(() {
                withdrawAll = value;
                if (withdrawAll) {
                  withdrawAmountController.text = balance.replaceAll('Rp ', '').replaceAll('.', '');
                } else {
                  withdrawAmountController.clear();
                }

                // Re-evaluate button state based on the text field's value
                int withdrawAmount = int.tryParse(withdrawAmountController.text) ?? 0;
                int actualBalance = int.tryParse(balance.replaceAll('Rp ', '').replaceAll('.', '')) ?? 0;
                _isButtonDisabled = withdrawAmount <= 0 || actualBalance <= 0 || name.isEmpty || bank.isEmpty || accountNumber.isEmpty;
              });
            },
          ),
          const SpaceHeight(12.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomTextField(
              controller: withdrawAmountController,
              keyboardType: TextInputType.number,
              // label: 'Nominal Pengambilan Uang',
              label: 'Nominal Pengambilan Uang'
              onChanged: (value) {
                setState(() {
                  int actualBalance = int.tryParse(balance.replaceAll('Rp ', '').replaceAll('.', '')) ?? 0;
                  int withdrawAmount = int.tryParse(value) ?? 0;

                  _isButtonDisabled = value.isEmpty || withdrawAmount <= 0 || withdrawAmount == 0 || actualBalance <= 0 || name.isEmpty || bank.isEmpty || accountNumber.isEmpty;
                });
              },
            ),
          ),

          const SpaceHeight(50.0),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: _isButtonDisabled ? null : () async {
                if (name.isEmpty || bank.isEmpty || accountNumber.isEmpty) {
                  _showAccountBankIncompleteDialog();
                  } else if (withdrawAmountController == 0){
                  _isButtonDisabled = true;
                } else if (withdrawAmountController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Warning'),
                        content: const Text('Please enter an amount to withdraw!'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  int withdrawAmount = int.tryParse(withdrawAmountController.text.replaceAll('.', '').replaceAll('Rp ', '')) ?? 0;
                  int actualBalance = int.tryParse(balance.replaceAll('.', '').replaceAll('Rp ', '')) ?? 0;

                  if (withdrawAmount > actualBalance) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Insufficient Balance'),
                          content: const Text('You do not have enough balance to withdraw this amount.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Withdrawal Request'),
                        content: const Text('Please wait, it may take up to 7 days for the money to be transferred to your account.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await _updateWalletBalance(actualBalance - withdrawAmount);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              }, child: Text('Submit',
            style: TextStyle(
                color: Colors.white
            ),
            ),
            ),
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
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

}
