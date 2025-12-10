class CityModel {
  final int cityId;
  final String name;
  final String code;
  final int incidentCount;

  CityModel({
    required this.cityId,
    required this.name,
    required this.code,
    this.incidentCount = 0,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      cityId: json['city_id'],
      name: json['name'],
      code: json['code'],
      incidentCount: json['_count'] != null ? json['_count']['incidents'] : 0,
    );
  }
}
