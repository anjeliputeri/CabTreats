import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlineshop_app/presentation/chat/pages/chat_screen.dart';
import 'package:flutter_onlineshop_app/presentation/store/presentation/store_product.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/components/buttons.dart';

class DetailStore extends StatefulWidget {
  final String email;
  final String name;

  const DetailStore({Key? key, required this.email, required this.name}) : super(key: key);

  @override
  _DetailStoreState createState() => _DetailStoreState();
}

class _DetailStoreState extends State<DetailStore> {
  List<Map<String, dynamic>> _userProfiles = [];
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    _fetchUserData();
    super.initState();
  }

  Stream<DocumentSnapshot> fetchAccount() {
    return db.collection('accounts').doc(widget.email).snapshots();
  }

  Future<void> _fetchUserData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('accounts').get();
      List<Map<String, dynamic>> userProfiles = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      setState(() {
        _userProfiles = userProfiles;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Store'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: fetchAccount(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var profileData = snapshot.data!.data() as Map<String, dynamic>;
                        var profileImage = profileData['profile_image'] ?? '';
                        var name = profileData['name'] ?? 'Data not found';
                        var province = profileData['province'] ?? 'Data not found';
                        var city = profileData['city'] ?? 'Data not found';
                        var address = profileData['address'] ?? 'Data not found';
                        var postCod = profileData['postal_code'] ?? 'Data not found';
                        var phone = profileData['phone_number'] ?? 'Data not found';

                        return Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: profileImage.isNotEmpty
                                  ? Image.network(
                                profileImage,
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: MediaQuery.of(context).size.width * 0.5,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.9,
                                        height: MediaQuery.of(context).size.width * 0.5,
                                        color: Colors.grey[300],
                                      ),
                                    );
                                  }
                                },
                              )
                                  : Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  height: MediaQuery.of(context).size.width * 0.5,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      province,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      city,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      address,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      postCod,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      phone,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: MediaQuery.of(context).size.width * 0.5,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 16),
                              Container(
                                width: 200,
                                height: 20,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Button.outlined(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoreProduct(email: widget.email, name: widget.name),
                            ),
                          );
                        },
                        label: 'View Product',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Button.filled(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(email: widget.email, name: widget.name),
                            ),
                          );
                        },
                        label: 'Chat Now',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
