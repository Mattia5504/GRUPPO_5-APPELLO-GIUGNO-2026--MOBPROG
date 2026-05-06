import 'package:intl/intl.dart';

class AppDateUtils {
  const AppDateUtils._();

  static final DateFormat _dayMonthFormatter = DateFormat('dd/MM');
  static final DateFormat _fullFormatter = DateFormat('dd/MM/yyyy');

  static String formatDayMonth(DateTime date) =>
      _dayMonthFormatter.format(date);

  static String formatFull(DateTime date) => _fullFormatter.format(date);

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime startOfWeek(DateTime date) {
    final normalized = startOfDay(date);
    return normalized.subtract(Duration(days: normalized.weekday - 1));
  }

  static DateTime endOfWeek(DateTime date) {
    return startOfWeek(date).add(const Duration(days: 6));
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
