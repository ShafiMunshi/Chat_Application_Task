import 'package:chat_application_task/core/constants/app_colors.dart';
import 'package:chat_application_task/core/constants/app_strings.dart';
import 'package:chat_application_task/features/chat/views/widgets/user_avatar.dart';
import 'package:chat_application_task/features/chat/views/widgets/user_list_item.dart';
import 'package:chat_application_task/features/chat/views/widgets/user_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatUsersScreen extends StatefulWidget {
  const ChatUsersScreen({super.key});

  @override
  State<ChatUsersScreen> createState() => _ChatUsersScreenState();
}

class _ChatUsersScreenState extends State<ChatUsersScreen> {
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leadingWidth: 56,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: UserAvatar(label: 'U', size: 40),
        ),
        title: const Text(AppStrings.myMessenger),
      ),
      body: Column(
        children: [
          UserSearchBar(controller: _searchController),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return UserListItem(
                  name: '${AppStrings.userLabelPrefix}${index + 1}',
                  lastMessage: AppStrings.lastMessagePreview,
                  avatarLabel: 'U${index + 1}',
                  timestamp: '${index + 1}:0${index}m',
                  onTap: () => context.push('/chat'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
