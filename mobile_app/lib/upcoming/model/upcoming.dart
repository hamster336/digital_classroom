import 'package:mobile_app/shared/required_enums.dart';

class Upcoming {
  final String title;
  final DateTime eventAt;
  final UpcomingEventType type;
  final UpcomingEventPriority priority;

  Upcoming({
    required this.title,
    required this.eventAt,
    required this.type,
    required this.priority,
  });
}
