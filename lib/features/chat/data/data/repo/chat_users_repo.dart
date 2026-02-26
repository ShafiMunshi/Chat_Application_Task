import 'package:chat_application_task/core/errors/failures.dart';
import 'package:chat_application_task/features/auth/data/models/user_model.dart';
import 'package:chat_application_task/features/auth/domain/entities/user_entity.dart';
import 'package:chat_application_task/features/chat/data/data/sources/user_remote_sources.dart';
import 'package:chat_application_task/features/chat/domain/entities/user_last_message_entity.dart';
import 'package:chat_application_task/features/chat/domain/repo/i_chat_users_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/src/result.dart';

final chatUsersRepoProvider = Provider<IChatUsersRepo>((ref) {
  final userRemoteSource = ref.watch(userRemoteSourceProvider);
  return ChatUsersRepo(userRemoteSource);
});

class ChatUsersRepo implements IChatUsersRepo {
  final IUserRemoteSource _userRemoteSource;

  ChatUsersRepo(this._userRemoteSource);

  @override
  Stream<List<UserEntity>> getAllUsers() {
    return _userRemoteSource.getAllUsers().map(
      (users) => users.map((user) => user.toUserEntity()).toList(),
    );
  }

  @override
  Future<Result<UserEntity, Failure>?> getUserById(String userId) async {
    try {
      final user = await _userRemoteSource.getUserById(userId);
      if (user != null) {
        return Result.success(user.toUserEntity());
      } else {
        return const Result.error(
          Failure(message: "No Data Found for the given user"),
        );
      }
    } catch (e) {
      return Result.error(Failure(message: e.toString()));
    }
  }

  @override
  Future<Result<UserLastMessageEntity, Failure>?> getUserLastMessage(String chatID) async {
    try {
      final lastMessage = await _userRemoteSource.getUserLastMessage(chatID);
      return Result.success(lastMessage.toEntity());
    } catch (e) {
      return Result.error(Failure.mapExceptionToFailure(e));
    }
  }
}
