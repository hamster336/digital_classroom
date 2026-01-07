import 'package:mobile_app/shared/required_enums.dart';

class Assignment {
  String id;
  String title;
  String description;
  DateTime issuedAt;
  DateTime dueDate;
  DateTime? submittedAt;
  AssignmentPriority priority;
  String? issueFilepath;
  String? submissionFilepath;
  bool submitted;
  int? submissionCount;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.issuedAt,
    required this.dueDate,
    this.submittedAt,
    required this.priority,
    required this.submitted,
    this.issueFilepath,
    this.submissionFilepath,
    this.submissionCount
  });

  Assignment copyWith({
    String? title,
    String? description,
    DateTime? issuedAt,
    DateTime? dueDate,
    DateTime? submittedAt,
    AssignmentPriority? priority,
    String? issueFilepath,
    String? submissionFilepath,
    bool? submitted,
    int? submissionCount
  }) {
    return Assignment(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      issuedAt: issuedAt ?? this.issuedAt,
      dueDate: dueDate ?? this.dueDate,
      submittedAt: submittedAt ?? this.submittedAt,
      priority: priority ?? this.priority,
      issueFilepath: issueFilepath ?? this.issueFilepath,
      submissionFilepath: submissionFilepath ?? this.submissionFilepath,
      submitted: submitted ?? this.submitted,
      submissionCount: submissionCount ?? this.submissionCount
    );
  }
}
