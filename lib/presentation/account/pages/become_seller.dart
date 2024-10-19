import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_onlineshop_app/core/constants/colors.dart';
import 'package:flutter_onlineshop_app/core/router/app_router.dart';
import 'package:flutter_onlineshop_app/presentation/account/bloc/pick_address/pick_address_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:provider/provider.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../address/models/city_model.dart';
import '../../address/models/province_model.dart';

class BecomeSeller extends StatefulWidget {
  const BecomeSeller({Key? key}) : super(key: key);

  @override
  State<BecomeSeller> createState() => _BecomeSellerState();
}

class _BecomeSellerState extends State<BecomeSeller> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final posCode = TextEditingController();
  bool isPrimaryAddress = false;

  double? selectedLatitude;
  double? selectedLongitude;

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _profileImageUrl;

  var strKey = 'c364bc54969f4a3b67bc4fec31e84bab';
  var strProvince;
  var strCity;
  var provinceId;

  bool isSeller = false;

  void fetchUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(user.email)
          .get();
      final data = userDoc.data();
      if (data != null) {
        setState(() {
          nameController.text = data['name'] ?? '';
          addressController.text = data['address'] ?? '';
          phoneNumberController.text = data['phone_number'] ?? '';
          posCode.text = data['postal_code'] ?? '';
          selectedLatitude = data['latitude'];
          selectedLongitude = data['longitude'];
          strProvince = data['province'];
          strCity = data['city'];
          isPrimaryAddress = data['is_primary_address'] ?? false;

          // Directly use the URL from Firestore
          if (data['profile_image'] != null) {
            final profileImageUrl = data['profile_image'] as String;
            _profileImageUrl = profileImageUrl; // Store URL as a string
          }
        });
      }
    }
  }

  void fetchUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final userRole = userDoc.data()?['role'] as String?;
      setState(() {
        isSeller = userRole == 'Seller';
      });
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchUserProfileStream() {
    final user = _auth.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('accounts')
          .doc(user.email)
          .snapshots();
    }
    return Stream.empty(); // Return empty stream if user is null
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Account saved successfully'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                context.goNamed(RouteConstants.login);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> _uploadProfileImage() async {
    if (_profileImage != null) {
      String imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child('profile_images/$imageName')
          .putFile(_profileImage!);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    }
    return null;
  }

  void _saveUser() async {
    context.read<PickAddressBloc>().state.maybeWhen(
          orElse: () => "",
          loaded: (lat, lng) {
            setState(() {
              selectedLatitude = lat;
              selectedLongitude = lng;
            });
          },
        );

    // Check if all required fields are filled
    if (nameController.text.isEmpty ||
        addressController.text.isEmpty ||
        selectedLatitude == null ||
        selectedLongitude == null ||
        strProvince == null ||
        strCity == null ||
        posCode.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        _profileImage == null) {
      // Show a warning dialog if any field is missing
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Warning'),
            content: const Text(
                'Please complete all required fields and select a profile image.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    final user = _auth.currentUser;
    if (user != null) {
      final userDocRef =
          FirebaseFirestore.instance.collection('accounts').doc(user.email);
      final userDocSnapshot = await userDocRef.get();
      final existingData = userDocSnapshot.data();
      final selfDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      Map<String, dynamic> updatedData = {
        'name': nameController.text,
        'address': addressController.text,
        'latitude': selectedLatitude,
        'longitude': selectedLongitude,
        'province': strProvince,
        'city': strCity,
        'postal_code': posCode.text,
        'phone_number': phoneNumberController.text,
        'is_primary_address': isPrimaryAddress,
        'profile_image':
            await _uploadProfileImage() ?? existingData?['profile_image'],
        'email': user.email,
      };

      if (userDocSnapshot.exists) {
        await userDocRef.update(updatedData);
        context
            .read<PickAddressBloc>()
            .add(const PickAddressEvent.update(0, 0));
      } else {
        await userDocRef.set(updatedData);
      }

      await selfDocRef.update({'role': 'Seller'});

      await FirebaseAuth.instance.signOut();

      _showSuccessDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Become Seller',
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: fetchUserProfileStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data!.data();

          if (data != null) {
            nameController.text = data['name'] ?? '';
            addressController.text = data['address'] ?? '';
            phoneNumberController.text = data['phone_number'] ?? '';
            posCode.text = data['postal_code'] ?? '';
            selectedLatitude = data['latitude'];
            selectedLongitude = data['longitude'];
            strProvince = data['province'];
            strCity = data['city'];
            isPrimaryAddress = data['is_primary_address'] ?? false;

            if (data['profile_image'] != null) {
              _profileImageUrl = data['profile_image'] as String;
            }
          }

          return ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!) as ImageProvider<Object>
                          : _profileImageUrl != null
                              ? NetworkImage(_profileImageUrl!)
                              : null,
                      child: (_profileImage == null && _profileImageUrl == null)
                          ? Icon(
                              isSeller ? Icons.store : Icons.person,
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
              const SizedBox(height: 20),
              CustomTextField(
                controller: nameController,
                label: 'Store Name',
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: addressController,
                label: 'Store Address',
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
                        hintText: strProvince ?? 'Province',
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
                      provinceId = value?.provinceId;
                    },
                    itemAsString: (item) => "${item.province}",
                    asyncItems: (text) async {
                      var response = await http.get(Uri.parse(
                          "https://api.rajaongkir.com/starter/province?key=${strKey}"));
                      List allProvinsi = (jsonDecode(response.body)
                          as Map<String, dynamic>)['rajaongkir']['results'];
                      var dataProvinsi =
                          ProvinceModel.fromJsonList(allProvinsi);
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
                            hintText: strCity ?? "City",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
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
                              "https://api.rajaongkir.com/starter/city?province=$provinceId&key=${strKey}"));
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
                                      offset:
                                          phoneNumberController.text.length),
                                );
                              }
                            },
                          ),
                          SizedBox(height: 24),
                          Container(
                            height: 500,
                            child: Center(
                              child: PlacePicker(
                                onPlacePicked: (result) {
                                  print(
                                      "longitude -- ${result.geometry!.location!.lat}");
                                  print(
                                      "longitude -- ${result.geometry!.location!.lng}");
                                  print(
                                      "address -- ${result.formattedAddress}");
                                  context.read<PickAddressBloc>().add(
                                      PickAddressEvent.update(
                                          result.geometry!.location!.lat,
                                          result.geometry!.location!.lng));
                                },
                                selectInitialPosition: true,
                                useCurrentLocation: true,
                                apiKey:
                                    "AIzaSyBBH1Fa9kcW8ThL-Ap2O-5E_kl2m8eT6L0",
                                initialPosition:
                                    const LatLng(-7.6978415, 110.4106371),
                              ),
                            ),
                          ),
                          // Container(
                          //   height: 400,
                          //   child: Center(
                          //       child: OpenStreetMapSearchAndPick(
                          //           buttonColor: AppColors.primary,
                          //           buttonText: 'Choose this location',
                          //           locationPinIconColor: AppColors.primary,
                          //           locationPinTextStyle: TextStyle(color: AppColors.primary),
                          //           onPicked: (pickedData) {
                          //             print("adresssss-----");
                          //             setState(() {
                          //               selectedLatitude = pickedData.latLong.latitude;
                          //               selectedLongitude = pickedData.latLong.longitude;
                          //             });
                          //             print("------------------adresss-----------------------");
                          //             print(pickedData.latLong.latitude);
                          //             print(pickedData.latLong.longitude);
                          //             print(pickedData.address);
                          //           })

                          //   ),
                          // ),
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
              ),
            ],
          );
        },
      ),
    );
  }
}
