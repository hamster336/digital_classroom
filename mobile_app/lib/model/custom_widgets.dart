import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/model/notice.dart';
import 'package:mobile_app/model/required_enums.dart';

class CustomWidgets {
  // custom textFields
  static Widget customTextField({
    required TextEditingController controller,
    required String label,
    IconData? suffixIcon,
    required bool obscureText,
  }) {
    return TextField(
      decoration: InputDecoration(
        label: Text(label, style: TextStyle(fontSize: 20)),
        suffixIcon: (suffixIcon == null)
            ? null
            : Icon(
                suffixIcon,
                size: 30,
                // color: Color.fromARGB(100, 59, 141, 155),
              ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      obscureText: obscureText,
    );
  }

  // general info card for homescreen
  static Widget infoCard(Size size, int count, String info) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: ListTile(
        contentPadding: .zero,
        title: Center(
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2AB3AA),
            ),
          ),
        ),
        subtitle: Center(
          child: Text(
            info,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      ),
    );
  }

  // resources card for homescreen (notes, assginments and schedules)
  static Widget resrcCard(
    Size size,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: size.width * 0.45,
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 2,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),

                  decoration: BoxDecoration(
                    color: Color(0xFF2AB3AA),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 27, color: Colors.white),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 16, color: Colors.black45),
                  maxLines: null,
                  overflow: .visible,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Notice card
  static Widget homeScrenNoticeCard(Notice notice) {
    Color cardColor = Colors.blue;
    if (notice.priority == InfoPriority.urgent) {
      cardColor = Colors.red;
    } else if (notice.priority == InfoPriority.important) {
      cardColor = Colors.yellow.shade700;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: cardColor,
      ),
      child: Card(
        margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        color: Colors.white,
        child: ListTile(
          title: Text(notice.title, style: TextStyle(fontSize: 20)),
          subtitle: Text(
            formatTimeForHome(notice.publishedAt),
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }

  // format time for homescreen notice card
  static String formatTimeForHome(DateTime publishedAt) {
    final now = DateTime.now();
    final difference = now.difference(publishedAt).inDays;

    if (difference == 0) {
      return 'Today, ${DateFormat('hh:mm a').format(publishedAt)}';
    }

    if (difference == 1) {
      return 'Yesterday, ${DateFormat('hh:mm a').format(publishedAt)}';
    }

    if (difference <= 7) {
      return DateFormat('EEEE, hh:mm a').format(publishedAt);
    }

    return DateFormat('dd MMM, hh:mm a').format(publishedAt);
  }

  // filter buttons
  static Widget filterButton(
    String label,
    NoticeFilter filter,
    NoticeFilter currentFilter,
  ) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: (filter == currentFilter) ? Color(0xFF2AB3AA) : null,
        shadowColor: Colors.transparent,
        elevation: 6,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: (filter == currentFilter) ? Colors.white : null,
        ),
      ),
    );
  }

  // notice card for notice screen
  static Widget noticeCard(Notice notice) {
    Color cardColor = Colors.blue;
    String priority = 'Info';

    if (notice.priority == InfoPriority.urgent) {
      cardColor = Colors.red;
      priority = 'Urgent';
    } else if (notice.priority == InfoPriority.important) {
      cardColor = Colors.yellow.shade700;
      priority = 'Important';
    }

    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: cardColor,
      ),
      child: Card(
        margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      notice.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: .visible,
                    ),
                  ),

                  const SizedBox(width: 5),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: cardColor.withValues(alpha: 0.2),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(priority, style: TextStyle(color: cardColor)),
                  ),
                ],
              ),

              const SizedBox(height: 5),
              Text(
                'Posted ${formatTime(notice.publishedAt)}',
                style: TextStyle(color: Colors.black45),
              ),

              Text(
                notice.description,
                style: TextStyle(fontSize: 17, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // format time for notice cards
  static String formatTime(DateTime publishedAt) {
    final now = DateTime.now();
    final diff = now.difference(publishedAt);

    // if (diff.isNegative) {
    //   return 'on ${DateFormat('dd MMM y').format(publishedAt)}';
    // }

    if (diff.inSeconds < 60) return 'now';

    if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return '$m minute${m == 1 ? '' : 's'} ago';
    }

    if (diff.inHours < 24) {
      final h = diff.inHours;
      return '$h hour${h == 1 ? '' : 's'} ago';
    }

    if (diff.inDays < 30) {
      final d = diff.inDays;
      return '$d day${d == 1 ? '' : 's'} ago';
    }

    if (publishedAt.year < now.year) {
      return 'on ${DateFormat('dd MMM y').format(publishedAt)}';
    }

    return 'on ${DateFormat('dd MMM').format(publishedAt)}';
  }

  // settings with toggles
  static Widget toggleSetting(
    String label,
    bool toggle,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 20)),

        Switch(
          value: toggle,
          onChanged: onChanged,
          activeTrackColor: Color(0xFF2AB3AA),
        ),
      ],
    );
  }

  // settings with navigation
  static Widget navigateSettings(String label, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 20)),

        IconButton(onPressed: onTap, icon: Icon(Icons.chevron_right_rounded)),
      ],
    );
  }
}
