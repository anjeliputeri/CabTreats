import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onlineshop_app/presentation/category/presentation/catering_category.dart';
import 'package:flutter_onlineshop_app/presentation/store/presentation/store_product.dart';
import 'package:shimmer/shimmer.dart';
import '../../home/bloc/category/category_bloc.dart';

class MenuStore extends StatefulWidget {
  const MenuStore({super.key});

  @override
  State<MenuStore> createState() => _MenuStoreState();
}

class _MenuStoreState extends State<MenuStore> {
  List<Map<String, dynamic>> _userProfiles = [];

  @override
  void initState() {
    context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
    _fetchUserData();
    super.initState();
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
    return _userProfiles.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enables horizontal scrolling
      child: Row(
        children: _userProfiles.map((user) {
          final imagePath = user['profile_image'] as String? ?? 'assets/images/user.png';
          final email = user['email'] as String? ?? ''; // Fetch the email
          final name = user['name'] as String? ?? '';

          print('Image URL: $imagePath'); // Print URL for debugging

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: SizedBox(
              height: 100,
              width: 92.5, // Fixed width for each button
              child: CategoryButton(
                imagePath: imagePath,
                label: user['name'] ?? 'No Name',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoreProduct(email: email, name: name), // Customize as needed
                    ),
                  );
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onPressed;

  const CategoryButton({
    required this.imagePath,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if imagePath is a URL or local asset
    final isNetworkImage = imagePath.startsWith('http') || imagePath.startsWith('https');

    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          ClipOval(
            child: isNetworkImage
                ? Image.network(
              imagePath,
              width: 55, // Fixed width for the image
              height: 55, // Fixed height for the image
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 55,
                    height: 55,
                    color: Colors.white,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                print('Error loading image: $error');
                return const Icon(Icons.error); // Placeholder for image loading error
              },
            )
                : Image.asset(
              imagePath,
              width: 55, // Fixed width for the image
              height: 55, // Fixed height for the image
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading image: $error');
                return const Icon(Icons.error); // Placeholder for image loading error
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14, // Smaller font size for the label
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis, // Display ellipsis for overflow
            maxLines: 1, // Limit text to two lines
          ),
        ],
      ),
    );
  }
}
