import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
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
      color: Colors.white,
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
              return const Center(child: Text('No se pudo cargar el perfil'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 100, // Espacio para el navigation bar
                bottom: 30,
              ),
              child: Column(
                children: [
                  ProfileImage(imageUrl: provider.user!.profilePicUrl),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 10),
                  StatsCard(stats: provider.stats!),
                  const SizedBox(height: 15),
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
