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

  Future<List<ClassStudents>> getClassStudents(
    String classId,
    String subjectId,
  );

  Future<void> downloadSubmission({
    required String fileName,
    required String filePath,
    required String className,
    required Function(int received, int total) onProgress,
  });

  Future<void> gradeSubmission ({
    required String submissionId,
    required double score,
    required String remarks,
  });
}
