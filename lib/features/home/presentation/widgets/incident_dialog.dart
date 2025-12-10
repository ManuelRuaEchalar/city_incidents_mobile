import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/incident_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/status_model.dart';
import '../../data/models/city_model.dart';
import '../../../shared/widgets/category_icon.dart';

class IncidentDialog extends StatelessWidget {
  final IncidentModel incident;
  final CategoryModel? category;
  final StatusModel? status;
  final CityModel? city;

  const IncidentDialog({
    super.key,
    required this.incident,
    this.category,
    this.status,
    this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildImage(),
                  const SizedBox(height: 16),
                  _buildInfoGrid(),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildDescription(),
                  const SizedBox(height: 16),
                  _buildDate(),
                ],
              ),
            ),
          ),
          // Botón de cerrar dentro del dialog, esquina superior derecha
          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/icons/cancel.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CategoryIcon.build(incident.categoryId, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category?.name ?? 'Incidente',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.prussianBlue,
                ),
              ),
              if (city != null)
                Text(
                  city!.name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.deepTeal,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (incident.photoUrl == null || incident.photoUrl!.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.alabasterGray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/default_incident_image.svg',
            width: 64,
            height: 64,
            colorFilter: const ColorFilter.mode(
              AppColors.deepTeal,
              BlendMode.srcIn,
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        incident.photoUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 200,
            color: AppColors.alabasterGray,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.deepTeal),
            ),
          );
        },
        errorBuilder: (_, __, ___) => Container(
          height: 200,
          color: AppColors.alabasterGray,
          child: const Center(
            child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoGrid() {
    return Column(
      children: [
        if (status != null)
          _buildInfoRow(
            'Estado:',
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(status!.statusId),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status!.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        const SizedBox(height: 8),
        _buildInfoRow(
          'Coordenadas:',
          Text(
            '${incident.latitude.toStringAsFixed(5)}, ${incident.longitude.toStringAsFixed(5)}',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, Widget content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.prussianBlue,
          ),
        ),
        content,
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descripción',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.prussianBlue,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.alabasterGray.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Text(
            incident.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.black,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDate() {
    return Text(
      'Reportado el ${_formatDate(incident.createdAt)}',
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
      ),
      textAlign: TextAlign.end,
    );
  }

  Color _getStatusColor(int statusId) {
    switch (statusId) {
      case 1:
        return const Color(0xFFFF8A89);
      case 2:
        return const Color(0xFF76AAFF);
      case 3:
        return const Color(0xFF94FFC1);
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
