

import 'package:chat_application_task/core/constants/app_colors.dart';
import 'package:chat_application_task/core/style/text_styles.dart';
import 'package:chat_application_task/features/auth/views/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class ChatDrawerWidget extends StatelessWidget {
  const ChatDrawerWidget({super.key, required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primaryColor),
            child: Text('Settings', style: AppTextStyles.heading3),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              ref.read(signOutProvider);
              context.go('/sign_in');
            },
          ),
        ],
      ),
    );
  }
}