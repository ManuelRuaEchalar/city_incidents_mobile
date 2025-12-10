import 'package:flutter/foundation.dart';
import '../../../core/utils/secure_storage_helper.dart';
import '../data/models/login_request.dart';
import '../data/models/register_request.dart';
import '../data/repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool _isLoading = false;
  String? _errorMessage;
  String? _accessToken;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _accessToken != null;
  String? get token => _accessToken;

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _repository.signIn(request);

      _accessToken = response.accessToken;

      // Guardar token de forma segura
      await SecureStorageHelper.saveToken(response.accessToken);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String username, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = RegisterRequest(
        username: username,
        email: email,
        password: password,
      );
      final response = await _repository.signUp(request);

      _accessToken = response.accessToken;

      // Guardar token de forma segura
      await SecureStorageHelper.saveToken(response.accessToken);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadToken() async {
    _accessToken = await SecureStorageHelper.getToken();
    notifyListeners();
  }

  Future<void> signOut() async {
    await SecureStorageHelper.deleteToken();
    _accessToken = null;
    notifyListeners();
  }
}
