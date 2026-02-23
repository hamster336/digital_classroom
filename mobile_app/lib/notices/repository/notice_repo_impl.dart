import 'package:mobile_app/notices/models/notice.dart';
import 'package:mobile_app/notices/repository/notice_repo.dart';
import 'package:mobile_app/shared/required_enums.dart';
import 'package:mobile_app/supabase/services/notice_services.dart';
import 'package:mobile_app/supabase/services/students_services.dart';
import 'package:mobile_app/supabase/services/teachers_services.dart';

class NoticeRepoImpl extends NoticeRepo {
  NoticeServices noticeService;
  StudentsServices studentsService;
  TeachersServices teachersService;

  NoticeRepoImpl({
    required this.noticeService,
    required this.studentsService,
    required this.teachersService,
  });

  @override
  Future<List<Notice>> loadNotices({
    required int from,
    required int limit,
  }) async {
    try {
      final notices = await noticeService.fetchNotices(
        from: from,
        limit: limit,
      );

      return notices.map((n) => Notice.fromMap(n)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateLastNoticeChecked({
    required String id,
    required UserRoles role,
    required DateTime time,
  }) async {
    try {
      if (role == UserRoles.student) {
        await studentsService.updateLastNoticeChecked(id, time.toUtc());
      } else if (role == UserRoles.teacher) {
        await teachersService.updateLastNoticeChecked(id, time.toUtc());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<int> countNewNotices({required DateTime lastChecked}) async {
    try {
      final count = await noticeService.countNewNotices(lastChecked);

      return count;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
