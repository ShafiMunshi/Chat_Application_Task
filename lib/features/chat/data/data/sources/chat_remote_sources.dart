import 'package:chat_application_task/core/shared/providers.dart';
import 'package:chat_application_task/features/chat/data/data/models/message_model.dart';
import 'package:chat_application_task/features/chat/domain/entities/message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRemoteSourceProvider = Provider<IChatRemoteSource>((ref) {
  return ChatRemoteSources(ref.watch(firebaseFirestoreProvider));
});

abstract interface class IChatRemoteSource {
  Stream<List<MessageModel>> getMessages(String chatId);
  Future<void> sendMessage(MessageEntity message);
}

class ChatRemoteSources implements IChatRemoteSource {
  final FirebaseFirestore _firestore;

  String chatsCollection = 'CHATS';
  String messageCollection = 'MESSAGES';

  ChatRemoteSources(this._firestore);
  @override
  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firestore
        .collection(chatsCollection)
        .doc(chatId)
        .collection(messageCollection)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromJson(doc.data()))
              .toList(),
        );
  }

  @override
  Future<void> sendMessage(MessageEntity message) async {
    try {
      final docRef = _firestore
          .collection(chatsCollection)
          .doc(message.chatId)
          .collection(messageCollection)
          .doc(message.id);
      await docRef.set(message.toMessageModel().toJson());
    } catch (e) {
      rethrow;
    }
  }
}
