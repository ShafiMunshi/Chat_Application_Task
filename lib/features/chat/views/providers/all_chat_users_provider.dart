import 'package:chat_application_task/features/auth/domain/entities/user_entity.dart';
import 'package:chat_application_task/features/chat/domain/usecases/usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_chat_users_provider.g.dart';

final allUserStreamProvider = StreamProvider.autoDispose
    .family<List<UserEntity>, String>((ref, String userName) async* {
      final getAllUserUsecase = ref.watch(getChatUsersUsecaseProvider);
      yield* getAllUserUsecase.call().map((users) => users.where((user) => user.name.toLowerCase().contains(userName.toLowerCase())).toList());

    });

@riverpod
class UserSearch extends _$UserSearch {
  @override
  String build() => '';

  void update(String value) => state = value;
}