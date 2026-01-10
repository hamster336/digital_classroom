import 'package:mobile_app/user/models/app_user.dart';

class Student extends AppUser {
  final String rollNumber;
  final String grade;
  final String section;
  final List<String> subjectIds;

  Student({
    required super.id,
    required super.name,
    required super.email,
    required super.createdAt,
    required super.role,
    super.avatarPath,
    required this.rollNumber,
    required this.grade,
    required this.section,
    required this.subjectIds,
  });
}
