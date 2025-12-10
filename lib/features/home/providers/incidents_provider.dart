import 'package:flutter/foundation.dart';
import '../data/models/incident_model.dart';
import '../data/models/category_model.dart';
import '../data/repositories/incident_repository.dart';

class IncidentsProvider with ChangeNotifier {
  final IncidentRepository _repository = IncidentRepository();

  List<IncidentModel> _incidents = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<IncidentModel> get incidents => _incidents;
  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  CategoryModel? getCategoryById(int categoryId) {
    try {
      return _categories.firstWhere((cat) => cat.categoryId == categoryId);
    } catch (e) {
      return null;
    }
  }

  Future<void> loadData() async {
    // Evitamos recargar si ya estamos cargando
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    // Usamos addPostFrameCallback o notifyListeners protegido
    notifyListeners();

    try {
      // 1. Cargar categorías primero para tenerlas listas para la UI
      _categories = await _repository.getCategories();

      // 2. Cargar incidentes
      _incidents = await _repository.getIncidents();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error loading data: $e"); // Log para depuración
      _errorMessage = 'Error al cargar datos. Verifica tu conexión.';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _incidents = []; // Limpiamos para forzar el refresh visual
    await loadData();
  }
}
