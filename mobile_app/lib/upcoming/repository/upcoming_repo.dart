import 'package:mobile_app/upcoming/model/upcoming.dart';

abstract class UpcomingRepo {
  Future<List<Upcoming>> fetchUpcomingEvents(List<String> subjectIds);
}