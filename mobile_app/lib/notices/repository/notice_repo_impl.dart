import 'package:mobile_app/notices/models/notice.dart';
import 'package:mobile_app/notices/repository/notice_repo.dart';
import 'package:mobile_app/supabase/services/notice_services.dart';

class NoticeRepoImpl extends NoticeRepo {
  NoticeServices service;

  NoticeRepoImpl({required this.service});

  @override
  Future<List<Notice>> loadNotices({
    required int from,
    required int limit,
  }) async {
    try {
      final notices = await service.fetchNotices(from: from, limit: limit);
      
      return notices.map((n) => Notice.fromMap(n)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
