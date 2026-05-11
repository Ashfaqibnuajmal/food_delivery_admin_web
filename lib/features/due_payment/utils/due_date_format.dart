import 'package:intl/intl.dart';

class DueDateFormatter {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }
}
