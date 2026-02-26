import 'package:chat_application_task/features/chat/domain/entities/message_entity.dart';
import 'package:chat_application_task/features/chat/domain/entities/user_last_message_entity.dart';
import 'package:chat_application_task/features/chat/domain/usecases/usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatMessagesStreamProvider = StreamProvider.autoDispose
    .family<List<MessageEntity>, String>((ref, chatId) {
      return ref.watch(getChatMessagesUsecaseProvider).getMessages(chatId);
    });

final userLastMessageProvider = FutureProvider.autoDispose
    .family<UserLastMessageEntity?, String>((ref, chatID) async {
      final result = await ref
          .watch(getUserLastMessageUsecaseProvider)
          .call(chatID);
      return result?.when((data) => data, (error) => null);
    });
