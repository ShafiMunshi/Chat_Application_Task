import 'package:chat_application_task/core/constants/app_colors.dart';
import 'package:chat_application_task/core/style/text_styles.dart';
import 'package:chat_application_task/features/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

import 'user_avatar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserEntity user;

  const CustomAppBar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leadingWidth: 56,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: UserAvatar(label: user.name, size: 40),
      ),
      titleTextStyle: AppTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.bold,
      ),
      title: Text(user.name),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
