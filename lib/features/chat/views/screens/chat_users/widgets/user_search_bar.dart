import 'package:chat_application_task/core/constants/app_colors.dart';
import 'package:chat_application_task/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class UserSearchBar extends StatelessWidget {
  final Function(String)? onChanged;

  const UserSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          onChanged: onChanged,
          decoration: const InputDecoration(
            hintText: AppStrings.searchHint,
            hintStyle: TextStyle(color: AppColors.textMuted),
            prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}
