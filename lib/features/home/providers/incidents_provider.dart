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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _repository.getCategories();
      _incidents = await _repository.getIncidents();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadData();
  }
}
