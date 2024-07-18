import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onlineshop_app/core/constants/colors.dart';
import 'package:flutter_onlineshop_app/data/models/responses/address_response_model.dart';
import 'package:flutter_onlineshop_app/data/models/responses/subdistrict_response_model.dart';
import 'package:flutter_onlineshop_app/presentation/address/bloc/add_address/add_address_bloc.dart';
import 'package:flutter_onlineshop_app/presentation/address/models/city_model.dart';
import 'package:flutter_onlineshop_app/presentation/address/pages/address_state.dart';
import 'package:flutter_onlineshop_app/presentation/home/pages/home_page.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
// import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/custom_dropdown.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/spaces.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/requests/address_request_model.dart';
import '../../../data/models/responses/city_response_model.dart';
import '../../../data/models/responses/province_response_model.dart';
import '../bloc/address/address_bloc.dart';
import '../bloc/city/city_bloc.dart';
import '../bloc/province/province_bloc.dart';
import '../bloc/subdistrict/subdistrict_bloc.dart';
import 'package:http/http.dart' as http;
import '../models/province_model.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  var controller = Get.put(AddressStateController());

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final posCode = TextEditingController();
  bool isPrimaryAddress = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var strKey = '';
  var strProvince;
  var strCity;

  double? selectedLatitude;
  double? selectedLongitude;
  Map<String, dynamic>? selectedAddress;

  void _saveAddress() async {
    final user = _auth.currentUser;

    if (user != null) {
      if (nameController.text.isEmpty ||
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
        await FirebaseFirestore.instance
            .collection('address')
            .where('email', isEqualTo: user.email)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) async {
            await doc.reference.update({'primaryAddress': false});
          });
        });

        await FirebaseFirestore.instance.collection('address').add({
          'name': nameController.text,
          'address': addressController.text,
          'phoneNumber': phoneNumberController.text,
          'posCode': posCode.text,
          'email': user.email,
          'primaryAddress': isPrimaryAddress,
          'province': strProvince,
          'city': strCity,
          'latitude': selectedLatitude,
          'longitude': selectedLongitude,
          'pickedAddress': selectedAddress,
        });

        Navigator.of(context).pop();
        _showSuccessDialog();

        nameController.clear();
        addressController.clear();
        phoneNumberController.clear();
        posCode.clear();
        strProvince = null;
        strCity = null;
        selectedLatitude = null;
        selectedLongitude = null;
        selectedAddress = null;
        setState(() {
          isPrimaryAddress = false;
        });
      } catch (e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save address: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user logged in')),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Address added successfully'),
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Add Address'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 400,
                child: Center(
                      child: OpenStreetMapSearchAndPick(
                          buttonColor: AppColors.primary,
                          buttonText: 'Set Current Location',
                          locationPinIconColor: AppColors.primary,
                          locationPinTextStyle: TextStyle(color: AppColors.primary),
                          onPicked: (pickedData) {
                            print("adresssss-----");
                            setState(() {
                              selectedLatitude = pickedData.latLong.latitude;
                              selectedLongitude = pickedData.latLong.longitude;
                              selectedAddress = pickedData.address;
                            });
                            print("------------------adresss-----------------------");
                            print(pickedData.latLong.latitude);
                            print(pickedData.latLong.longitude);
                            print(pickedData.address);
                          })

                ),
              ),
              const SpaceHeight(24.0),
              CustomTextField(
                controller: nameController,
                label: 'Name',
              ),
              const SpaceHeight(24.0),
              CustomTextField(
                controller: addressController,
                label: 'Address',
              ),
              const SpaceHeight(24.0),
              const Text(
                'Province',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SpaceHeight(12.0),
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
              const SpaceHeight(24.0),
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
                  const SpaceHeight(12.0),
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
                  const SpaceHeight(24.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: posCode,
                        label: 'Postal Code',
                      ),
                      const SpaceHeight(24.0),
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
                      const SpaceHeight(50.0),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Set as a primary address',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Switch(
                            value: isPrimaryAddress,
                            onChanged: (value) {
                              setState(() {
                                isPrimaryAddress = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SpaceHeight(16.0),
                      Button.filled(
                        onPressed: _saveAddress,
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