import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/notices/repository/notice_repo_impl.dart';

part 'unread_count_event.dart';
part 'unread_count_state.dart';

class UnreadCountBloc extends Bloc<UnreadCountEvent, UnreadCountState> {
  final NoticeRepoImpl repository;
  UnreadCountBloc(this.repository) : super(CountLoading()) {
    on<LoadUnreadCount>(_loadUnreadCount);
    on<ClearCount>(_clearUnreadCount);
  }

  // load number of unread notices
  Future<void> _loadUnreadCount(LoadUnreadCount event, Emitter<UnreadCountState> emit) async{
    try{
      final count = await repository.countNewNotices(lastChecked: event.lastChecked);
      emit(CountLoaded(count: count));
    } catch(e) {
      emit(CountError(message: e.toString()));
    }
  }

  // clear unread notices count
  Future<void> _clearUnreadCount(ClearCount event, Emitter<UnreadCountState> emit) async{
    emit(CountLoaded(count: 0));
  }
}
