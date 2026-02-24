import 'package:chat_application_task/features/auth/domain/entities/user_entity.dart';
import 'package:chat_application_task/features/chat/domain/usecases/usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final allUserStreamProvider = StreamProvider.autoDispose<List<UserEntity>>((
  ref,
) {
  final getAllUserUsecase = ref.watch(getChatUsersUsecaseProvider);
  return getAllUserUsecase.call();
});
