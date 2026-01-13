import 'package:mobile_app/notices/models/notice.dart';
import 'package:mobile_app/shared/required_enums.dart';

class NoticeRepo {
  final _notices = [
    Notice(
      id: 'N1',
      title: '6th sem Mid terms',
      publishedAt: DateTime(2026, 1, 6, 14, 12, 22),
      description:
          '6th sem students will have to appear on their mid term examinations starting from 22nd of January from 10:30 in the morning.',
      priority: NoticePriority.important,
      scheduledAt: DateTime(2026, 01, 22, 10, 30),
    ),
    Notice(
      id: 'N2',
      title: 'Winter Holidays',
      publishedAt: DateTime(2026, 1, 5, 14, 12, 22),
      description:
          'This year, the winter vacation starts from 25th of Poush until 9th of Magh. The administration will remain open during the holidays.',
      priority: NoticePriority.info,
      scheduledAt: DateTime(2026, 01, 10),
    ),
    Notice(
      id: 'N3',
      title: 'Proposal Defense',
      publishedAt: DateTime(2026, 1, 5, 08, 56, 01),
      description:
          'All the 6th sem students are notified to prepare for their proposal defense this Saturday starting from 10:00 am.',
      priority: NoticePriority.urgent,
      scheduledAt: DateTime(2026, 01, 10, 10, 00),
    ),
    Notice(
      id: 'N4',
      title: 'FU cup team selection',
      publishedAt: DateTime(2026, 1, 2, 23, 55, 12),
      description:
          'The sports week will start from 13th of Magh so the department of Engineering notifies all the interested students to enlist their names in the games they are interested in. The selection will start soon.',
      priority: NoticePriority.important,
    ),
    Notice(
      id: 'N5',
      title: 'Winter Holidays',
      publishedAt: DateTime(2025, 12, 31, 14, 12, 22),
      description:
          'This year, the winter vacation starts from 25th of Poush until 9th of Magh. The administration will remain open during the holidays.',
      priority: NoticePriority.info,
    ),
    Notice(
      id: 'N6',
      title: 'Proposal Defense',
      publishedAt: DateTime(2025, 12, 23, 08, 56, 01),
      description:
          'All the 6th sem students are notified to prepare for their proposal defense this Saturday starting from 10:00 am.',
      priority: NoticePriority.urgent,
    ),
  ];

  List<Notice> fetchNotices() {
    return List.unmodifiable(_notices);
  }
}
