import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app_file/models/app_file.dart';
import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/assignments/view/teacher_view/teacher.assignment_details_screen.dart';
import 'package:mobile_app/classroom/model/classroom.dart';
import 'package:mobile_app/schedules/model/schedule.dart';
import 'package:mobile_app/subject/model/subject.dart';
import 'package:mobile_app/submission/model/class_students.dart';
import 'package:mobile_app/upcoming/model/upcoming.dart';
import 'package:mobile_app/notices/models/notice.dart';
import 'package:mobile_app/shared/required_enums.dart';

class CustomWidgets {
  // custom textFields
  static Widget customTextField({
    required TextEditingController controller,
    required String label,
    IconData? suffixIcon,
    required bool obscureText,
    bool enabled = true,
    int? maxLines = 1,
    TextCapitalization cap = .none,
    FocusNode? focusNode,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: (suffixIcon == null) ? null : Icon(suffixIcon, size: 30),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      textCapitalization: cap,
      obscureText: obscureText,
    );
  }

  // general info card for homescreen
  static Widget infoCard(Size size, String count, String info) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: ListTile(
        contentPadding: .zero,
        title: Center(
          child: Text(
            count,
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

  // home screen events card
  static Widget homeScreenCard(Upcoming event) {
    Color cardColor = Colors.blue;
    if (event.priority == UpcomingEventPriority.urgent) {
      cardColor = Colors.red;
    } else if (event.priority == UpcomingEventPriority.medium) {
      cardColor = Colors.yellow.shade700;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: cardColor,
      ),
      child: Card(
        margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        color: Colors.white,
        elevation: 2,
        child: ListTile(
          title: Text(event.title, style: TextStyle(fontSize: 18)),
          subtitle: Text(
            formatTimeForHome(event.eventAt),
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }

  // format time for homescreen notice card
  static String formatTimeForHome(DateTime scheduledAt) {
    final now = DateTime.now();
    final scheduled = scheduledAt.toLocal();

    final diff = now.difference(scheduledAt);

    if (diff.inDays == 0) {
      return 'Today, ${DateFormat('hh:mm a').format(scheduled)}';
    }

    if (diff.inDays == 1) {
      return 'Tomorrow, ${DateFormat('hh:mm a').format(scheduled)}';
    }

    if (diff.inDays < 7) {
      return DateFormat('EEEE, hh:mm a').format(scheduled);
    }

    return DateFormat('dd MMM, hh:mm a').format(scheduled);
  }

  // filter buttons
  static Widget noticeFilterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Color(0xFF2AB3AA) : null,
        shadowColor: Colors.transparent,
        elevation: 6,
      ),
      child: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : null),
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
    final localTime = time.toLocal();
    final diff = now.difference(localTime);

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

    if (localTime.year < now.year) {
      return 'on ${DateFormat('dd MMM y').format(localTime)}';
    }

    return 'on ${DateFormat('dd MMM').format(localTime)}';
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
  static Widget assignmentFilterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Color(0xFF2AB3AA) : null,
        shadowColor: Colors.transparent,
        elevation: 6,
      ),
      child: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : null),
      ),
    );
  }

  // assignment cards
  static Widget studentAssignmentCards({
    required BuildContext context,
    required Assignment assignment,
    required String subjectName,
    required VoidCallback onTap,
    bool detailed = false,
  }) {
    Color cardColor = Colors.blue;
    String priority = 'Normal';

    if (assignment.priority == AssignmentPriority.urgent) {
      cardColor = Colors.red;
      priority = 'Urgent';
    } else if (assignment.priority == AssignmentPriority.medium) {
      cardColor = Colors.yellow.shade700;
      priority = 'Medium';
    }

    final percentage = getPercentage(assignment.issuedAt, assignment.dueDate);

    return InkWell(
      onTap: (detailed) ? () {} : onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: cardColor,
        ),
        child: Card(
          margin: const EdgeInsets.only(left: 5),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                // subject name
                Text(
                  subjectName,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF2AB3AA),
                    fontWeight: FontWeight.w600,
                  ),
                ),

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

                // issue date
                if (detailed)
                  Text(
                    'Issued: ${formatIssuedTime(assignment.issuedAt)}',
                    style: TextStyle(color: Colors.black45),
                  ),

                if (detailed) const SizedBox(height: 10),

                // description of the assignment
                Text(
                  assignment.description,
                  style: TextStyle(fontSize: 17, color: Colors.black54),
                ),

                const SizedBox(height: 10),

                // due time
                if (detailed)
                  Row(
                    children: [
                      Icon(Icons.timer, size: 20, color: Colors.black45),
                      const SizedBox(width: 5),

                      Text(
                        'Due: ${formatDueTime(assignment.dueDate)}',
                        style: TextStyle(color: Colors.black45),
                      ),

                      Spacer(),

                      // show how much time has passed in percentage
                      Text(
                        '${(percentage * 100).toInt()}%',
                        style: TextStyle(color: Colors.black45),
                      ),
                    ],
                  ),

                // time passed since issued indicator
                if (detailed) const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: percentage,
                  color: Color(0xFF2AB3AA),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // format time for assignment cards
  static String formatDueTime(DateTime time) {
    final now = DateTime.now();
    final dueLocal = time.toLocal();

    final diff = dueLocal.difference(now);

    if (diff.isNegative) {
      return '${DateFormat('dd MMM y').format(dueLocal)} (Passed)';
    }

    if (diff.inDays == 0) {
      return 'Today, ${DateFormat('hh:mm a').format(dueLocal)}';
    }

    if (diff.inDays == 1) {
      return 'Tomorrow, ${DateFormat('hh:mm a').format(dueLocal)}';
    }

    if (diff.inDays < 7) {
      return DateFormat('EEE, hh:mm a').format(dueLocal);
    }

    if (diff.inDays < 30) {
      return '${diff.inDays} days remaining';
    }

    return DateFormat('hh:mm a, dd MMM').format(dueLocal);
  }

  // get due date and time completion percentage
  static double getPercentage(DateTime issued, DateTime due) {
    final now = DateTime.now().toUtc();

    if (now.isAfter(due)) return 1; //

    final totalDuration = due.difference(issued).inSeconds;

    if (totalDuration <= 0) return 0; // zero or invalid time range

    final elapsed = now.difference(issued).inSeconds;

    final percentage = elapsed / totalDuration;

    return percentage.clamp(0.0, 1.0);
  }

  // assignment subission details for student
  static Widget submissionDetailsForStudent(
    Assignment assignment,
    AppFile? sub, {
    int count = 0,
  }) {
    Color cardColor = Colors.blue;

    if (assignment.priority == AssignmentPriority.urgent) {
      cardColor = Colors.red;
    } else if (assignment.priority == AssignmentPriority.medium) {
      cardColor = Colors.yellow.shade700;
    }

    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: cardColor,
      ),
      child: Card(
        margin: const EdgeInsets.only(left: 5),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: (sub == null)
              ? Center(
                  child: const Text(
                    "No submissions found",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                )
              : Row(
                  mainAxisAlignment: .spaceEvenly,
                  crossAxisAlignment: .start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .center,
                        children: [
                          Text(
                            'Last Submission date:\n${DateFormat('hh:mm a, dd MMM y').format(sub.createdAt)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                            textAlign: .center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'File name:\n${sub.fileName}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                            textAlign: .center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Grade:\n${(sub.score == null) ? 'Not graded yet' : '${sub.score} / 10'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                            textAlign: .center,
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: .center,
                        mainAxisSize: .min,
                        children: [
                          Text(
                            'No of submissions:\n${DateFormat('$count').format(sub.createdAt)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                            textAlign: .center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'File size:\n${formatSize(sub.fileSize)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                            textAlign: .center,
                          ),

                          const SizedBox(height: 10),
                          Text(
                            'Remarks:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            '${(sub.remarks != null) ? sub.remarks : 'No remakrs'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  //assignment submission details for teacher
  static Widget submissionDetailsForTeacher(
    Assignment assignment, {
    int count = 0,
    int total = 0,
  }) {
    Color cardColor = Colors.blue;

    if (assignment.priority == AssignmentPriority.urgent) {
      cardColor = Colors.red;
    } else if (assignment.priority == AssignmentPriority.medium) {
      cardColor = Colors.yellow.shade700;
    }

    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: cardColor,
      ),
      child: Card(
        margin: const EdgeInsets.only(left: 5),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Column(
                children: [
                  const Text(
                    'No of submissions:',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),

                  Text(
                    '$count / $total',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'Submission rate:',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),

                  Text(
                    (total == 0)
                        ? '0 %'
                        : '${((count / total) * 100).toInt()}%',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // class cards for teacher to select a class
  static Widget classCards(Classroom classroom, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Color(0xFF2AB3AA),
      ),
      child: InkWell(
        onTap: onTap,
        child: Card(
          margin: const EdgeInsets.only(left: 5),
          color: Colors.white,
          elevation: 3,
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF2AB3AA),
              ),
              child: Icon(Icons.groups, color: Colors.white, size: 25),
            ),
            title: Text(
              (classroom.faculty != null)
                  ? '${classroom.name} | ${classroom.faculty}'
                  : classroom.name,
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              '${classroom.studentCount} students',
              style: TextStyle(color: Colors.black54, fontSize: 17),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }

  // assignment cards for teacher
  static Widget teachersAssignmentCards({
    required BuildContext context,
    required Assignment assignment,
    required Subject subject,
    required Classroom cls,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    bool detailed = false,
  }) {
    Color cardColor = Colors.blue;
    String priority = 'Normal';

    if (assignment.priority == AssignmentPriority.urgent) {
      cardColor = Colors.red;
      priority = 'Urgent';
    } else if (assignment.priority == AssignmentPriority.medium) {
      cardColor = Colors.yellow.shade700;
      priority = 'Medium';
    }

    final percentage = getPercentage(assignment.issuedAt, assignment.dueDate);

    return InkWell(
      onTap: (detailed)
          ? () {}
          : () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TeacherAssignmentDetailScreen(
                  assignment: assignment,
                  cls: cls,
                  sub: subject,
                ),
              ),
            ),
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: cardColor,
        ),
        child: Card(
          margin: const EdgeInsets.only(left: 5),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                // subject name
                Text(
                  subject.name,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF2AB3AA),
                    fontWeight: FontWeight.w600,
                  ),
                ),

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

                    // Update/delete buttons or priority
                    (!detailed)
                        ? Row(
                            children: [
                              IconButton(
                                padding: .zero,
                                onPressed: onEdit,
                                icon: const Icon(
                                  Icons.edit,
                                  opticalSize: 20,
                                  color: Color(0xFF2AB3AA),
                                ),
                              ),
                              IconButton(
                                onPressed: onDelete,
                                padding: .zero,
                                icon: const Icon(
                                  Icons.delete,
                                  opticalSize: 20,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: cardColor.withValues(alpha: 0.2),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              priority,
                              style: TextStyle(color: cardColor),
                            ),
                          ),
                  ],
                ),

                // issue date
                if (detailed)
                  Text(
                    'Issued: ${formatIssuedTime(assignment.issuedAt)}',
                    style: TextStyle(color: Colors.black45),
                  ),

                if (detailed) const SizedBox(height: 10),

                // description of the assignment
                Text(
                  assignment.description,
                  style: TextStyle(fontSize: 17, color: Colors.black54),
                ),

                const SizedBox(height: 10),

                // due time
                if (detailed)
                  Row(
                    children: [
                      Icon(Icons.timer, size: 20, color: Colors.black45),
                      const SizedBox(width: 5),

                      Text(
                        'Due: ${formatDueTime(assignment.dueDate)}',
                        style: TextStyle(color: Colors.black45),
                      ),

                      Spacer(),

                      // show how much time has passed in percentage
                      Text(
                        '${(percentage * 100).toInt()}%',
                        style: TextStyle(color: Colors.black45),
                      ),
                    ],
                  ),

                // time passed since issued indicator
                if (detailed) const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: percentage,
                  color: Color(0xFF2AB3AA),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // class details widget
  static Widget showClassDetails(BuildContext context, Classroom cls) {
    return AlertDialog(
      title: Center(
        child: const Text(
          'Class Details',
          style: TextStyle(color: Colors.black54, fontSize: 20),
        ),
      ),
      content: Column(
        mainAxisSize: .min,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Column(
                mainAxisSize: .min,
                children: [
                  const Text('Name: ', style: TextStyle(fontSize: 18)),
                  Text(
                    cls.name,
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                ],
              ),

              Column(
                mainAxisSize: .min,
                children: [
                  const Text('Faculty: ', style: TextStyle(fontSize: 18)),
                  Text(
                    (cls.faculty != null) ? cls.faculty! : '-',
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Column(
                mainAxisSize: .min,
                children: [
                  const Text('Start Year: ', style: TextStyle(fontSize: 18)),
                  Text(
                    '${cls.startYear}',
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                ],
              ),

              Column(
                mainAxisSize: .min,
                children: [
                  const Text('End Year: ', style: TextStyle(fontSize: 18)),
                  Text(
                    '${cls.endYear}',
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Column(
                mainAxisSize: .min,
                children: [
                  const Text('Students: ', style: TextStyle(fontSize: 18)),
                  Text(
                    '${cls.studentCount}',
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                ],
              ),

              Column(
                mainAxisSize: .min,
                children: [
                  const Text('Created on: ', style: TextStyle(fontSize: 18)),
                  Text(
                    DateFormat('dd MMM, y').format(cls.createdAt),
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // user info tiles for profile screen
  static Widget userInfoTiles(String asset, String title, String subtitle) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.white,
        child: Image(image: AssetImage(asset)),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  // show Alert Dialog box with ok button only
  static void customAltertBox(
    BuildContext context,
    String text,
    VoidCallback onTap,
  ) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: Text(text, style: TextStyle(fontSize: 18)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onTap();
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  // custom buttons
  static Widget customButton(Size size, String text, VoidCallback onTap) {
    return Container(
      width: size.width * 0.65,
      height: size.height * 0.06,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFF3B8D9B), Color(0xFF00FFB7)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            shadows: [Shadow(color: Colors.black45, blurRadius: 2)],
            fontSize: 23,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // pop up menu item
  static PopupMenuItem<String> customMenuItem(String value, String text) {
    return PopupMenuItem(
      value: value,
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  // menu item picker
  static Widget customMenuItemPicker(
    TextEditingController controller,
    String label,
    Widget suffixIcon,
  ) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // notes cards for teacher
  static Widget teacherNotesCard({
    required AppFile note,
    required String subjectName,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Color(0xFF2AB3AA),
      ),

      child: Card(
        margin: const EdgeInsets.only(left: 5),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
          child: ListTile(
            contentPadding: .zero,
            title: Column(
              crossAxisAlignment: .start,
              children: [
                // subject Name
                Text(
                  subjectName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2AB3AA),
                  ),
                ),

                // file name
                Text(
                  note.fileName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            subtitle: Row(
              children: [
                Text(
                  formatSize(note.fileSize),
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(width: 10),
                Text(
                  '(${getFileLabel(note.mimeType)})',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(width: 10),
                Text(
                  DateFormat(
                    'hh:mm a, dd MMM',
                  ).format(note.createdAt.toLocal()),
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),

            trailing: InkWell(
              onTap: onDelete,
              child: Icon(Icons.delete_rounded, color: Colors.red),
            ),
          ),
          // Column(
          //   crossAxisAlignment: .start,
          //   children: [
          //     Text(
          //       subjectName,
          //       style: TextStyle(
          //         fontSize: 18,
          //         fontWeight: FontWeight.w600,
          //         color: Color(0xFF2AB3AA),
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(vertical: 5),
          //       child: Row(
          //         mainAxisAlignment: .start,
          //         children: [
          //           Text(
          //             note.fileName,
          //             style: TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.w600,
          //             ),
          //           ),
          //           Spacer(),
          //           InkWell(
          //             onTap: onDelete,
          //             child: Icon(Icons.delete_rounded, color: Colors.red),
          //           ),
          //           const SizedBox(width: 5),
          //         ],
          //       ),
          //     ),
          //     Row(
          //       children: [
          //         Text(
          //           formatSize(note.fileSize),
          //           style: TextStyle(color: Colors.black54),
          //         ),
          //         const SizedBox(width: 10),
          //         Text(
          //           '(${getFileLabel(note.mimeType)})',
          //           style: TextStyle(color: Colors.black54),
          //         ),
          //         const SizedBox(width: 10),
          //         Text(
          //           DateFormat('dd MMM').format(note.createdAt.toLocal()),
          //           style: TextStyle(color: Colors.black54),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }

  // notes cards for student
  static Widget studentNotesCard({
    required AppFile note,
    required String subjectName,
    required VoidCallback onDownload,
    required bool isDownloaded,
    required bool downlaoding,
    double? progress,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Color(0xFF2AB3AA),
      ),

      child: Card(
        margin: const EdgeInsets.only(left: 5),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
          child: ListTile(
            contentPadding: .zero,
            title: Column(
              crossAxisAlignment: .start,
              children: [
                // subject Name
                Text(
                  subjectName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2AB3AA),
                  ),
                ),

                // file name
                Text(
                  note.fileName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            // file information
            subtitle: Row(
              children: [
                Text(
                  formatSize(note.fileSize),
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(width: 10),
                Text(
                  '(${getFileLabel(note.mimeType)})',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(width: 10),
                Text(
                  DateFormat(
                    'hh:mm a, dd MMM',
                  ).format(note.createdAt.toLocal()),
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),

            // download button and download progress
            trailing: (downlaoding)
                ? CircularProgressIndicator(
                    color: Color(0xFF2AB3AA),
                    value: progress,
                  )
                : (isDownloaded)
                ? Icon(Icons.done, color: Colors.green, size: 30)
                : InkWell(
                    onTap: onDownload,
                    child: Icon(
                      Icons.file_download_outlined,
                      size: 30,
                      color: Colors.black54,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // format file type and labeling
  static String getFileLabel(String mimeType) {
    if (mimeType.startsWith('image/')) return 'img';

    if (mimeType.startsWith('video/')) return 'vid';

    if (mimeType.startsWith('audio/')) return 'aud';

    if (mimeType == 'application/pdf') return 'pdf';

    if (mimeType == 'application/msword' ||
        mimeType ==
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document') {
      return 'doc';
    }
    if (mimeType == 'application/vnd.ms-excel' ||
        mimeType ==
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') {
      return 'xls';
    }
    if (mimeType == 'application/vnd.ms-powerpoint' ||
        mimeType ==
            'application/vnd.openxmlformats-officedocument.presentationml.presentation') {
      return 'ppt';
    }
    if (mimeType == 'application/zip') return 'zip';

    return 'file';
  }

  // format file size
  static String formatSize(int bytes) {
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '$bytes B';
    }
  }

  // custom circular progress indicator
  static Widget customLoader() {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFF2AB3AA)),
    );
  }

  // a scrollable text widget
  static Widget customScrollableText(BuildContext context, String text) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 18, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // custom confirmation box
  static Widget customConformationBox({
    required BuildContext context,
    required String title,
    required String content,
    Color titleColor = Colors.red,
    required VoidCallback onConfirm,
  }) {
    return AlertDialog(
      title: Text(title, style: TextStyle(color: titleColor)),
      content: Text(content, style: TextStyle(fontSize: 18)),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('No'),
        ),

        ElevatedButton(
          onPressed: onConfirm,
          child: const Text('Yes', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  // student assignment submission Card
  static Widget studentSubmissionCard({
    required ClassStudents student,
    AppFile? submission,
    required VoidCallback onDownload,
    required bool isDownloaded,
    required bool downloading,
    double? progress,
    required VoidCallback onGrade,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: (submission != null) ? Color(0xFF2AB3AA) : Colors.red,
      ),

      child: Card(
        margin: const EdgeInsets.only(left: 5),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
          child: ListTile(
            contentPadding: .zero,
            title: Text(
              '${student.rollNumber}. ${student.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            subtitle: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  (submission == null) ? 'No data found' : submission.fileName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),

                (submission == null)
                    ? Text(
                        'No data found',
                        style: TextStyle(color: Colors.black54),
                      )
                    : Row(
                        children: [
                          Text(
                            formatSize(submission.fileSize),
                            style: TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '(${getFileLabel(submission.mimeType)})',
                            style: TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat(
                              'hh:mm a, dd MMM',
                            ).format(submission.createdAt.toLocal()),
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),

                if (submission != null)
                  ElevatedButton(
                    onPressed: onGrade,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      backgroundColor: Color(0xFF2AB3AA),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Grade', style: TextStyle(fontSize: 16)),
                  ),
              ],
            ),
            trailing: (submission == null)
                ? null
                : (downloading)
                ? CircularProgressIndicator(
                    color: Color(0xFF2AB3AA),
                    value: progress,
                  )
                : (isDownloaded)
                ? Icon(Icons.done, color: Colors.green, size: 30)
                : InkWell(
                    onTap: onDownload,
                    child: Icon(
                      Icons.file_download_outlined,
                      size: 30,
                      color: Colors.black54,
                    ),
                  ),
          ),
          // Column(
          //   crossAxisAlignment: .start,
          //   children: [
          //     Text(
          //       '${student.rollNumber}. ${student.name}',
          //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          //     ),
          //     Row(
          //       mainAxisAlignment: .start,
          //       children: [
          //         Text(
          //           (submission == null)
          //               ? 'No data found'
          //               : submission.fileName,
          //           style: TextStyle(
          //             fontSize: 18,
          //             fontWeight: FontWeight.w600,
          //             color: Colors.black54,
          //           ),
          //         ),
          //         Spacer(),
          //         if (submission != null)
          //           InkWell(
          //             onTap: onDownload,
          //             child: Icon(icon, size: 30, color: Colors.black54),
          //           ),
          //         const SizedBox(width: 5),
          //       ],
          //     ),
          //     (submission == null)
          //         ? Text(
          //             'No data found',
          //             style: TextStyle(color: Colors.black54),
          //           )
          //         : Row(
          //             children: [
          //               Text(
          //                 formatSize(submission.fileSize),
          //                 style: TextStyle(color: Colors.black54),
          //               ),
          //               const SizedBox(width: 10),
          //               Text(
          //                 '(${getFileLabel(submission.mimeType)})',
          //                 style: TextStyle(color: Colors.black54),
          //               ),
          //               const SizedBox(width: 10),
          //               Text(
          //                 DateFormat(
          //                   'hh:mm a, dd MMM',
          //                 ).format(submission.createdAt.toLocal()),
          //                 style: TextStyle(color: Colors.black54),
          //               ),
          //             ],
          //           ),
          //   ],
          // ),
        ),
      ),
    );
  }

  // schedule cards
  static Widget scheduleCard({
    required Schedule schedule,
    required VoidCallback onDownload,
    required bool isDownloaded,
    required bool downlaoding,
    double? progress,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Color(0xFF2AB3AA),
      ),

      child: Card(
        margin: const EdgeInsets.only(left: 5),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
          child: ListTile(
            contentPadding: .zero,
            title: Column(
              crossAxisAlignment: .start,
              children: [
                // file name
                Text(
                  schedule.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            // file information
            subtitle: Text(
              DateFormat(
                'hh:mm a, dd MMM',
              ).format(schedule.createdAt.toLocal()),
              style: TextStyle(color: Colors.black54),
            ),

            // download button and download progress
            trailing: (downlaoding)
                ? CircularProgressIndicator(
                    color: Color(0xFF2AB3AA),
                    value: progress,
                  )
                : (isDownloaded)
                ? Icon(Icons.done, color: Colors.green, size: 30)
                : InkWell(
                    onTap: onDownload,
                    child: Icon(
                      Icons.file_download_outlined,
                      size: 30,
                      color: Colors.black54,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
