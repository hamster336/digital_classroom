import 'package:mobile_app/submission/model/submission.dart';

abstract class SubmissionRepo {
  Future<List<Submission>> getSubmissionsForStudent(String studentId);

  Future<Submission?> getSingleSubmission(String studentId, String assignmentId);

  Future<void> submitAssignment(Submission sub);

  Future<void> resubmitAssignment(Submission sub);

  Future<List<Submission>> getSubmissionsForTeacher(String assignmentId);

}
