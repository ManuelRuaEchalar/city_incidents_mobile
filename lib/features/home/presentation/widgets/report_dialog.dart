import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/location_helper.dart';
import '../../../../core/utils/camera_helper.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../data/models/category_model.dart';
import '../../data/models/city_model.dart';
import '../../data/repositories/incident_repository.dart';

class ReportDialog extends StatefulWidget {
  const ReportDialog({super.key});

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final IncidentRepository _repository = IncidentRepository();
  final TextEditingController _descriptionController = TextEditingController();

  List<CategoryModel> _categories = [];
  List<CityModel> _cities = [];

  CategoryModel? _selectedCategory;
  CityModel? _selectedCity;
  Position? _currentPosition;
  File? _photoFile;

  bool _isLoading = false;
  bool _isLoadingLocation = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final categories = await _repository.getCategories();
      final cities = await _repository.getCities();

      setState(() {
        _categories = categories;
        _cities = cities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar datos: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _getLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _errorMessage = null;
    });

    try {
      final position = await LocationHelper.getCurrentLocation();
      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al obtener ubicación: $e';
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _takePicture() async {
    try {
      final photo = await CameraHelper.takePicture();
      setState(() {
        _photoFile = photo;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al tomar foto: $e';
      });
    }
  }

  Future<void> _submitReport() async {
    // Validaciones
    if (_selectedCategory == null) {
      setState(() {
        _errorMessage = AppStrings.categoryRequired;
      });
      return;
    }

    if (_currentPosition == null) {
      setState(() {
        _errorMessage = AppStrings.locationRequired;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _repository.createIncident(
        categoryId: _selectedCategory!.categoryId,
        cityId: _selectedCity?.cityId,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        photo: _photoFile,
      );

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.reportSuccess),
            backgroundColor: AppColors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = '${AppStrings.reportError}: $e';
        _isLoading = false;
      });
    }
  }

  String _getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'Vías y calzadas':
        return 'assets/icons/road_option.svg';
      case 'Señalización y Semáforos':
        return 'assets/icons/traffic_lights_option.svg';
      case 'Alumbrado Público':
        return 'assets/icons/light_option.svg';
      case 'Limpieza y Residuos':
        return 'assets/icons/garbage_option.svg';
      case 'Otro':
        return 'assets/icons/other_option.svg';
      default:
        return 'assets/icons/other_option.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: AppSizes.dialogMaxWidth,
          maxHeight: AppSizes.dialogMaxHeight,
        ),
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header con título y botón cerrar
            Row(
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      AppStrings.reportTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: SvgPicture.asset(
                      'assets/icons/cancel.svg',
                      width: AppSizes.iconMedium,
                      height: AppSizes.iconMedium,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Contenido con scroll
            Expanded(
              child: _isLoading && _categories.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Error message
                          if (_errorMessage != null)
                            Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.red,
                                  width: 0.6,
                                ),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: AppColors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                          // Seleccionar categoría
                          const Text(
                            AppStrings.selectCategory,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: AppColors.deepTeal,
                                width: 0.6,
                              ),
                            ),
                            child: Column(
                              children: _categories.asMap().entries.map((
                                entry,
                              ) {
                                final index = entry.key;
                                final category = entry.value;
                                final isSelected =
                                    _selectedCategory?.categoryId ==
                                    category.categoryId;

                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory = category;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                        color: isSelected
                                            ? AppColors.deepTeal.withOpacity(
                                                0.1,
                                              )
                                            : Colors.transparent,
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              _getCategoryIcon(category.name),
                                              width: 24,
                                              height: 24,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                category.name,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: isSelected
                                                      ? AppColors.prussianBlue
                                                      : AppColors.prussianBlue
                                                            .withOpacity(0.7),
                                                ),
                                              ),
                                            ),
                                            if (isSelected)
                                              const Icon(
                                                Icons.check_circle,
                                                color: AppColors.prussianBlue,
                                                size: 20,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (index < _categories.length - 1)
                                      Container(
                                        height: 0.5,
                                        color: AppColors.prussianBlue,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                      ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Ciudad
                          const Text(
                            AppStrings.cityLabel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: AppColors.deepTeal,
                                width: 0.7,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<CityModel>(
                                isExpanded: true,
                                value: _selectedCity,
                                hint: const Text(
                                  AppStrings.selectCityHint,
                                  style: TextStyle(fontSize: 12),
                                ),
                                items: _cities.map((city) {
                                  return DropdownMenuItem<CityModel>(
                                    value: city,
                                    child: Text(
                                      city.name,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (city) {
                                  setState(() {
                                    _selectedCity = city;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Ubicación
                          const Text(
                            AppStrings.locationLabel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 321,
                            height: AppSizes.buttonHeight,
                            child: ElevatedButton(
                              onPressed: _isLoadingLocation
                                  ? null
                                  : _getLocation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.prussianBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: _isLoadingLocation
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/mi_location.svg',
                                          width: AppSizes.iconSmall,
                                          height: AppSizes.iconSmall,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          AppStrings.myLocationButton,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          if (_currentPosition != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}, '
                                'Lon: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.deepTeal,
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),

                          // Descripción
                          const Text(
                            AppStrings.descriptionLabel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _descriptionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: AppStrings.descriptionHint,
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                  color: AppColors.deepTeal,
                                  width: 0.7,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                  color: AppColors.deepTeal,
                                  width: 0.7,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                  color: AppColors.prussianBlue,
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Foto
                          const Text(
                            AppStrings.photoLabel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 321,
                            height: AppSizes.buttonHeight,
                            child: ElevatedButton(
                              onPressed: _takePicture,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.prussianBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/camera.svg',
                                    width: AppSizes.iconSmall,
                                    height: AppSizes.iconSmall,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    AppStrings.cameraButton,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_photoFile != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppColors.green,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    AppStrings.photoCaptured,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.green,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _photoFile = null;
                                      });
                                    },
                                    child: const Text(
                                      AppStrings.deleteButton,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 24),

                          // Botón Subir reporte
                          Center(
                            child: SizedBox(
                              width: 124,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _submitReport,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.uploadButton,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusXLarge,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical:
                                        12, // Keeping 12 as generic vertical padding for now
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: AppSizes.iconSmall,
                                        height: AppSizes.iconSmall,
                                        child: CircularProgressIndicator(
                                          color: AppColors.black,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        AppStrings.submitReportButton,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
