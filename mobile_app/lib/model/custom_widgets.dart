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
                    // color: Color(0xFF2AB3AA),
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: <Color>[Color(0xFF3B8D9B), Color(0xFF00FFB7)],
                      begin: .topLeft,
                      end: .bottomRight,
                    ),
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
            formatTime(notice.publishedAt),
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }

  // format time for homescreen notice card
  static String formatTime(DateTime publishedAt) {
    final now = DateTime.now();
    final date = DateTime(publishedAt.year, publishedAt.month, publishedAt.day);
    final today = DateTime(now.year, now.month, now.day);
    final difference = today.difference(date).inDays;

    if (difference == 0) {
      return 'Today, ${DateFormat('hh:mm a').format(date)}';
    }

    if (difference == 1) {
      return 'Yesterday, ${DateFormat('hh:mm a').format(date)}';
    }

    if (difference <= 7) {
      return DateFormat('EEEE, hh:mm a').format(date);
    }

    return DateFormat('dd MMM, hh:mm a').format(date);
  }
}
