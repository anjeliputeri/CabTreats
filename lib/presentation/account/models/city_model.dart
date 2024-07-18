class CityModel {
  String? cityId;
  String? type;
  String? cityName;
  String? posCode;

  CityModel({
    this.cityId,
    this.type,
    this.cityName,
    this.posCode
});

  CityModel.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    type = json['type'];
    cityName = json['city_name'];
    posCode = json['postal_code'];
  }

  @override
  String toString() => cityName as String;

  static List<CityModel> fromJsonList(List list) {
    if (list.length == 0) return List<CityModel>.empty();
    return list.map((item) => CityModel.fromJson(item)).toList();
  }
}