import 'package:chat_application_task/core/constants/app_strings.dart';
import 'package:chat_application_task/features/auth/views/provider/auth_provider.dart';
import 'package:chat_application_task/features/chat/views/providers/all_chat_users_provider.dart';
import 'package:chat_application_task/features/chat/views/screens/chat_users/widgets/user_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
class AllChatUsersDisplay extends ConsumerWidget {
  const AllChatUsersDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserID = ref.watch(authStateProvider).value?.id;
    final searchText = ref.watch(userSearchProvider);
    final allStreamAsync = ref.watch(allUserStreamProvider(searchText));
    return Expanded(
      child: allStreamAsync.when(
        data: (users) => ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final chatUser = users[index];

                if (chatUser.id == currentUserID) {
                  return const SizedBox.shrink();
                }

                return UserListItem(
                  name: chatUser.name,
                  lastMessage: AppStrings.lastMessagePreview,
                  avatarLabel: chatUser.profilePictureUrl?.isNotEmpty ?? false
                      ? chatUser.profilePictureUrl![0]
                      : chatUser.name[0],
                  timestamp: '${index + 1}:0${index}m',
                  onTap: () {
                    final ids = [chatUser.id, currentUserID];
                    ids.sort();
                    final chatRoomId = ids.join('-');
                    final extraData = {
                      'otherUser': chatUser,
                      'chatId': chatRoomId,
                    };
                    context.push('/chat', extra: extraData);
                  },
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