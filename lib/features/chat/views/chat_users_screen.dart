import 'package:chat_application_task/core/constants/app_colors.dart';
import 'package:chat_application_task/core/constants/app_strings.dart';
import 'package:chat_application_task/features/chat/views/providers/all_chat_users_provider.dart';
import 'package:chat_application_task/features/chat/views/widgets/user_avatar.dart';
import 'package:chat_application_task/features/chat/views/widgets/user_list_item.dart';
import 'package:chat_application_task/features/chat/views/widgets/user_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          const AllChatUsersDisplay(),
        ],
      ),
    );
  }
}

class AllChatUsersDisplay extends ConsumerWidget {
  const AllChatUsersDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: ref
          .watch(allUserStreamProvider)
          .when(
            data: (users) => ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return UserListItem(
                  name: user.name,
                  lastMessage: AppStrings.lastMessagePreview,
                  avatarLabel: user.profilePictureUrl?.isNotEmpty ?? false
                      ? user.profilePictureUrl![0]
                      : user.name[0],
                  timestamp: '${index + 1}:0${index}m',
                  onTap: () => context.push('/chat'),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) =>
                const Center(child: Text('Error loading users')),
          ),
    );
  }
}
