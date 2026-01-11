class Submission {
  String id;
  String assignmentId; // links to Assignment
  String studentId;
  DateTime submittedAt;
  String? submissionFilepath;

  Submission({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.submittedAt,
    this.submissionFilepath,
  });
}
