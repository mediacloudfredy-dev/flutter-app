import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String toReadable() => DateFormat('dd MMM yyyy, HH:mm').format(this);
}
