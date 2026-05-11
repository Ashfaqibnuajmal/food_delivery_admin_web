import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';

class NotificationDeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NotificationDeleteButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: 'Delete',
      style: IconButton.styleFrom(
        backgroundColor: AppColors.errorRed.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: const Icon(
        Icons.delete_outline_rounded,
        color: AppColors.errorRed,
        size: 20,
      ),
    );
  }
}
