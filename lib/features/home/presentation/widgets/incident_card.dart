import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../shared/widgets/category_icon.dart';
import '../../data/models/incident_model.dart';
import '../../data/models/category_model.dart';

class IncidentCard extends StatelessWidget {
  final IncidentModel incident;
  final CategoryModel? category;
  final VoidCallback? onViewMore;
  final VoidCallback? onViewLocation;
  final VoidCallback? onInfoPressed;

  const IncidentCard({
    super.key,
    required this.incident,
    this.category,
    this.onViewMore,
    this.onViewLocation,
    this.onInfoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.deepTeal, width: 2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryHeader(),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Text(
                      incident.description,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: AppColors.black,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildButtons(),
                ],
              ),
            ),
          ),
          _buildImage(),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader() {
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
            size: 16,
            color: AppColors.white,
          ),
          const SizedBox(width: 4),
          Text(
            category?.name ?? 'Categoría',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onInfoPressed,
            child: const Icon(
              Icons.info_outline,
              color: AppColors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onViewMore,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: AppColors.prussianBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              minimumSize: const Size(0, 0),
            ),
            child: const Text('Ver más', style: TextStyle(fontSize: 10)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: onViewLocation,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              minimumSize: const Size(0, 0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icons/location.svg',
                  width: 12,
                  height: 12,
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 4),
                const Text('Ver ubicación', style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return Container(
      width: 85,
      margin: const EdgeInsets.only(right: 3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: incident.photoUrl != null
            ? Image.network(
                incident.photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildDefaultImage(),
              )
            : _buildDefaultImage(),
      ),
    );
  }

  Widget _buildDefaultImage() {
    return Container(
      color: AppColors.alabasterGray,
      child: Center(
        child: SvgPicture.asset(
          'assets/icons/default_incident_image.svg',
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
