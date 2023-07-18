import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return (DateFormat('yyyy/MM/dd').format(date));
}

String reformatDate(String date) {
  DateTime dt = DateFormat('yyyy/MM/dd').parse(date);
  return DateFormat.yMMMMd().format(dt);
} 