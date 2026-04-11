import 'package:mobile_app/shared/required_enums.dart';
import 'package:mobile_app/user/models/app_user.dart';

class Teacher extends AppUser {
  final String? avatarPath;
  final String? avatarURL;

  final String empId;
  final List<String> subjectIds;
  final List<String> classIds;
  final DateTime lastCheckedNotices;

  Teacher({
    required super.id,
    required super.name,
    required super.email,
    required super.createdAt,
    required super.role,
    this.avatarPath,
    this.avatarURL,
    required this.empId,
    required this.subjectIds,
    required this.classIds,
    required this.lastCheckedNotices,
  });

  factory Teacher.fromMap(
    Map<String, dynamic> user,
    Map<String, dynamic> teacherData,
  ) {
    return Teacher(
      id: user['id'],
      name: user['full_name'],
      email: user['email'],
      createdAt: DateTime.parse(user['created_at']).toLocal(),
      role: UserRoles.teacher,
      avatarPath: teacherData['avatar_path'],
      avatarURL: teacherData['avatar_url'],
      empId: teacherData['employee_id'],
      subjectIds: List<String>.from(teacherData['subject_ids']),
      classIds: List<String>.from(teacherData['class_ids']),
      lastCheckedNotices: DateTime.parse(teacherData['last_checked_notices']).toLocal(),
    );
  }
}
