import 'package:intl/intl.dart';

String formatLocalTime(DateTime createdAt) {
  return DateFormat("MMMM d, yyyy · HH:mm").format(createdAt.toLocal());
}
