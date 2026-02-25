import 'dart:developer';

import 'package:chat_application_task/core/constants/app_colors.dart';
import 'package:chat_application_task/core/shared/widgets/custom_appbar.dart';
import 'package:chat_application_task/features/auth/views/provider/auth_provider.dart';
import 'package:chat_application_task/features/chat/views/screens/chat_users/widgets/user_search_bar.dart';
import 'package:chat_application_task/features/chat/views/screens/chat_users/widgets/all_chat_user.dart';
import 'package:chat_application_task/features/chat/views/screens/chat_users/widgets/chat_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatUsersScreen extends ConsumerStatefulWidget {
  const ChatUsersScreen({super.key});

  @override
  ConsumerState<ChatUsersScreen> createState() => _ChatUsersScreenState();
}

class _ChatUsersScreenState extends ConsumerState<ChatUsersScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authStateProvider).value;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: currentUser != null ? CustomAppBar(user: currentUser) : null,
      endDrawer: ChatDrawerWidget(ref: ref),
      body: Column(
        children: [
          UserSearchBar(controller: _searchController),
          const AllChatUsersDisplay(),
        ],
      ),
    );
  }
}
