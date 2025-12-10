import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_strings.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';

class AuthRepository {
  final String baseUrl = AppStrings.baseUrl;

  Future<LoginResponse> signIn(LoginRequest request) async {
    final http.Response response;
    try {
      response = await http.post(
        Uri.parse('$baseUrl/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return LoginResponse.fromJson(jsonResponse);
    } else if (response.statusCode == 403) {
      throw Exception('Email o contraseña incorrectos, intentar de nuevo');
    } else {
      throw Exception('Error al iniciar sesión: ${response.statusCode}');
    }
  }

  Future<LoginResponse> signUp(RegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return LoginResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Error al registrarse: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
