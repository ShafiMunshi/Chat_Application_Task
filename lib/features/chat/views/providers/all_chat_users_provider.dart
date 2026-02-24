import 'package:chat_application_task/features/auth/domain/entities/user_entity.dart';
import 'package:chat_application_task/features/chat/domain/usecases/usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'all_chat_users_provider.g.dart';

@riverpod
class AllChatUsers extends _$AllChatUsers {
  @override
  AsyncValue build() {
    return const AsyncValue.data(null);
  }

  Future<void> showAllChatUsers() async {
    if (state == const AsyncLoading()) return;

    state = const AsyncLoading();
    final allUsers = ref.read(getChatUsersUsecaseProvider).call();
    state = AsyncValue.data(allUsers);
  }
}

final allUserStreamProvider = StreamProvider.autoDispose<List<UserEntity>>((
  ref,
) {
  final getAllUserUsecase = ref.watch(getChatUsersUsecaseProvider);
  return getAllUserUsecase.call();
});
