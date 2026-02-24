import 'package:chat_application_task/core/errors/failures.dart';
import 'package:chat_application_task/features/auth/data/models/user_model.dart';
import 'package:chat_application_task/features/chat/data/data/sources/user_remote_sources.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../auth/domain/entities/user_entity.dart';



abstract interface class IChatUsersRepo {
  Stream<List<UserEntity>> getAllUsers();
  Future<Result<UserEntity, Failure>?> getUserById(String userId);
}

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
  Future<Result<UserEntity, Failure>?> getUserById(String userId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }
}
