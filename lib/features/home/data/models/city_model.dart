class CityModel {
  final int cityId;
  final String name;
  final String code;
  final int incidentCount;

  CityModel({
    required this.cityId,
    required this.name,
    required this.code,
    required this.incidentCount,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      cityId: json['city_id'],
      name: json['name'],
      code: json['code'],
      incidentCount: json['_count']['incidents'],
    );
  }
}
