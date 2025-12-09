import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40, // Cambiado de 25 a 40
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF71D7AE).withOpacity(0.9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.white.withOpacity(0.9),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem('Home', 0),
              _buildNavItem('Mis reportes', 1),
              _buildNavItem('Perfil', 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, int index) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(2, 4),
                    blurRadius: 12,
                  ),
                ],
              )
            : null,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.prussianBlue : AppColors.white,
          ),
        ),
      ),
    );
  }
}
