import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../providers/incidents_provider.dart';
import 'incident_card.dart';

class IncidentsBottomSheet extends StatelessWidget {
  final ValueNotifier<double> sheetHeight;

  const IncidentsBottomSheet({super.key, required this.sheetHeight});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        sheetHeight.value = notification.extent;
        return true;
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.1,
        maxChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.deepTeal,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Consumer<IncidentsProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (provider.errorMessage != null) {
                        return Center(
                          child: Text(
                            'Error: ${provider.errorMessage}',
                            style: const TextStyle(color: AppColors.red),
                          ),
                        );
                      }

                      if (provider.incidents.isEmpty) {
                        return const Center(
                          child: Text('No hay incidentes reportados'),
                        );
                      }

                      return ListView.builder(
                        controller: scrollController,
                        itemCount: provider.incidents.length,
                        itemBuilder: (context, index) {
                          final incident = provider.incidents[index];
                          final category = provider.getCategoryById(
                            incident.categoryId,
                          );

                          return IncidentCard(
                            incident: incident,
                            category: category,
                            onInfoPressed: () {
                              _showCategoryInfo(context, category);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCategoryInfo(BuildContext context, dynamic category) {
    if (category == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category.name),
        content: Text(category.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
