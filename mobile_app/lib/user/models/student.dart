import 'package:mobile_app/shared/required_enums.dart';
import 'package:mobile_app/user/models/app_user.dart';

class Student extends AppUser {
  final String rollNumber;
  final String classId;
  final List<String> subjectIds;

  Student({
    required super.id,
    required super.name,
    required super.email,
    required super.createdAt,
    required super.role,
    super.avatarPath,
    required this.rollNumber,
    required this.classId,
    required this.subjectIds,
  });

  factory Student.fromMap(
    Map<String, dynamic> user,
    Map<String, dynamic> studentData,
  ) {
    return Student(
      id: user['id'],
        name: user['full_name'],
        email: user['email'],
        createdAt: DateTime.parse(user['created_at']),
        role: UserRoles.student,
        avatarPath: user['avatar_url'],
        rollNumber: studentData['roll_number'],
        classId: studentData['class_id'],
        subjectIds: List<String>.from(studentData['subject_ids']),
    );
  }
}
