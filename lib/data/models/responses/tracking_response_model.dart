import 'dart:convert';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class BiteshipTrackingResponseModel {
    final bool? success;
    final String? message;
    final String? object;
    final String? id;
    final String? waybillId;
    final Courier? courier;
    final Destination? origin;
    final Destination? destination;
    final List<History>? history;
    final dynamic link;
    final String? orderId;
    final String? status;
    final int? weight;

    BiteshipTrackingResponseModel({
        this.success,
        this.message,
        this.object,
        this.id,
        this.waybillId,
        this.courier,
        this.origin,
        this.destination,
        this.history,
        this.link,
        this.orderId,
        this.status,
        this.weight,
    });

    factory BiteshipTrackingResponseModel.fromJson(String str) => BiteshipTrackingResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory BiteshipTrackingResponseModel.fromMap(Map<String, dynamic> json) => BiteshipTrackingResponseModel(
        success: json["success"],
        message: json["message"],
        object: json["object"],
        id: json["id"],
        waybillId: json["waybill_id"],
        courier: json["courier"] == null ? null : Courier.fromMap(json["courier"]),
        origin: json["origin"] == null ? null : Destination.fromMap(json["origin"]),
        destination: json["destination"] == null ? null : Destination.fromMap(json["destination"]),
        history: json["history"] == null ? [] : List<History>.from(json["history"]!.map((x) => History.fromMap(x))),
        link: json["link"],
        orderId: json["order_id"],
        status: json["status"],
        weight: json["weight"],
    );

    Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "object": object,
        "id": id,
        "waybill_id": waybillId,
        "courier": courier?.toMap(),
        "origin": origin?.toMap(),
        "destination": destination?.toMap(),
        "history": history == null ? [] : List<dynamic>.from(history!.map((x) => x.toMap())),
        "link": link,
        "order_id": orderId,
        "status": status,
        "weight": weight,
    };
}

class Courier {
    final String? company;
    final String? name;
    final String? phone;
    final String? driverName;
    final String? driverPhone;
    final String? driverPhotoUrl;
    final String? driverPlateNumber;

    Courier({
        this.company,
        this.name,
        this.phone,
        this.driverName,
        this.driverPhone,
        this.driverPhotoUrl,
        this.driverPlateNumber,
    });

    factory Courier.fromJson(String str) => Courier.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Courier.fromMap(Map<String, dynamic> json) => Courier(
        company: json["company"],
        name: json["name"],
        phone: json["phone"],
        driverName: json["driver_name"],
        driverPhone: json["driver_phone"],
        driverPhotoUrl: json["driver_photo_url"],
        driverPlateNumber: json["driver_plate_number"],
    );

    Map<String, dynamic> toMap() => {
        "company": company,
        "name": name,
        "phone": phone,
        "driver_name": driverName,
        "driver_phone": driverPhone,
        "driver_photo_url": driverPhotoUrl,
        "driver_plate_number": driverPlateNumber,
    };
}

class Destination {
    final String? contactName;
    final String? address;

    Destination({
        this.contactName,
        this.address,
    });

    factory Destination.fromJson(String str) => Destination.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Destination.fromMap(Map<String, dynamic> json) => Destination(
        contactName: json["contact_name"],
        address: json["address"],
    );

    Map<String, dynamic> toMap() => {
        "contact_name": contactName,
        "address": address,
    };
}

class History {
  final String? status;
  final tz.TZDateTime? eventDate;
  final String? serviceType;
  final String? note;

  History({
    this.status,
    this.eventDate,
    this.serviceType,
    this.note,
  });

  factory History.fromJson(String str) => History.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory History.fromMap(Map<String, dynamic> json) {
    // Inisialisasi data zona waktu
    tz.initializeTimeZones();
    final jakarta = tz.getLocation('Asia/Jakarta');

    final eventDateString = json["eventDate"];
    final eventDateUtc = eventDateString == null
        ? null
        : DateTime.parse(eventDateString).toUtc();

    // Konversi DateTime ke zona waktu Jakarta jika tidak null
    final eventDateJakarta = eventDateUtc == null
        ? null
        : tz.TZDateTime.from(eventDateUtc, jakarta);

    return History(
      status: json["status"],
      eventDate: eventDateJakarta,
      serviceType: json["serviceType"],
      note: json["note"],
    );
  }

  Map<String, dynamic> toMap() => {
    "status": status,
    "eventDate": eventDate?.toIso8601String(),
    "serviceType": serviceType,
    "note": note,
  };
}