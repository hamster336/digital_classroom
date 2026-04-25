import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:mobile_app/app_file/models/app_file.dart';
import 'package:mobile_app/shared/public_directory.dart';
import 'package:mobile_app/submission/model/class_students.dart';
import 'package:mobile_app/submission/repository/submission_repo.dart';
import 'package:mobile_app/supabase/services/students_services.dart';
import 'package:mobile_app/supabase/services/submission_services.dart';

class SubmissionRepoImpl extends SubmissionRepo {
  final SubmissionServices subServices;
  final StudentsServices studentServices;

  SubmissionRepoImpl({
    required this.subServices,
    required this.studentServices,
  });

  @override
  Future<List<AppFile>> getSubmissionsForStudent(
    String studentId,
    String classId,
  ) async {
    try {
      final submissions = await subServices.fetchSubmissionsForStudent(
        classId: classId,
        studentId: studentId,
      );

      return submissions.map((s) => AppFile.fromMap(s)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> submitAssignment({
    required PlatformFile submission,
    required String classId,
    required String studentId,
    required String assignmentId,
  }) async {
    try {
      final path = submission.path!;
      final file = File(path);
      final bytes = await file.readAsBytes();

      final mimeType =
          lookupMimeType(path, headerBytes: bytes) ??
          'application/octet_stream';

      final storagePath = '$classId/${submission.name}';

      final sub = AppFile(
        uploaderId: studentId,
        classId: classId,
        ownerId: assignmentId,
        context: .assignments,
        filePath: storagePath,
        fileName: submission.name,
        mimeType: mimeType,
        fileSize: submission.size,
        createdAt: DateTime.now(),
      );

      await subServices.addSubmission(
        file: file,
        map: sub.toMap(),
        storagePath: storagePath,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<AppFile>> getSubmissionsForTeacher(
    String classId,
    List<String> assignmentIds,
  ) async {
    try {
      final submissions = await subServices.fetchSubmissionForTeacher(
        classId,
        assignmentIds,
      );

      return submissions.map((s) => AppFile.fromMap(s)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<ClassStudents>> getClassStudents(
    String classId,
    String subjectId,
  ) async {
    try {
      final students = await studentServices.fetchStudentsOfClass(
        classId,
        subjectId,
      );

      return students.map((s) => ClassStudents.fromMap(s)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> downloadSubmission({
    required String fileName,
    required String filePath,
    required String className,
    required Function(int received, int total) onProgress,
  }) async {
    try {
      final directory = await PublicDirectory.getPublicDirectoryPath();
      await subServices.downloadSubmission(
        filePath: filePath,
        fileName: fileName,
        className: className,
        directory: directory!,
        onProgress: (recieved, total) => onProgress(recieved, total),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> gradeSubmission({
    required String submissionId,
    required double score,
    required String remarks,
  }) async {
    try {
      await subServices.gradeSubmission(
        submissionId: submissionId,
        score: score,
        remarks: remarks,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
