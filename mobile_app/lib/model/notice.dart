import 'package:mobile_app/model/required_enums.dart';

class Notice {
  final String title;
  final DateTime publishedAt;
  final String description;
  final InfoPriority priority;

  Notice({
    required this.title,
    required this.publishedAt,
    required this.description,
    required this.priority,
  });
}