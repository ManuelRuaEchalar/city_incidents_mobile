import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../shared/widgets/category_icon.dart';
import '../../data/models/incident_model.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/incident_repository.dart';
import '../../../../core/utils/map_controller_helper.dart';
import 'incident_dialog.dart';

class IncidentCard extends StatelessWidget {
  final IncidentModel incident;
  final CategoryModel? category;
  final VoidCallback? onInfoPressed;

  const IncidentCard({
    super.key,
    required this.incident,
    this.category,
    this.onInfoPressed,
  });

  static final IncidentRepository _repository = IncidentRepository();

  Future<void> _showIncidentDetail(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final incidentDetail = await _repository.getIncidentById(
        incident.incidentId,
      );

      if (context.mounted) Navigator.of(context).pop();

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => IncidentDialog(
            incident: IncidentModel(
              incidentId: incidentDetail.incidentId,
              categoryId: incidentDetail.categoryId,
              statusId: incidentDetail.statusId,
              cityId: incidentDetail.cityId,
              latitude: incidentDetail.latitude,
              longitude: incidentDetail.longitude,
              description: incidentDetail.description,
              photoUrl: incidentDetail.photoUrl,
              addressRef: incidentDetail.addressRef,
              createdAt: incidentDetail.createdAt,
              username: '',
            ),
            category: incidentDetail.category,
            status: incidentDetail.status,
            city: incidentDetail.city,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _goToLocation(BuildContext context) {
    // Centrar el mapa en la ubicación del incidente
    MapControllerHelper.moveMap(
      incident.latitude,
      incident.longitude,
      zoom: 17.0,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mapa centrado en el incidente'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
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
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryHeader(),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(incident.createdAt),
                    style: TextStyle(fontSize: 8, color: Colors.grey[600]),
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
                  _buildButtons(context),
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

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 28,
            child: ElevatedButton(
              onPressed: () => _showIncidentDetail(context),
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
        const SizedBox(width: 6),
        Expanded(
          child: SizedBox(
            height: 28,
            child: ElevatedButton(
              onPressed: () => _goToLocation(context),
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
      width: 80,
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
                  errorBuilder: (_, __, ___) => _buildDefaultImage(),
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
