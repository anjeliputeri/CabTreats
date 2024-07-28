import 'package:flutter_onlineshop_app/presentation/orders/models/order_request.dart';

class OrderResponse {
  final bool success;
  final String message;
  final String id;
  final Shipper shipper;
  final Origin origin;
  final Destination destination;
  final Courier courier;
  final Delivery delivery;
  final double price;
  final String status;

  OrderResponse({
    required this.success,
    required this.message,
    required this.id,
    required this.shipper,
    required this.origin,
    required this.destination,
    required this.courier,
    required this.delivery,
    required this.price,
    required this.status,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      success: json['success'],
      message: json['message'],
      id: json['id'],
      shipper: Shipper.fromJson(json['shipper']),
      origin: Origin.fromJson(json['origin']),
      destination: Destination.fromJson(json['destination']),
      courier: Courier.fromJson(json['courier']),
      delivery: Delivery.fromJson(json['delivery']),
      price: json['price'].toDouble(),
      status: json['status'],
    );
  }
}

class Shipper {
  final String name;
  final String email;
  final String phone;
  final String organization;

  Shipper({
    required this.name,
    required this.email,
    required this.phone,
    required this.organization,
  });

  factory Shipper.fromJson(Map<String, dynamic> json) {
    return Shipper(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      organization: json['organization'],
    );
  }
}

class Origin {
  final String contactName;
  final String contactPhone;
  final Coordinate coordinate;
  final String address;
  final String note;
  final int postalCode;

  Origin({
    required this.contactName,
    required this.contactPhone,
    required this.coordinate,
    required this.address,
    required this.note,
    required this.postalCode,
  });

  factory Origin.fromJson(Map<String, dynamic> json) {
    return Origin(
      contactName: json['contact_name'],
      contactPhone: json['contact_phone'],
      coordinate: Coordinate.fromJson(json['coordinate']),
      address: json['address'],
      note: json['note'],
      postalCode: json['postal_code'],
    );
  }
}

class Destination {
  final String contactName;
  final String contactPhone;
  final String contactEmail;
  final String address;
  final String note;
  final Coordinate coordinate;
  final int postalCode;

  Destination({
    required this.contactName,
    required this.contactPhone,
    required this.contactEmail,
    required this.address,
    required this.note,
    required this.coordinate,
    required this.postalCode,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      contactName: json['contact_name'],
      contactPhone: json['contact_phone'],
      contactEmail: json['contact_email'],
      address: json['address'],
      note: json['note'],
      coordinate: Coordinate.fromJson(json['coordinate']),
      postalCode: json['postal_code'],
    );
  }
}

class ProofOfDelivery {
  final bool use;
  final double fee;
  final String? note;
  final String? link;

  ProofOfDelivery({
    required this.use,
    required this.fee,
    this.note,
    this.link,
  });

  factory ProofOfDelivery.fromJson(Map<String, dynamic> json) {
    return ProofOfDelivery(
      use: json['use'],
      fee: json['fee'].toDouble(),
      note: json['note'],
      link: json['link'],
    );
  }
}

class CashOnDelivery {
  final String? id;
  final double amount;
  final double fee;
  final String? note;
  final String? type;
  final String? status;
  final String paymentStatus;
  final String paymentMethod;

  CashOnDelivery({
    this.id,
    required this.amount,
    required this.fee,
    this.note,
    this.type,
    this.status,
    required this.paymentStatus,
    required this.paymentMethod,
  });

  factory CashOnDelivery.fromJson(Map<String, dynamic> json) {
    return CashOnDelivery(
      id: json['id'],
      amount: json['amount'].toDouble(),
      fee: json['fee'].toDouble(),
      note: json['note'],
      type: json['type'],
      status: json['status'],
      paymentStatus: json['payment_status'],
      paymentMethod: json['payment_method'],
    );
  }
}

class Courier {
  final String trackingId;
  final String waybillId;
  final String company;
  final String? name;
  final String? phone;
  final String type;
  final String? link;
  final String? routingCode;

  Courier({
    required this.trackingId,
    required this.waybillId,
    required this.company,
    this.name,
    this.phone,
    required this.type,
    this.link,
    this.routingCode,
  });

  factory Courier.fromJson(Map<String, dynamic> json) {
    return Courier(
      trackingId: json['tracking_id'],
      waybillId: json['waybill_id'],
      company: json['company'],
      name: json['name'],
      phone: json['phone'],
      type: json['type'],
      link: json['link'],
      routingCode: json['routing_code'],
    );
  }
}

class Insurance {
  final double amount;
  final double fee;
  final String note;

  Insurance({
    required this.amount,
    required this.fee,
    required this.note,
  });

  factory Insurance.fromJson(Map<String, dynamic> json) {
    return Insurance(
      amount: json['amount'].toDouble(),
      fee: json['fee'].toDouble(),
      note: json['note'],
    );
  }
}

class Delivery {
  final DateTime datetime;
  final String? note;
  final String type;
  final double distance;
  final String distanceUnit;

  Delivery({
    required this.datetime,
    this.note,
    required this.type,
    required this.distance,
    required this.distanceUnit,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      datetime: DateTime.parse(json['datetime']),
      note: json['note'],
      type: json['type'],
      distance: json['distance'].toDouble(),
      distanceUnit: json['distance_unit'],
    );
  }
}

