import 'package:mobile_app/submission/model/submission.dart';

class SubmissionRepo {
  final submission = [
    Submission(
      id: 'sub1',
      assignmentId: 'assign1',
      studentId: 'stud1',
      submittedAt: DateTime(2026, 01, 10),
    ),
    Submission(
      id: 'sub2',
      assignmentId: 'assign4',
      studentId: 'stud1',
      submittedAt: DateTime(2026, 01, 10),
    ),
  ];

  List<Submission> fetchSubmissions(String studentId) {
    return submission.where((s) => s.studentId == studentId).toList();
  }
}
