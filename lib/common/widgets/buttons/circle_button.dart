import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  final Color color;
  final IconData iconData;
  final Function()? onTap;

  const CircleIcon(
      {super.key, required this.color, required this.iconData, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(iconData, color: color, size: 20),
      ),
    );
  }
}
