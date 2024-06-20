import 'package:flutter/material.dart';
import 'package:flutter_onlineshop_app/core/components/button_image.dart';
import 'package:flutter_onlineshop_app/core/components/price_text_field.dart';
import 'package:flutter_onlineshop_app/core/components/text_description.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_dropdown.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/spaces.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddProductPage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();

  String selectedCategory = 'Catering & Snack';

  final List<String> categories = [
    'Catering & Snack',
    'Bakery & Cake',
    'Beverage',
    'Ice Cream',
  ];

  @override
  void initState() {
    super.initState();
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
              label: 'Price'),
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
          TextDescription(
            controller: quill.QuillController.basic(),
              label: 'Description',
          ),
          const SpaceHeight(24.0),
          ButtonImage(
              label: 'Image',
              onPressed: (){},
            buttonText: 'Upload Image',
          ),
          const SpaceHeight(50.0),
          Button.filled(
            onPressed: () {},
            label: 'Add Product',
          ),
        ],
      ),
    );
  }
}
