import 'package:flutter/material.dart';
import 'package:stream_chat_app/theme.dart';

class IconBackground extends StatelessWidget {
  const IconBackground({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(60),
      child: InkWell(
        borderRadius: BorderRadius.circular(60),
        splashColor: AppColors.secondary,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: 18,
          ),
        ),
      ),
    );
  }
}
