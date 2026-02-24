class UserEntity {
  final String id;
  final String name;
  String? profilePictureUrl;

  final String email;

  UserEntity({
    required this.id,
    required this.name,
    this.profilePictureUrl,
    required this.email,
  });
}
