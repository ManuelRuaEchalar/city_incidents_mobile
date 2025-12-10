import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/incidents_provider.dart';
import '../../../../core/constants/app_sizes.dart';
import '../widgets/map_widget.dart';
import '../widgets/incidents_bottom_sheet.dart';
import '../widgets/report_button.dart';
import '../../../shared/widgets/custom_navigation_bar.dart';
import '../../../my_reports/presentation/pages/my_reports_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final ValueNotifier<double> _sheetHeight = ValueNotifier(0.3);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IncidentsProvider>().loadData();
    });
  }

  @override
  void dispose() {
    _sheetHeight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildCurrentPage(),
          CustomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          if (_currentIndex == 0)
            ValueListenableBuilder<double>(
              valueListenable: _sheetHeight,
              builder: (context, height, child) {
                final screenHeight = MediaQuery.of(context).size.height;
                final bottomSheetTop = screenHeight * (1 - height);

                return Positioned(
                  bottom:
                      screenHeight -
                      bottomSheetTop +
                      10, // 10px arriba del sheet
                  right: AppSizes.navBarTopMargin, // 20
                  child: const ReportButton(),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return const MyReportsPage();
      case 2:
        return const ProfilePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Stack(
      children: [
        Consumer<IncidentsProvider>(
          builder: (context, provider, child) {
            return MapWidget(incidents: provider.incidents);
          },
        ),
        IncidentsBottomSheet(sheetHeight: _sheetHeight),
      ],
    );
  }
}
