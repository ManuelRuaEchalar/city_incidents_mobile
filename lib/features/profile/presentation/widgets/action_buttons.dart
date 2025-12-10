import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onLogout;

  const ActionButtons({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ActionButton(
              icon: Icons.email_outlined,
              label: 'Contacto',
              onTap: () => _launchEmail(),
            ),
            const SizedBox(width: 16),
            _ActionButton(
              icon: Icons.help_outline,
              label: 'Preguntas frecuentes',
              onTap: () => _showFAQDialog(context),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 321,
          height: 52,
          child: ElevatedButton(
            onPressed: onLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8A89),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/logout.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'juanruaxo@gmail.com',
      query: 'subject=Consulta sobre la aplicación',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      }
    } catch (e) {
      // Error al abrir email
      debugPrint('Error al abrir email: $e');
    }
  }

  void _showFAQDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preguntas Frecuentes'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '¿Qué es esta aplicación?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Aplicación móvil para monitoreo y reporte de incidencias urbanas.',
              ),
              const SizedBox(height: 16),
              const Text(
                '¿Qué problema resuelve?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Los ciudadanos carecen de un medio ágil para reportar problemas de infraestructura, lo que provoca demoras y pérdida de información.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Características principales:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Registro de incidencias con foto y ubicación\n'
                '• Clasificación por tipo de problema\n'
                '• Visualización en mapa\n'
                '• Notificaciones cuando sean atendidas\n'
                '• Panel web para gestión municipal',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _isPressed
              ? AppColors.deepTeal.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: _isPressed
                ? AppColors.deepTeal.withOpacity(0.8)
                : AppColors.deepTeal.withOpacity(0.6),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: 20,
              color: _isPressed
                  ? AppColors.deepTeal.withOpacity(0.8)
                  : AppColors.deepTeal,
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _isPressed
                    ? AppColors.deepTeal.withOpacity(0.8)
                    : AppColors.deepTeal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
