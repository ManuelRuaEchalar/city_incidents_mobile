import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/models/user_model.dart';

class ProfileInfoCard extends StatefulWidget {
  final UserModel user;
  final Function(String?, String?, String?) onUpdate;

  const ProfileInfoCard({
    super.key,
    required this.user,
    required this.onUpdate,
  });

  @override
  State<ProfileInfoCard> createState() => _ProfileInfoCardState();
}

class _ProfileInfoCardState extends State<ProfileInfoCard> {
  bool _isEditing = false;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 367,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  if (_isEditing) {
                    _saveChanges();
                  }
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/edit_account.svg',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isEditing
                          ? AppStrings.saveButton
                          : AppStrings.editButton,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.prussianBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_isEditing) ...[
            _buildEditField(AppStrings.usernameLabel, _usernameController),
            const SizedBox(height: 12),
            _buildEditField(AppStrings.emailLabel, _emailController),
            const SizedBox(height: 12),
            _buildEditField(
              AppStrings.passwordLabel,
              _passwordController,
              isPassword: true,
            ),
          ] else ...[
            _buildInfoRow(AppStrings.usernameLabel, widget.user.username),
            const SizedBox(height: 12),
            _buildInfoRow(AppStrings.emailLabel, widget.user.email),
            const SizedBox(height: 12),
            _buildVerificationRow(),
            const SizedBox(height: 12),
            _buildInfoRow(AppStrings.passwordLabel, '********'),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.accountVerifiedLabel,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(width: 8),
        if (widget.user.isVerified)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.verifiedBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              AppStrings.verifiedStatus,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
          )
        else
          GestureDetector(
            onTap: () {
              // TODO: Implementar verificación
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                AppStrings.verifyButton,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEditField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: isPassword ? AppStrings.passwordChangeHint : '',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  void _saveChanges() {
    final username = _usernameController.text != widget.user.username
        ? _usernameController.text
        : null;
    final email = _emailController.text != widget.user.email
        ? _emailController.text
        : null;
    final password = _passwordController.text.isNotEmpty
        ? _passwordController.text
        : null;

    widget.onUpdate(username, email, password);
    _passwordController.clear();
  }
}
