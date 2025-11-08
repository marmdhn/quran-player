import 'package:flutter/material.dart';

class ReciterAvatar extends StatelessWidget {
  final String? imagePath;
  final double size;
  final double borderRadius;

  const ReciterAvatar({
    super.key,
    this.imagePath,
    this.size = 56,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: imagePath != null
          ? Image.asset(
              imagePath!,
              width: size,
              height: size,
              fit: BoxFit.cover,
            )
          : Container(
              width: size,
              height: size,
              color: Colors.grey.shade800,
              child: const Icon(Icons.person, color: Colors.white),
            ),
    );
  }
}
