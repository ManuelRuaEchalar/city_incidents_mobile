class IncidentModel {
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
  final String username; // Extraemos el nombre de usuario del objeto user

  IncidentModel({
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
    required this.username,
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      incidentId: json['incident_id'],

      // Mapeo seguro: Si viene el objeto completo 'category', sacamos el ID.
      // Si viene solo el ID (en otros endpoints), lo usamos directo.
      categoryId: json['category'] is Map
          ? json['category']['category_id']
          : (json['category_id'] ?? 0),

      statusId: json['status'] is Map
          ? json['status']['status_id']
          : (json['status_id'] ?? 1),

      cityId: json['city'] is Map ? json['city']['city_id'] : json['city_id'],

      // --- CORRECCIÓN CLAVE AQUÍ ---
      // Convertimos el String "-19.05..." a double.
      // Usamos double.parse(valor.toString()) para que funcione
      // tanto si la API envía String como si envía Number.
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),

      // -----------------------------
      description: json['description'] ?? '',
      photoUrl: json['photo_url'],
      addressRef: json['address_ref'],

      createdAt: DateTime.parse(json['created_at']),

      // Extraemos el username del objeto anidado
      username: json['user'] != null ? json['user']['username'] : 'Anónimo',
    );
  }
}
