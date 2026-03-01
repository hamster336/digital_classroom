import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:mobile_app/app_file/models/app_file.dart';
import 'package:mobile_app/submission/repository/submission_repo.dart';
import 'package:mobile_app/supabase/services/submission_services.dart';

class SubmissionRepoImpl extends SubmissionRepo {
  final SubmissionServices services;

  SubmissionRepoImpl({required this.services});

  @override
  Future<List<AppFile>> getSubmissionsForStudent(
    String studentId,
    String classId,
  ) async {
    try {
      final submissions = await services.fetchSubmissionsForStudent(
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

      await services.addSubmission(
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
      final submissions = await services.fetchSubmissionForTeacher(
        classId,
        assignmentIds,
      );
      
      return submissions.map((s) => AppFile.fromMap(s)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
