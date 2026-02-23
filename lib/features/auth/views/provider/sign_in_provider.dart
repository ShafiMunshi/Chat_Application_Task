import 'package:chat_application_task/features/auth/domain/entities/sign_in_entity.dart';
import 'package:chat_application_task/features/auth/domain/usecases/usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_provider.g.dart';

@riverpod
class SignIn extends _$SignIn {
  @override
  AsyncValue build() {
    return const AsyncValue.data(null);
  }

  Future<void> signIn({
    required String email,
    required String password,
    bool? shouldRemember,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref
        .read(signInUsecaseProvider)
        .call(SignInRequestEntity(email: email, password: password));

    state = result.when(
      (data) => AsyncValue.data(data),
      (error) => AsyncValue.error(error.message, StackTrace.current),
    );
  }
}
