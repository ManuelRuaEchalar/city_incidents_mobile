import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_sizes.dart';
import '../widgets/profile_image.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/action_buttons.dart';
import '../../../../app/routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null && provider.user == null) {
              return Center(child: Text('Error: ${provider.errorMessage}'));
            }

            if (provider.user == null || provider.stats == null) {
              return const Center(child: Text(AppStrings.profileLoadError));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: AppSizes
                    .profileTopPadding, // Espacio para el navigation bar
                bottom: AppSizes.profileBottomPadding,
              ),
              child: Column(
                children: [
                  ProfileImage(imageUrl: provider.user!.profilePicUrl),
                  const SizedBox(height: AppSizes.spacingSection),
                  ProfileInfoCard(
                    user: provider.user!,
                    onUpdate: (username, email, password) async {
                      await provider.updateUser(
                        username: username,
                        email: email,
                        password: password,
                      );
                    },
                  ),
                  const SizedBox(height: AppSizes.spacingElement),
                  StatsCard(stats: provider.stats!),
                  const SizedBox(height: AppSizes.spacingBetweenCards),
                  ActionButtons(
                    onLogout: () async {
                      final success = await provider.logout();
                      if (success && mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.login,
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
