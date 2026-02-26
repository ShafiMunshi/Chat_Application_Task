import 'dart:developer';

import 'package:chat_application_task/core/constants/app_strings.dart';
import 'package:chat_application_task/features/auth/domain/entities/user_entity.dart';
import 'package:chat_application_task/features/auth/views/provider/auth_provider.dart';
import 'package:chat_application_task/features/chat/views/providers/all_chat_users_provider.dart';
import 'package:chat_application_task/features/chat/views/providers/chat_provider.dart';
import 'package:chat_application_task/features/chat/views/screens/chat_users/widgets/user_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AllChatUsersDisplay extends ConsumerWidget {
  const AllChatUsersDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserID = ref.watch(authStateProvider).value?.id;
    final searchText = ref.watch(userSearchProvider);
    final allStreamAsync = ref.watch(allUserStreamProvider(searchText));

    if (currentUserID == null) {
      return const Center(child: Text('User not authenticated'));
    }

    return Expanded(
      child: allStreamAsync.when(
        data: (users) => ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final chatUser = users[index];

            if (chatUser.id == currentUserID) {
              return const SizedBox.shrink();
            }

            // Generate chatId using the provided logic
            final ids = [chatUser.id, currentUserID];
            ids.sort();
            final chatRoomId = ids.join('-');

            return Consumer(
              builder: (context, ref, child) {
                final lastMessageAsync = ref.watch(
                  userLastMessageProvider(chatRoomId),
                );

                // Extract data or use fallbacks
                final lastMessageData = lastMessageAsync.value;
                final lastMessage = lastMessageData?.content.isNotEmpty == true
                    ? lastMessageData!.content
                    : AppStrings.lastMessagePreview;
                final timestamp = _formatTimestamp(lastMessageData?.timestamp);

                if (lastMessageAsync.hasValue && lastMessageData != null) {
                  // log("Last message for chat ${chatRoomId}: ${lastMessageData.content}");
                }

                return _buildUserListItem(
                  chatUser: chatUser,
                  chatRoomId: chatRoomId,
                  lastMessage: lastMessage,
                  timestamp: timestamp,
                  context: context,
                );
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

  Widget _buildUserListItem({
    required UserEntity chatUser,
    required String chatRoomId,
    required String lastMessage,
    required String timestamp,
    required BuildContext context,
  }) {
    return UserListItem(
      name: chatUser.name,
      lastMessage: lastMessage,
      avatarLabel: chatUser.profilePictureUrl?.isNotEmpty ?? false
          ? chatUser.profilePictureUrl![0]
          : chatUser.name[0],
      timestamp: timestamp,
      onTap: () {
        final extraData = {'otherUser': chatUser, 'chatId': chatRoomId};
        context.push('/chat', extra: extraData);
      },
    );
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    if (messageDate.isAtSameMomentAs(today)) {
      // Today - show time
      return DateFormat.Hm().format(timestamp);
    } else if (messageDate.isAtSameMomentAs(
      today.subtract(const Duration(days: 1)),
    )) {
      // Yesterday
      return AppStrings.yesterday;
    } else {
      // Older - show date
      return DateFormat('MMM d').format(timestamp);
    }
  }
}
