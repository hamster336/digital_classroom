import 'package:mobile_app/submission/model/submission.dart';
import 'package:mobile_app/submission/repository/submission_repo.dart';
import 'package:mobile_app/supabase/services/submission_services.dart';

class SubmissionRepoImpl extends SubmissionRepo {
  final SubmissionServices services;

  SubmissionRepoImpl({required this.services});

  @override
  Future<List<Submission>> getSubmissionsForStudent(String studentId) async {
    try {
      final submissions = await services.fetchSubmissionsForStudent(studentId);

      return submissions.map((s) => Submission.fromMap(s)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Submission?> getSingleSubmission(
    String studentId,
    String assignmentId,
  ) async {
    try {
      final submission = await services.fetchSingleSubmission(
        studentId,
        assignmentId,
      );

      if (submission != null) {
        return Submission.fromMap(submission);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> submitAssignment(Submission sub) async {
    try {
      await services.addSubmission(Submission.toMap(sub));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> resubmitAssignment(Submission sub) async {
    try {
      await services.updateSubmission(Submission.toMap(sub));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Submission>> getSubmissionsForTeacher(String assignmentId) async {
    try {
      final submissions = await services.fetchSubmissionForTeacher(
        assignmentId,
      );

      return submissions.map((s) => Submission.fromMap(s)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
