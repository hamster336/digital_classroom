import 'package:mobile_app/model/required_enums.dart';

class Assignment {
  String title;
  String description;
  DateTime issuedAt;
  DateTime dueDate;
  AssignmentPriority priority;
  String? filepath;

  Assignment({
    required this.title,
    required this.description,
    required this.issuedAt,
    required this.dueDate,
    required this.priority,
    this.filepath
  });
}