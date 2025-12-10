import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String? imageUrl;

  const ProfileImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFBED2FF),
      ),
      child: imageUrl != null
          ? ClipOval(
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox();
                },
              ),
            )
          : null,
    );
  }
}
