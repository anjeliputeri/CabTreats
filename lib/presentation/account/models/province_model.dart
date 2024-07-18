class ProvinceModel {
  String? provinceId;
  String? province;

  ProvinceModel({
    this.provinceId,
    this.province,
});

  ProvinceModel.fromJson(Map<String, dynamic> json) {
    provinceId = json['province_id'];
    province = json['province'];
  }

  @override
  String toString() => province as String;

  static List<ProvinceModel> fromJsonList(List list) {
    if (list.length == 0) return List<ProvinceModel>.empty();
    return list.map((item) => ProvinceModel.fromJson(item)).toList();
  }
}