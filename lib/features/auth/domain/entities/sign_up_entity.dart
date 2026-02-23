class SignUpRequestEntity {
  final String name;
  final String password;
  final String email;

  SignUpRequestEntity({
    required this.name,
    required this.password,
    required this.email,
  });
}

class SignUpResponseEntity {
  final String token;
  final bool isSignUpSuccess;

  SignUpResponseEntity({required this.token, required this.isSignUpSuccess});
}
