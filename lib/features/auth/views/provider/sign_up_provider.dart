import 'package:chat_application_task/features/auth/domain/entities/sign_up_entity.dart';
import 'package:chat_application_task/features/auth/domain/usecases/usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_provider.g.dart';

@riverpod
class SignUp extends _$SignUp {
  @override
  AsyncValue build() {
    return const AsyncValue.data(null);
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    bool? shouldRemember,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref
        .read(signUpUsecaseProvider)
        .call(
          SignUpRequestEntity(name: name, password: password, email: email),
        );

    if (ref.mounted) {
      state = result.when(
        (data) => AsyncValue.data(data),
        (error) => AsyncValue.error(error.message, StackTrace.current),
      );
    }
  }
}
