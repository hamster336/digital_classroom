abstract class AppUser {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final String? avatarPath;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.avatarPath,
  });
}
