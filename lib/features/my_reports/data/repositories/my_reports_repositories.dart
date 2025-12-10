import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tutorial_my_flutter_app/features/home/data/models/status_model.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/secure_storage_helper.dart';
import '../../../home/data/models/incident_model.dart';
import '../../../home/data/models/category_model.dart';

class MyReportsRepository {
  final String baseUrl = AppStrings.baseUrl;

  Future<String?> _getToken() async {
    return await SecureStorageHelper.getToken();
  }

  Future<List<IncidentModel>> getMyIncidents() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse('$baseUrl/incidents/my-incidents'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => IncidentModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error al obtener mis incidentes: ${response.statusCode}',
        );
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

  Future<List<StatusModel>> getStatuses() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse('$baseUrl/statuses'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => StatusModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener estados: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
