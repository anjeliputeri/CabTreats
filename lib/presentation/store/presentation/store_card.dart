import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_onlineshop_app/presentation/product/pages/detail_product.dart';

class StoreCard extends StatefulWidget {
  const StoreCard({Key? key}) : super(key: key);

  @override
  State<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  List<Map<String, dynamic>> _userProfiles = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
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
        title: const Text('Store'),
      ),
      body: _userProfiles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(8.0), // Adjust padding for tighter fit
        child: GridView.builder(
          itemCount: _userProfiles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of cards per row
            childAspectRatio: 2 / 3, // Adjusted aspect ratio for a more compact card
            mainAxisSpacing: 8.0, // Spacing between rows
            crossAxisSpacing: 8.0, // Spacing between columns
          ),
          itemBuilder: (context, index) {
            var user = _userProfiles[index];
            var name = user['name'];
            var imageUrl = user['profile_image'];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailProduct(product: user),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0), // Reduced border radius
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Stack(
                          children: [
                            Image.network(
                              imageUrl ?? 'assets/images/user.png', // Default image if URL is null
                              width: double.infinity,
                              height: 125.0, // Further reduced height for the image
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    width: double.infinity,
                                    height: 125.0, // Further reduced height for the placeholder
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0), // Reduced spacing
                    Text(
                      name ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 12, // Smaller font size
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
