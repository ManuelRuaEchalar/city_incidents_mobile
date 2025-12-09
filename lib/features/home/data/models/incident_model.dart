class IncidentModel {
  final int incidentId;
  final int categoryId;
  final int cityId;
  final double latitude;
  final double longitude;
  final String description;
  final String? photoUrl;
  final String? addressRef;
  final DateTime createdAt;

  IncidentModel({
    required this.incidentId,
    required this.categoryId,
    required this.cityId,
    required this.latitude,
    required this.longitude,
    required this.description,
    this.photoUrl,
    this.addressRef,
    required this.createdAt,
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      incidentId: json['incident_id'],
      categoryId: json['category_id'],
      cityId: json['city_id'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      description: json['description'],
      photoUrl: json['photo_url'],
      addressRef: json['address_ref'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
