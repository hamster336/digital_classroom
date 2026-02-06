import 'package:mobile_app/notices/models/notice.dart';

abstract class NoticeRepo {
  Future<List<Notice>> loadNotices({required int from, required int limit});
}
