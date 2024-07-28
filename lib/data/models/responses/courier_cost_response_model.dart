class CourierCost {
  final String company;
  final String courierName;
  final String courierCode;
  final String courierServiceName;
  final String courierServiceCode;
  final String description;
  final String duration;
  final String shipmentDurationRange;
  final String shipmentDurationUnit;
  final int price;
  final String serviceType;
  final String shippingType;
  final String type;

  CourierCost({
    required this.company,
    required this.courierName,
    required this.courierCode,
    required this.courierServiceName,
    required this.courierServiceCode,
    required this.description,
    required this.duration,
    required this.shipmentDurationRange,
    required this.shipmentDurationUnit,
    required this.price,
    required this.serviceType,
    required this.shippingType,
    required this.type,
  });

  factory CourierCost.fromJson(Map<String, dynamic> json) {
    return CourierCost(
      company: json['company'],
      courierName: json['courier_name'],
      courierCode: json['courier_code'],
      courierServiceName: json['courier_service_name'],
      courierServiceCode: json['courier_service_code'],
      description: json['description'],
      duration: json['duration'],
      shipmentDurationRange: json['shipment_duration_range'],
      shipmentDurationUnit: json['shipment_duration_unit'],
      price: json['price'],
      serviceType: json['service_type'],
      shippingType: json['shipping_type'],
      type: json['type'],
    );
  }
}
