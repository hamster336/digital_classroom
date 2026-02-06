import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/notices/bloc/notice_bloc.dart';
import 'package:mobile_app/notices/view/notice_list.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/shared/required_enums.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  final _scrollController = ScrollController();
  var filter = NoticeFilter.all;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = context.read<NoticeBloc>().state;
    if (state is NoticeLoaded && state.isLoadingMore) return;
    if (state is NoticeLoaded && state.hasReachedMax) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<NoticeBloc>().add(LoadNotices(currentFilter: filter));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Notices')),

      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
        child: BlocListener<NoticeBloc, NoticeState>(
          listener: (context, state) {
            if (state is NoticeError) {
              CustomWidgets.customAltertBox(
                context,
                state.message,
                () => context.read<NoticeBloc>().add(
                  LoadNotices(currentFilter: filter),
                ),
              );
            }
          },

          child: Column(
            children: [
              BlocBuilder<NoticeBloc, NoticeState>(
                builder: (context, state) {
                  final currentFilter = (state is NoticeLoaded)
                      ? state.filter
                      : filter;

                  return Row(
                    children: [
                      CustomWidgets.noticeFilterButton(
                        label: 'All',
                        isSelected: currentFilter == NoticeFilter.all,
                        onTap: () {
                          filter = NoticeFilter.all;
                          context.read<NoticeBloc>().add(
                            FilterNotices(filter: NoticeFilter.all),
                          );
                        },
                      ),
                      const SizedBox(width: 5),
                      CustomWidgets.noticeFilterButton(
                        label: 'Important',
                        isSelected: currentFilter == NoticeFilter.important,
                        onTap: () {
                          filter = NoticeFilter.important;
                          context.read<NoticeBloc>().add(
                            FilterNotices(filter: NoticeFilter.important),
                          );
                        },
                      ),
                      const SizedBox(width: 5),
                      CustomWidgets.noticeFilterButton(
                        label: 'Urgent',
                        isSelected: currentFilter == NoticeFilter.urgent,
                        onTap: () {
                          filter = NoticeFilter.urgent;
                          context.read<NoticeBloc>().add(
                            FilterNotices(filter: NoticeFilter.urgent),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: size.height * 0.01),
              // view notices
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final bloc = context.read<NoticeBloc>();
                    bloc.add(RefreshNotices(currentFilter: filter));

                    await bloc.stream.firstWhere(
                      (state) => state is NoticeLoaded || state is NoticeError,
                    );
                  },

                  child: BlocBuilder<NoticeBloc, NoticeState>(
                    builder: (context, state) {
                      if (state is NoticeLoading && state.firstLoad) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 300),
                            Center(child: CircularProgressIndicator()),
                          ],
                        );
                      }

                      if (state is NoticeLoading) {
                        final notices = state.notices;

                        return NoticeList(
                          notices: notices,
                          scrollController: _scrollController,
                        );

                        // return ListView.builder(
                        //   controller: _scrollController,
                        //   physics: AlwaysScrollableScrollPhysics(),
                        //   itemCount: notices.length + 1,
                        //   itemBuilder: (_, index) {
                        //     if (index == notices.length) {
                        //       return const Padding(
                        //         padding: EdgeInsets.all(16),
                        //         child: Center(
                        //           child: CircularProgressIndicator(
                        //             color: Color(0xFF2AB3AA),
                        //           ),
                        //         ),
                        //       );
                        //     }
                        //     return CustomWidgets.noticeCard(notices[index]);
                        //   },
                        // );
                      }

                      if (state is NoticeLoaded) {
                        final notices = state.displayNotices;
                        if (notices.isEmpty) {
                          return Center(
                            child: const Text(
                              'No notices available',
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        }

                        return NoticeList(
                          notices: notices,
                          scrollController: _scrollController,
                          showBottomLoader: state.isLoadingMore,
                        );

                        // return ListView.builder(
                        //   controller: _scrollController,
                        //   physics: AlwaysScrollableScrollPhysics(),
                        //   itemCount:
                        //       notices.length + (state.isLoadingMore ? 1 : 0),
                        //   itemBuilder: (_, index) {
                        //     if (index == notices.length) {
                        //       return const Padding(
                        //         padding: EdgeInsets.all(16),
                        //         child: Center(
                        //           child: CircularProgressIndicator(
                        //             color: Color(0xFF2AB3AA),
                        //           ),
                        //         ),
                        //       );
                        //     }
                        //     return CustomWidgets.noticeCard(notices[index]);
                        //   },
                        // );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),

              // BlocBuilder<NoticeBloc, NoticeState>(
              //   buildWhen: (previous, current) => current is NoticeLoaded,
              //   builder: (context, state) {
              //     final currentFilter = (state is NoticeLoaded)
              //         ? state.filter
              //         : filter;

              //     return Row(
              //       children: [
              //         CustomWidgets.noticeFilterButton(
              //           label: 'All',
              //           isSelected: currentFilter == NoticeFilter.all,
              //           onTap: () {
              //             filter = NoticeFilter.all;
              //             context.read<NoticeBloc>().add(
              //               FilterNotices(filter: NoticeFilter.all),
              //             );
              //           },
              //         ),
              //         const SizedBox(width: 5),
              //         CustomWidgets.noticeFilterButton(
              //           label: 'Important',
              //           isSelected: currentFilter == NoticeFilter.important,
              //           onTap: () {
              //             filter = NoticeFilter.important;
              //             context.read<NoticeBloc>().add(
              //               FilterNotices(filter: NoticeFilter.important),
              //             );
              //           },
              //         ),
              //         const SizedBox(width: 5),
              //         CustomWidgets.noticeFilterButton(
              //           label: 'Urgent',
              //           isSelected: currentFilter == NoticeFilter.urgent,
              //           onTap: () {
              //             filter = NoticeFilter.urgent;
              //             context.read<NoticeBloc>().add(
              //               FilterNotices(filter: NoticeFilter.urgent),
              //             );
              //           },
              //         ),
              //       ],
              //     );
              //   },
              // ),

              // SizedBox(height: size.height * 0.01),

              // // show notices
              // Expanded(
              //   child: BlocBuilder<NoticeBloc, NoticeState>(
              //     builder: (context, state) {
              //       if (state is NoticeLoading && state.firstLoad) {
              //         return const Center(
              //           child: CircularProgressIndicator(
              //             color: Color(0xFF2AB3AA),
              //           ),
              //         );
              //       }

              //       if (state is NoticeLoading) {
              //         return NoticeList(
              //           notices: state.notices,
              //           showBottomLoader: true,
              //         );
              //       }

              //       if (state is NoticeLoaded) {
              //         final notices = state.displayNotices;
              //         if (notices.isEmpty) {
              //           return Center(
              //             child: const Text(
              //               'No notices available',
              //               style: TextStyle(fontSize: 18),
              //             ),
              //           );
              //         }

              //         return RefreshIndicator(
              //           onRefresh: () async {
              //             final bloc = context.read<NoticeBloc>();
              //             bloc.add(RefreshNotices(currentFilter: filter));

              //             await bloc.stream.firstWhere(
              //               (state) =>
              //                   state is NoticeLoaded || state is NoticeError,
              //             );
              //           },
              //           child: NoticeList(
              //             notices: notices,
              //             showBottomLoader: state.isLoadingMore,
              //           ),
              //         );

              //         // return ListView.builder(
              //         //   itemCount:
              //         //       notices.length + (state.isLoadingMore ? 1 : 0),
              //         //   itemBuilder: (context, index) {
              //         //     if (index == notices.length) {
              //         //       return const Padding(
              //         //         padding: EdgeInsets.symmetric(vertical: 16),
              //         //         child: Center(child: CircularProgressIndicator()),
              //         //       );
              //         //     }
              //         //     return CustomWidgets.noticeCard(notices[index]);
              //         //   },
              //         // );
              //       }

              //       return const SizedBox.shrink();
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
