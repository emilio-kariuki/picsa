import 'package:flutter/material.dart';

class ToggleFlash extends StatelessWidget {
  const ToggleFlash({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: height * 0.08,
      right: width * 0.05,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withOpacity(0.4),
        ),
        child: const Icon(
          Icons.flash_off,
          color: Colors.white,
          size: 15,
        ),
      ),
    );
  }
}
