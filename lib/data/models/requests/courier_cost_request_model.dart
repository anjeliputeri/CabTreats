class CourierCostRequestModel {
  final String? originLatitude;
  final String? originLongitude;
  final String? destinationLatitude;
  final String? destinationLongitude;
  final String? courier;
  final List<OrderItem>? orderItems;

  CourierCostRequestModel({
    this.originLatitude,
    this.originLongitude,
    this.destinationLatitude,
    this.destinationLongitude,
    this.courier,
    this.orderItems,
  });

  // Method to convert the model to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'origin_latitude': originLatitude,
      'origin_longitude': originLongitude,
      'destination_latitude': destinationLatitude,
      'destination_longitude': destinationLongitude,
      'couriers': courier,
      'items': orderItems?.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final String? name;
  final int? weight;
  final int? quantity;
  final String vendorEmail;
  final int? price;
  final String? image;
  final int? originalPrice;

  OrderItem({
    this.name,
    this.weight,
    this.quantity,
    this.vendorEmail = '',
    this.price,
    this.image,
    this.originalPrice
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'weight': weight,
      'quantity': quantity,
      'price': price,
      'vendor_email': vendorEmail,
      'image': image,
      'original_price': originalPrice,
    };
  }
}
