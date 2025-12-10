import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../providers/my_reports_provider.dart';
import '../widgets/my_incident_card.dart';

class MyReportsPage extends StatefulWidget {
  const MyReportsPage({super.key});

  @override
  State<MyReportsPage> createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyReportsProvider()..loadData(),
      child: Container(
        color: AppColors.white,
        // Padding superior para dejar espacio al navigation bar
        // 40 (top del nav bar) + 46 (altura del nav bar) + 16 (margen) = 102
        padding: const EdgeInsets.only(top: AppSizes.myReportsTopPadding),
        child: Column(
          children: [
            _buildSortBar(),
            Expanded(child: _buildIncidentsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSortBar() {
    return Consumer<MyReportsProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMedium,
            vertical: AppSizes.spacingMedium,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/order.svg',
                width: AppSizes.iconMedium,
                height: AppSizes.iconMedium,
                colorFilter: const ColorFilter.mode(
                  AppColors.deepTeal,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: AppSizes.spacingMedium),
              InkWell(
                onTap: () => provider.toggleSortOrder(),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: AppColors.deepTeal.withOpacity(0.8),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    provider.isAscending
                        ? AppStrings.sortAscending
                        : AppStrings.sortDescending,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.deepTeal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIncidentsList() {
    return Consumer<MyReportsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.deepTeal),
          );
        }

        if (provider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.red),
                const SizedBox(height: 16),
                Text(
                  provider.errorMessage!,
                  style: const TextStyle(fontSize: 14, color: AppColors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.refresh(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepTeal,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text(AppStrings.retryButton),
                ),
              ],
            ),
          );
        }

        if (provider.myIncidents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.report_outlined,
                  size: AppSizes.iconXLarge,
                  color: AppColors.black,
                ),
                const SizedBox(height: AppSizes.paddingMedium),
                Text(
                  AppStrings.noReportsEmpty,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.refresh(),
          color: AppColors.deepTeal,
          child: ListView.builder(
            itemCount: provider.myIncidents.length,
            itemBuilder: (context, index) {
              final incident = provider.myIncidents[index];
              final category = provider.getCategoryById(incident.categoryId);
              final status = provider.getStatusById(incident.statusId);

              return MyIncidentCard(
                incident: incident,
                category: category,
                status: status,
                onViewMore: () {
                  // TODO: Navegar a detalles del incidente
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Ver detalles del incidente ${incident.incidentId}',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                onViewLocation: () {
                  // TODO: Navegar a ubicación en el mapa
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Ver ubicación del incidente ${incident.incidentId}',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                onInfoPressed: () {
                  _showCategoryInfo(context, category);
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showCategoryInfo(BuildContext context, category) {
    if (category == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category.name),
        content: Text(category.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.closeButton),
          ),
        ],
      ),
    );
  }
}
