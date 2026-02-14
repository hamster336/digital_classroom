class Submission {
  String? id;
  String assignmentId;
  String studentId;
  DateTime submittedAt;
  String? submissionFilepath;

  Submission({
    this.id,
    required this.assignmentId,
    required this.studentId,
    required this.submittedAt,
    this.submissionFilepath,
  });

  factory Submission.fromMap(Map<String, dynamic> map) {
    return Submission(
      id: map['id'],
      assignmentId: map['assignment_id'],
      studentId: map['student_id'],
      submittedAt: map['submitted_at'],
      submissionFilepath: map['submission_file_path'],
    );
  }

  static Map<String, dynamic> toMap(Submission sub) {
    final map = {
      'assignment_id': sub.assignmentId,
      'student_id': sub.studentId,
      'submitted_at': sub.submittedAt.toIso8601String(),
    };

    if (sub.id != null) map['id'] = sub.id!;

    return map;
  }

  Submission copyWith({
    String? id,
    DateTime? submittedAt,
    String? submissionFilepath,
  }) {
    return Submission(
      id: id ?? this.id,
      assignmentId: assignmentId,
      studentId: studentId,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }
}
