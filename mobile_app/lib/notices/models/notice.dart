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

  factory Notice.fromMap(Map<String, dynamic> map) {
    return Notice(
      id: map['id'],
      title: map['title'],
      publishedAt: DateTime.parse(map['published_at']).toLocal(),
      scheduledAt: map['scheduled_at'] == null
          ? null
          : DateTime.parse(map['scheduled_at']).toLocal(),
      description: map['description'],
      priority: getPriority(map['priority']),
    );
  }

  static NoticePriority getPriority(String s) {
    if (s == 'urgent') return NoticePriority.urgent;
    if (s == 'important') return NoticePriority.important;

    return NoticePriority.info;
  }
}
