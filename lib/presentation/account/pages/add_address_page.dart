import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlineshop_app/core/constants/colors.dart';
import 'package:flutter_onlineshop_app/presentation/address/pages/address_state.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../address/models/city_model.dart';
import '../../address/models/province_model.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final storeNameController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final posCode = TextEditingController();
  bool isPrimaryAddress = false;

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var strKey = '';
  var strProvince;
  var strCity;

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Account added successfully'),
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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _saveUser() async {
    if (nameController.text.isEmpty ||
        storeNameController.text.isEmpty ||
        addressController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        posCode.text.isEmpty) {
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
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc = FirebaseFirestore.instance.collection('accounts').doc(user.email);

        // Prepare data to be saved
        Map<String, dynamic> userData = {
          'store_name': storeNameController.text,
          'name': nameController.text,
          'address': addressController.text,
          'province': strProvince,
          'city': strCity,
          'postal_code': posCode.text,
          'phone_number': phoneNumberController.text,
          'is_primary_address': isPrimaryAddress,
        };

        // Add profile image if available
        if (_profileImage != null) {
          String imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
          TaskSnapshot snapshot = await FirebaseStorage.instance
              .ref()
              .child('profile_images/$imageName')
              .putFile(_profileImage!);

          String downloadUrl = await snapshot.ref.getDownloadURL();
          userData['profile_image'] = downloadUrl;
        }

        await userDoc.set(userData);

        Navigator.of(context).pop(); // Close the progress dialog
        _showSuccessDialog();
      } else {
        Navigator.of(context).pop(); // Close the progress dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the progress dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : null,
                  child: _profileImage == null
                      ? Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50,
                  )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomTextField(
            controller: storeNameController,
            label: 'Store Name',
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: nameController,
            label: 'Name',
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: addressController,
            label: 'Address',
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Province',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              DropdownSearch<ProvinceModel>(
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: "Province",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                ),
                onChanged: (value) {
                  strProvince = value?.province;
                },
                itemAsString: (item) => "${item.province}",
                asyncItems: (text) async {
                  var response = await http.get(Uri.parse(
                      "https://api.rajaongkir.com/starter/province?key=${strKey}"));
                  List allProvinsi = (jsonDecode(response.body)
                  as Map<String, dynamic>)['rajaongkir']['results'];
                  var dataProvinsi = ProvinceModel.fromJsonList(allProvinsi);
                  return dataProvinsi;
                },
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'City',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownSearch<CityModel>(
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: "City",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                    ),
                    onChanged: (value) {
                      strCity = "${value?.type} ${value?.cityName}";
                    },
                    itemAsString: (item) => "${item.type} ${item.cityName}",
                    asyncItems: (text) async {
                      var response = await http.get(Uri.parse(
                          "https://api.rajaongkir.com/starter/city?key=${strKey}"));
                      List allKota = (jsonDecode(response.body)
                      as Map<String, dynamic>)['rajaongkir']['results'];
                      var dataKota = CityModel.fromJsonList(allKota);
                      return dataKota;
                    },
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: posCode,
                        label: 'Postal Code',
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        controller: phoneNumberController,
                        label: 'Phone Number',
                        onChanged: (value) {
                          if (!value.startsWith('+62')) {
                            phoneNumberController.text = "+62" + value;
                            phoneNumberController.selection =
                                TextSelection.fromPosition(
                                  TextPosition(
                                      offset: phoneNumberController.text.length),
                                );
                          }
                        },
                      ),
                      const SizedBox(height: 50),
                      Button.filled(
                        onPressed: _saveUser,
                        label: 'Submit',
                      ),
                    ],
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
