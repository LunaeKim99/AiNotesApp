import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

String formatDate(DateTime date) {
  return DateFormat('MMM d, yyyy').format(date);
}

String formatDateFull(DateTime date) {
  return DateFormat('EEEE, MMMM d, yyyy – h:mm a').format(date);
}

String generateId() {
  return _uuid.v4();
}

String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength)}...';
}
