import 'package:mobile_app/shared/required_enums.dart';
import 'package:mobile_app/user/models/app_user.dart';

class Student extends AppUser {
  final String? avatarPath;
  final String? avatarURL;

  final String rollNumber;
  final String classId;
  final List<String> subjectIds;
  final DateTime lastCheckedNotices;

  Student({
    required super.id,
    required super.name,
    required super.email,
    required super.createdAt,
    required super.role,
    this.avatarPath,
    this.avatarURL,
    required this.rollNumber,
    required this.classId,
    required this.subjectIds,
    required this.lastCheckedNotices,
  });

  factory Student.fromMap(
    Map<String, dynamic> user,
    Map<String, dynamic> studentData,
  ) {
    return Student(
      id: user['id'],
        name: user['full_name'],
        email: user['email'],
        createdAt: DateTime.parse(user['created_at']).toLocal(),
        role: UserRoles.student,
        avatarPath: studentData['avatar_path'],
        avatarURL: studentData['avatar_url'],
        rollNumber: studentData['roll_number'],
        classId: studentData['class_id'],
        subjectIds: List<String>.from(studentData['subject_ids']),
        lastCheckedNotices: DateTime.parse(studentData['last_checked_notices']).toLocal()
    );
  }
}
