import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_onlineshop_app/core/components/button_image.dart';
import 'package:flutter_onlineshop_app/core/components/price_text_field.dart';
import 'package:flutter_onlineshop_app/core/components/text_description.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_dropdown.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/spaces.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final quill.QuillController descriptionController = quill.QuillController.basic();

  String selectedCategory = 'Catering & Snack';
  String buttonText = 'Upload Image';
  bool isImageUploaded = false;

  final List<String> categories = [
    'Catering & Snack',
    'Cake & Bakery',
    'Beverage',
    'Ice Cream',
  ];

  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        buttonText = 'Image Selected';
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) {
      return null;
    }

    final ref = FirebaseStorage.instance.ref().child('products').child(DateTime.now().toString());
    final uploadTask = ref.putFile(_imageFile!);

    await uploadTask.whenComplete(() => null);

    return ref.getDownloadURL();
  }

  Future<void> _addProduct() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please, fill in all fields')),
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
      final imageUrl = await _uploadImage();
      final String priceString = priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
      final int price = int.parse(priceString);

      final data = {
        'name': nameController.text,
        'price': price,
        'category': selectedCategory,
        'description': descriptionController.document.toDelta().toJson(),
        'image': imageUrl,
      };

      await db.collection(selectedCategory).add(data);

      Navigator.of(context).pop(); // Close the loading dialog
      _showSuccessDialog();

      nameController.clear();
      priceController.clear();
      descriptionController.clear();
      setState(() {
        selectedCategory = 'Catering & Snack';
        buttonText = 'Upload Image';
        isImageUploaded = false;
        _imageFile = null;
      });
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $e')),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Product added successfully'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          CustomTextField(
            controller: nameController,
            label: 'Name',
          ),
          const SpaceHeight(24.0),
          PriceTextField(
            controller: priceController,
            label: 'Price',
          ),
          const SpaceHeight(24.0),
          CustomDropdown<String>(
            value: selectedCategory,
            items: categories,
            label: 'Category',
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
              });
            },
          ),
          const SpaceHeight(24.0),
          ButtonImage(
            label: 'Image',
            onPressed: () {
              _pickImage();
            },
            buttonText: buttonText,
          ),
          const SpaceHeight(24.0),
          TextDescription(
            controller: descriptionController,
            label: 'Description',
          ),
          const SpaceHeight(50.0),
          Button.filled(
            onPressed: _addProduct,
            label: 'Add Product',
          ),
        ],
      ),
    );
  }
}
