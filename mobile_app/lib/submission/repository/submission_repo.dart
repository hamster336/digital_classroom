import 'package:file_picker/file_picker.dart';
import 'package:mobile_app/app_file/models/app_file.dart';
import 'package:mobile_app/submission/model/class_students.dart';

abstract class SubmissionRepo {
  Future<List<AppFile>> getSubmissionsForStudent(
    String studentId,
    String classId,
  );

  Future<void> submitAssignment({
    required PlatformFile submission,
    required String classId,
    required String studentId,
    required String assignmentId,
  });

  Future<List<AppFile>> getSubmissionsForTeacher(
    String classId,
    List<String> assignmentIds,
  );

  Future<List<ClassStudents>> getClassStudents(String classId, String subjectId);
}
