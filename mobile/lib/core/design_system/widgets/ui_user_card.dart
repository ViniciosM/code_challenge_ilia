import 'package:flutter/material.dart';
import 'package:ilia_users/core/design_system/theme/app_colors.dart';
import 'ui_text.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String email;

  const UserCard({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: UIText.body(name[0].toUpperCase(), color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIText.body(name, fontWeight: FontWeight.bold),
                UIText.body(
                  email,
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}
