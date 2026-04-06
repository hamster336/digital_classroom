import 'package:mobile_app/shared/required_enums.dart';

abstract class AppUser {
  // admin, student, teacher
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final UserRoles role;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.role,
  });
}
