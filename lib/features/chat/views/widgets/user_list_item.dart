import 'package:chat_application_task/core/constants/app_colors.dart';
import 'package:chat_application_task/core/style/text_styles.dart';
import 'package:chat_application_task/features/chat/views/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class UserListItem extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String avatarLabel;
  final String timestamp;
  final VoidCallback onTap;

  const UserListItem({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.avatarLabel,
    required this.timestamp,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          leading: UserAvatar(label: avatarLabel),
          title: Text(
            name,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            lastMessage,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          trailing: Text(
            timestamp,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
