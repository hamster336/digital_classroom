import 'package:mobile_app/notices/models/notice.dart';
import 'package:mobile_app/shared/required_enums.dart';

abstract class NoticeRepo {
  Future<List<Notice>> loadNotices({required int from, required int limit});

  Future<int> countNewNotices({required DateTime lastChecked});

  Future<void> updateLastNoticeChecked({required String id, required UserRoles role, required DateTime time});
}
