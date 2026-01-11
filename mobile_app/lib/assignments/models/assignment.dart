import 'package:mobile_app/shared/required_enums.dart';

class Assignment {
  String id;
  String title;
  String description;
  DateTime issuedAt;
  String classId;
  String teacherId;
  DateTime dueDate;
  AssignmentPriority priority;
  String? issueFilepath;
  int? submissionCount;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.issuedAt,
    required this.dueDate,
    required this.classId,
    required this.teacherId,
    required this.priority,
    this.issueFilepath,
    this.submissionCount,
  });

  Assignment copyWith({
    String? title,
    String? description,
    DateTime? issuedAt,
    DateTime? dueDate,
    String? classId,
    String? teacherId,
    AssignmentPriority? priority,
    String? issueFilepath,
    int? submissionCount,
  }) {
    return Assignment(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      issuedAt: issuedAt ?? this.issuedAt,
      dueDate: dueDate ?? this.dueDate,
      classId: this.classId,
      teacherId: this.teacherId,
      priority: priority ?? this.priority,
      issueFilepath: issueFilepath ?? this.issueFilepath,
      submissionCount: submissionCount ?? this.submissionCount,
    );
  }
}
