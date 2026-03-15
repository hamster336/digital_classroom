import 'package:mobile_app/shared/required_enums.dart';

class Assignment {
  String? id;
  String title;
  String description;
  DateTime issuedAt;
  String classId;
  String subjectId;
  String teacherId;
  DateTime dueDate;
  AssignmentPriority priority;

  Assignment({
    this.id,
    required this.title,
    required this.description,
    required this.issuedAt,
    required this.dueDate,
    required this.classId,
    required this.subjectId,
    required this.teacherId,
    required this.priority,
  });

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      issuedAt: DateTime.parse(map['issued_at']).toLocal(),
      dueDate: DateTime.parse(map['due_date']).toLocal(),
      subjectId: map['subject_id'],
      classId: map['class_id'],
      teacherId: map['teacher_id'],
      priority: getPriority(map['priority']),
    );
  }

  // Assignment a
  static Map<String, dynamic> toMap(Assignment a) {
    final map = {
      'title': a.title,
      'description': a.description,
      'issued_at': a.issuedAt.toUtc().toIso8601String(),
      'due_date': a.dueDate.toUtc().toIso8601String(),
      'subject_id': a.subjectId,
      'class_id': a.classId,
      'teacher_id': a.teacherId,
      'priority': setPriority(a.priority),
    };

    if (a.id != null) map['id'] = a.id!;

    return map;
  }

  Assignment copyWith({
    String? title,
    String? description,
    DateTime? issuedAt,
    DateTime? dueDate,
    String? subjectId,
    AssignmentPriority? priority,
    int? submissionCount,
  }) {
    return Assignment(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      issuedAt: issuedAt ?? this.issuedAt,
      dueDate: dueDate ?? this.dueDate,
      classId: classId,
      subjectId: subjectId ?? this.subjectId,
      teacherId: teacherId,
      priority: priority ?? this.priority,
    );
  }

  static AssignmentPriority getPriority(String s) {
    if (s == 'urgent') return AssignmentPriority.urgent;
    if (s == 'medium') return AssignmentPriority.medium;
    return AssignmentPriority.normal;
  }

  static String setPriority(AssignmentPriority p) {
    if (p == AssignmentPriority.urgent) return 'urgent';
    if (p == AssignmentPriority.medium) return 'medium';
    return 'normal';
  }
}
