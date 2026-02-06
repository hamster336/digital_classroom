import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/mappers/mapper.dart';
import 'package:mobile_app/notices/models/notice.dart';
import 'package:mobile_app/supabase/services/upcoming_services.dart';
import 'package:mobile_app/upcoming/model/upcoming.dart';
import 'package:mobile_app/upcoming/repository/upcoming_repo.dart';

class UpcomingRepoImpl extends UpcomingRepo {
  final UpcomingServices service;

  UpcomingRepoImpl({required this.service});

  @override
  Future<List<Upcoming>> fetchUpcomingEvents(List<String> subjectIds) async {
    try {
      final assignments = await service.fetchUpcomingAssignments(subjectIds);

      final notices = await service.fetchUpcomingNotices();

      final events = <Upcoming>[
        ...assignments.map((a) => Assignment.fromMap(a).toUpcoming()),
        ...notices.map((n) => Notice.fromMap(n).toUpcoming()),
      ];

      events.sort((a, b) => a.eventAt.compareTo(b.eventAt));

      return events;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
