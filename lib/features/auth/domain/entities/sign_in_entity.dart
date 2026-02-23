class SignInRequestEntity {
  final String email;
  final String password;

  SignInRequestEntity({required this.email, required this.password});
}

class SignInResponseEntity {
  final String token;
  final bool isSignInSuccess;

  SignInResponseEntity({required this.token, required this.isSignInSuccess});
}
