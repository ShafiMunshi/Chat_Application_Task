import 'package:chat_application_task/core/errors/failures.dart';
import 'package:chat_application_task/features/auth/domain/entities/user_entity.dart';
import 'package:chat_application_task/features/chat/domain/entities/user_last_message_entity.dart';
import 'package:chat_application_task/features/chat/domain/repo/i_chat_users_repo.dart';
import 'package:multiple_result/multiple_result.dart';

class GetAllUserUsecase {
  final IChatUsersRepo _chatUsersRepo;

  GetAllUserUsecase(this._chatUsersRepo);

  Stream<List<UserEntity>> call() {
    return _chatUsersRepo.getAllUsers();
  }
}

class GetUserByIdUsecase {
  final IChatUsersRepo _chatUsersRepo;

  GetUserByIdUsecase(this._chatUsersRepo);

  Future<Result<UserEntity, Failure>?> call(String userId) {
    return _chatUsersRepo.getUserById(userId);
  }
}

class GetUserLastMessageUsecase {
  final IChatUsersRepo _chatUsersRepo;

  GetUserLastMessageUsecase(this._chatUsersRepo);

  Future<Result<UserLastMessageEntity, Failure>?> call(String chatID) {
    return _chatUsersRepo.getUserLastMessage(chatID);
  }
}
