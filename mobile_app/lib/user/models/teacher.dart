import 'package:mobile_app/user/models/user.dart';

class Teacher extends AppUser {
  final String empId;
  final List<String> subjectIds;
  final List<String> classIds;
  bool? isClassTeacher;

  Teacher({
    required super.id,
    required super.name,
    required super.email,
    required super.createdAt,
    super.avatarPath,
    required this.empId,
    required this.subjectIds,
    required this.classIds,
  });
}
