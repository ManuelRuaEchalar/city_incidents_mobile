import 'package:flutter/foundation.dart';

import '../../home/data/models/category_model.dart';
import '../../home/data/models/incident_model.dart';
import '../../home/data/models/status_model.dart';
import '../data/repositories/my_reports_repositories.dart';

class MyReportsProvider with ChangeNotifier {
  final MyReportsRepository _repository = MyReportsRepository();

  List<IncidentModel> _myIncidents = [];
  List<CategoryModel> _categories = [];
  List<StatusModel> _statuses = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAscending = false; // false = descendente (más reciente primero)

  List<IncidentModel> get myIncidents => _myIncidents;
  List<CategoryModel> get categories => _categories;
  List<StatusModel> get statuses => _statuses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAscending => _isAscending;

  CategoryModel? getCategoryById(int categoryId) {
    try {
      return _categories.firstWhere((cat) => cat.categoryId == categoryId);
    } catch (e) {
      return null;
    }
  }

  StatusModel? getStatusById(int statusId) {
    try {
      return _statuses.firstWhere((status) => status.statusId == statusId);
    } catch (e) {
      return null;
    }
  }

  void toggleSortOrder() {
    _isAscending = !_isAscending;
    _sortIncidents();
    notifyListeners();
  }

  void _sortIncidents() {
    if (_isAscending) {
      _myIncidents.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } else {
      _myIncidents.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
  }

  Future<void> loadData() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Cargar categorías y estados primero
      _categories = await _repository.getCategories();
      _statuses = await _repository.getStatuses();

      // Cargar mis incidentes
      _myIncidents = await _repository.getMyIncidents();

      // Ordenar según el orden actual
      _sortIncidents();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error loading my reports: $e");
      _errorMessage = 'Error al cargar tus reportes. Verifica tu conexión.';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _myIncidents = [];
    await loadData();
  }
}
