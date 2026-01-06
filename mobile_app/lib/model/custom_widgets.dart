import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/model/assignment.dart';
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
    if (notice.priority == NoticePriority.urgent) {
      cardColor = Colors.red;
    } else if (notice.priority == NoticePriority.important) {
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
  static Widget noticeFilterButton(
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

    if (notice.priority == NoticePriority.urgent) {
      cardColor = Colors.red;
      priority = 'Urgent';
    } else if (notice.priority == NoticePriority.important) {
      cardColor = Colors.yellow.shade700;
      priority = 'Important';
    }

    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
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
                'Posted ${formatIssuedTime(notice.publishedAt)}',
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
  static String formatIssuedTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

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

    if (time.year < now.year) {
      return 'on ${DateFormat('dd MMM y').format(time)}';
    }

    return 'on ${DateFormat('dd MMM').format(time)}';
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

  // assignment filter button
  static Widget assignmentFilterButton(
    String label,
    AssignmentFilter filter,
    AssignmentFilter currentFilter,
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

  // assignment cards
  static Widget assignmentCards(Assignment assignment) {
    Color cardColor = Colors.blue;
    String priority = 'Normal';

    if (assignment.priority == AssignmentPriority.urgent) {
      cardColor = Colors.red;
      priority = 'Urgent';
    } else if (assignment.priority == AssignmentPriority.medium) {
      cardColor = Colors.yellow.shade700;
      priority = 'Medium';
    }

    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
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
                  // assignment title
                  Flexible(
                    child: Text(
                      assignment.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: .visible,
                    ),
                  ),

                  const SizedBox(width: 5),

                  // display priority
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
              // posted date
              Text(
                'Issued ${formatIssuedTime(assignment.issuedAt)}',
                style: TextStyle(color: Colors.black45),
              ),

              // description of the assignment
              Text(
                assignment.description,
                style: TextStyle(fontSize: 17, color: Colors.black54),
              ),

              const SizedBox(height: 10),
              // due time
              Row(
                children: [
                  Icon(Icons.timer, size: 20, color: Colors.black45),
                  const SizedBox(width: 5),
                  Text(
                    'Due: ${formatDueTime(assignment.dueDate)}',
                    style: TextStyle(color: Colors.black45),
                  ),
                ],
              ),

              // time passed since issued indicator
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: getPercentage(assignment.issuedAt, assignment.dueDate),
                color: Color(0xFF2AB3AA),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // format time for assignment cards
  static String formatDueTime(DateTime time) {
    final now = DateTime.now();
    final diff = time.difference(now);

    if (diff.isNegative) {
      return '${DateFormat('dd MMM y').format(time)} (Passed)';
    }

    if (diff.inHours < 24) {
      return 'Today, ${DateFormat('hh:mm a').format(time)}';
    }

    if (diff.inDays < 2) {
      return 'Tomorrow, ${DateFormat('hh:mm a').format(time)}';
    }

    if (diff.inDays < 7) return DateFormat('EEE, hh:mm a').format(time);
    if (diff.inDays < 30) return '${diff.inDays} days remaining';

    return DateFormat('hh:mm a, dd MMM').format(time);
  }

  // get due date and time completion percentage
  static double getPercentage(DateTime issued, DateTime due) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final i = issued.millisecondsSinceEpoch;
    final d = due.millisecondsSinceEpoch;

    if (d <= i) return 100; // zero or invalid time range
    if (d <= now) return 100; // if due date is passed
    if (now < i) return 0; // if hasn't started yet

    return ((now - i) / (d - i));
  }
}
