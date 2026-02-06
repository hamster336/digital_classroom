import 'package:mobile_app/shared/required_enums.dart';

class Notice {
  final String id;
  final String title;
  final DateTime publishedAt;
  final DateTime? scheduledAt;
  final String description;
  final NoticePriority priority;
  final List<String> seenby;

  Notice({
    required this.id,
    required this.title,
    required this.publishedAt,
    this.scheduledAt,
    required this.description,
    required this.priority,
    required this.seenby,
  });

  factory Notice.fromMap(Map<String, dynamic> map) {
    return Notice(
      id: map['id'],
      title: map['title'],
      publishedAt: DateTime.parse(map['published_at']),
      scheduledAt: map['scheduled_at'] == null ? null : DateTime.parse(map['scheduled_at']),
      description: map['description'],
      priority: getPriority(map['priority']),
      seenby: List<String>.from(map['seen_by']),
    );
  }

  static NoticePriority getPriority(String s) {
    if (s == 'urgent') return NoticePriority.urgent;
    if (s == 'important') return NoticePriority.important;

    return NoticePriority.info;
  }
}
