import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DateSeparator extends StatelessWidget {
  final DateTime date;

  DateSeparator(this.date);

  @override
  Widget build(BuildContext context) {
    // Get the current local date and time
    DateTime now = DateTime.now();

    // Format the incoming message date
    String formattedDate = _formatDate(now, date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment(0.5, -1), 
                end: Alignment(0.5, 1),
                colors: [
                  Color(0xFF8F85F3),
                  Color(0xFF7468F0),
                ],
                stops: [0.1037, 0.9146],
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              formattedDate,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to format the date
  String _formatDate(DateTime now, DateTime messageDate) {
    DateTime yesterday = now.subtract(const Duration(days: 1));
    DateTime oneWeekAgo = now.subtract(const Duration(days: 7));

    if (isSameDate(messageDate, now)) {
      return 'Today';
    } else if (isSameDate(messageDate, yesterday)) {
      return 'Yesterday';
    } else if (messageDate.isAfter(oneWeekAgo)) {
      // If the date is within the past week, return the day name
      return DateFormat('EEEE').format(messageDate); 
    } else {
      // For dates older than a week, return the full date format
      return DateFormat('dd MMM yyyy').format(messageDate);
    }
  }

  // Utility to compare if two dates are the same
  static bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
