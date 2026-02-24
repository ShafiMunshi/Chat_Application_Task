import 'package:chat_application_task/features/chat/domain/entities/message_entity.dart';
import 'package:chat_application_task/features/chat/domain/usecases/usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatMessagesStreamProvider =
    StreamProvider.family<List<MessageEntity>, String>((ref, chatId) {
      return ref.watch(getChatMessagesUsecaseProvider).getMessages(chatId);
    });


final sentChatMessageProvider = Provider.family<void, MessageEntity>((
  ref,
  message,
) {
  final sendMessageUsecase = ref.watch(sendMessageUsecaseProvider);
  sendMessageUsecase(message);
});
