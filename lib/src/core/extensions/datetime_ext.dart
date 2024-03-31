import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  /// Return a string of the date in the format 'EEE, MMM d'
  ///
  /// Example: 'Sun, Mar 14'
  ///
  /// See also: [DateFormat]
  String get formattedMMMEd => DateFormat.MMMEd().format(this);
}
