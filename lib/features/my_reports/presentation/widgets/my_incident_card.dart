import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/data/models/incident_model.dart';
import '../../../home/data/models/category_model.dart';
import '../../../home/data/models/status_model.dart';
import '../../../shared/widgets/category_icon.dart';

class MyIncidentCard extends StatelessWidget {
  final IncidentModel incident;
  final CategoryModel? category;
  final StatusModel? status;
  final VoidCallback? onViewMore;
  final VoidCallback? onViewLocation;
  final VoidCallback? onInfoPressed;

  const MyIncidentCard({
    super.key,
    required this.incident,
    this.category,
    this.status,
    this.onViewMore,
    this.onViewLocation,
    this.onInfoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135, // Aumentado ligeramente para el nuevo layout
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.deepTeal, width: 2)),
      ),
      child: Row(
        children: [
          _buildImage(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryRow(),
                  const SizedBox(height: 4),
                  _buildStatusRow(),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(incident.createdAt),
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Expanded(
                          child: Text(
                            incident.description,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              color: AppColors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildCategoryRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.deepTeal,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CategoryIcon.build(
            incident.categoryId,
            size: 14,
            color: AppColors.white,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              category?.name ?? 'Cargando...',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onInfoPressed != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onInfoPressed,
              child: const Icon(
                Icons.info_outline,
                color: AppColors.white,
                size: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        const Text(
          'Estado:',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        const SizedBox(width: 6),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color backgroundColor;
    switch (incident.statusId) {
      case 1: // Rechazado
        backgroundColor = const Color(0xFFFF8A89);
        break;
      case 2: // En revisión
        backgroundColor = const Color(0xFF76AAFF);
        break;
      case 3: // Resuelto
        backgroundColor = const Color(0xFF94FFC1);
        break;
      default:
        backgroundColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status?.name ?? 'Cargando...',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w300,
          color: AppColors.black,
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 30,
            child: ElevatedButton(
              onPressed: onViewMore,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: AppColors.prussianBlue,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text('Ver más', style: TextStyle(fontSize: 10)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 30,
            child: ElevatedButton(
              onPressed: onViewLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/location.svg',
                    width: 10,
                    height: 10,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('Ubicación', style: TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return Container(
      width: 85,
      margin: const EdgeInsets.only(left: 3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AspectRatio(
          aspectRatio: 0.8,
          child: incident.photoUrl != null && incident.photoUrl!.isNotEmpty
              ? Image.network(
                  incident.photoUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (ctx, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      _buildDefaultImage(),
                )
              : _buildDefaultImage(),
        ),
      ),
    );
  }

  Widget _buildDefaultImage() {
    return Container(
      color: AppColors.alabasterGray,
      child: Center(
        child: SvgPicture.asset(
          'assets/icons/default_incident_image.svg',
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}
