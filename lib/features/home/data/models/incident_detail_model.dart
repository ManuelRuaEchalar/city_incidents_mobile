import 'category_model.dart';
import 'status_model.dart';
import 'city_model.dart';

class IncidentDetailModel {
  final int incidentId;
  final int categoryId;
  final int statusId;
  final int? cityId;
  final double latitude;
  final double longitude;
  final String description;
  final String? photoUrl;
  final String? addressRef;
  final DateTime createdAt;

  // Objetos relacionados completos
  final CategoryModel? category;
  final StatusModel? status;
  final CityModel? city;

  IncidentDetailModel({
    required this.incidentId,
    required this.categoryId,
    required this.statusId,
    this.cityId,
    required this.latitude,
    required this.longitude,
    required this.description,
    this.photoUrl,
    this.addressRef,
    required this.createdAt,
    this.category,
    this.status,
    this.city,
  });

  factory IncidentDetailModel.fromJson(Map<String, dynamic> json) {
    return IncidentDetailModel(
      incidentId: json['incident_id'],
      categoryId: json['category'] != null
          ? json['category']['category_id']
          : (json['category_id'] ?? 0),
      statusId: json['status'] != null
          ? json['status']['status_id']
          : (json['status_id'] ?? 1),
      cityId: json['city'] != null ? json['city']['city_id'] : json['city_id'],

      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),

      description: json['description'] ?? '',
      photoUrl: json['photo_url'],
      addressRef: json['address_ref'],
      createdAt: DateTime.parse(json['created_at']),

      // Parsear objetos anidados si existen
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      status: json['status'] != null
          ? StatusModel.fromJson(json['status'])
          : null,
      city: json['city'] != null ? CityModel.fromJson(json['city']) : null,
    );
  }
}
