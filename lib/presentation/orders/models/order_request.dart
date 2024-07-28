import 'package:flutter_onlineshop_app/data/models/requests/courier_cost_request_model.dart';

class OrderRequest {
  final String shipperContactName;
  final String shipperContactPhone;
  final String shipperContactEmail;
  final String shipperOrganization;
  final String originContactName;
  final String originContactPhone;
  final String originAddress;
  final String originNote;
  final Coordinate originCoordinate;
  final String destinationContactName;
  final String destinationContactPhone;
  final String destinationContactEmail;
  final String destinationAddress;
  final Coordinate destinationCoordinate;
  final String courierCompany;
  final String courierType;
  final String deliveryType;
  final List<OrderItem> items;

  OrderRequest({
    required this.shipperContactName,
    required this.shipperContactPhone,
    required this.shipperContactEmail,
    required this.shipperOrganization,
    required this.originContactName,
    required this.originContactPhone,
    required this.originAddress,
    required this.originNote,
    required this.originCoordinate,
    required this.destinationContactName,
    required this.destinationContactPhone,
    required this.destinationContactEmail,
    required this.destinationAddress,
    required this.destinationCoordinate,
    required this.courierCompany,
    required this.courierType,
    required this.deliveryType,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'shipper_contact_name': shipperContactName,
      'shipper_contact_phone': shipperContactPhone,
      'shipper_contact_email': shipperContactEmail,
      'shipper_organization': shipperOrganization,
      'origin_contact_name': originContactName,
      'origin_contact_phone': originContactPhone,
      'origin_address': originAddress,
      'origin_note': originNote,
      'origin_coordinate': originCoordinate.toJson(),
      'destination_contact_name': destinationContactName,
      'destination_contact_phone': destinationContactPhone,
      'destination_contact_email': destinationContactEmail,
      'destination_address': destinationAddress,
      'destination_coordinate': destinationCoordinate.toJson(),
      'courier_company': courierCompany,
      'courier_type': courierType,
      'delivery_type': deliveryType,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class Coordinate {
  final double latitude;
  final double longitude;

  Coordinate({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Coordinate.fromJson(Map<String, dynamic> json) {
    return Coordinate(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

