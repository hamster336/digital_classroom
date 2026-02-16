import 'package:flutter/material.dart';
import 'package:mobile_app/notices/models/notice.dart';
import 'package:mobile_app/shared/custom_widgets.dart';

class NoticeList extends StatelessWidget {
  final List<Notice> notices;
  final ScrollController scrollController;
  final bool showBottomLoader;

  const NoticeList({
    super.key,
    required this.notices,
    required this.scrollController,
    this.showBottomLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: notices.length + (showBottomLoader ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == notices.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: CustomWidgets.customLoader(),
          );
        }
        return CustomWidgets.noticeCard(notices[index]);
      },
    );
  }
}
