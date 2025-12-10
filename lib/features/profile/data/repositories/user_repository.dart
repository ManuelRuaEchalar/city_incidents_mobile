import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/secure_storage_helper.dart';
import '../models/user_model.dart';

class UserRepository {
  final String baseUrl = AppStrings.baseUrl;

  Future<String?> _getToken() async {
    return await SecureStorageHelper.getToken();
  }

  Future<UserModel> getUserProfile() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse('$baseUrl/users/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al obtener perfil: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<UserStatsModel> getUserStats() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse('$baseUrl/users/my-stats'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return UserStatsModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Error al obtener estadísticas: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> updateUser({
    String? email,
    String? username,
    String? password,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final Map<String, dynamic> body = {};
      if (email != null) body['email'] = email;
      if (username != null) body['username'] = username;
      if (password != null) body['password'] = password;

      final response = await http.patch(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar usuario: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> logout() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await SecureStorageHelper.deleteToken();
      } else {
        throw Exception('Error al cerrar sesión: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
