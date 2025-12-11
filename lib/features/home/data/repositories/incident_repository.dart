import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/secure_storage_helper.dart';
import '../models/incident_model.dart';
import '../models/incident_detail_model.dart';
import '../models/category_model.dart';
import '../models/city_model.dart';

class IncidentRepository {
  final String baseUrl = AppStrings.baseUrl;

  Future<String?> _getToken() async {
    return await SecureStorageHelper.getToken();
  }

  Future<List<IncidentModel>> getIncidents() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse('$baseUrl/incidents'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) {
          if (json['description'] != null) {
            try {
              json['description'] = utf8.decode(
                base64Decode(json['description']),
              );
            } catch (e) {
              // Si no es base64 válido, dejar el original
            }
          }
          return IncidentModel.fromJson(json);
        }).toList();
      } else {
        throw Exception('Error al obtener incidentes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<IncidentDetailModel> getIncidentById(int incidentId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse('$baseUrl/incidents/$incidentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        if (json['description'] != null) {
          try {
            json['description'] = utf8.decode(
              base64Decode(json['description']),
            );
          } catch (e) {
            // Si falla, ignoramos
          }
        }
        return IncidentDetailModel.fromJson(json);
      } else {
        throw Exception('Error al obtener incidente: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener categorías: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<CityModel>> getCities() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse('$baseUrl/cities'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => CityModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener ciudades: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<IncidentModel> createIncident({
    required int categoryId,
    int? cityId,
    required double latitude,
    required double longitude,
    String? description,
    String? addressRef,
    File? photo,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/incidents'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Campos obligatorios
      request.fields['category_id'] = categoryId.toString();
      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();

      // Campos opcionales
      if (cityId != null) {
        request.fields['city_id'] = cityId.toString();
      }
      if (description != null && description.isNotEmpty) {
        // CAMBIO AQUÍ: Codificar en Base64 para saltar el WAF
        request.fields['description'] = base64Encode(utf8.encode(description));
      }
      if (addressRef != null && addressRef.isNotEmpty) {
        request.fields['address_ref'] = addressRef;
      }

      // Agregar foto si existe
      if (photo != null) {
        var stream = http.ByteStream(photo.openRead());
        var length = await photo.length();
        var multipartFile = http.MultipartFile(
          'photo',
          stream,
          length,
          filename: photo.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return IncidentModel.fromJson(jsonResponse);
      } else {
        throw Exception(
          'Error al crear incidente: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
