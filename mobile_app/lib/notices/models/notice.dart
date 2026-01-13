import 'package:mobile_app/shared/required_enums.dart';

class Notice {
  final String id;
  final String title;
  final DateTime publishedAt;
  final DateTime? scheduledAt;
  final String description;
  final NoticePriority priority;

  Notice({
    required this.id,
    required this.title,
    required this.publishedAt,
    this.scheduledAt,
    required this.description,
    required this.priority,
  });
}
