import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/upcoming/model/upcoming.dart';
import 'package:mobile_app/notices/models/notice.dart';
import 'package:mobile_app/shared/required_enums.dart';

extension AssignmentMapper on Assignment {
  Upcoming toUpcoming() {
    return Upcoming(
      title: title,
      eventAt: dueDate,
      priority: mapAssignmentPriority(priority),
      type: UpcomingEventType.assignment,
    );
  }
}

extension NoticeMapper on Notice {
  Upcoming toUpcoming() {
    return Upcoming(
      title: title,
      eventAt: scheduledAt!,
      priority: mapNoticePriority(priority),
      type: UpcomingEventType.notice,
    );
  }
}

UpcomingEventPriority mapNoticePriority(NoticePriority priority) {
  switch (priority) {
    case NoticePriority.urgent:
      return UpcomingEventPriority.urgent;
    case NoticePriority.important:
      return UpcomingEventPriority.medium;
    case NoticePriority.info:
      return UpcomingEventPriority.normal;
  }
}

UpcomingEventPriority mapAssignmentPriority(AssignmentPriority priority) {
  switch (priority) {
    case AssignmentPriority.urgent:
      return UpcomingEventPriority.urgent;
    case AssignmentPriority.medium:
      return UpcomingEventPriority.medium;
    case AssignmentPriority.normal:
      return UpcomingEventPriority.normal;
  }
}
