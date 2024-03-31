import 'package:diacritic/diacritic.dart';

extension StringExt on String {
  String get undiacritic {
    return removeDiacritics(this);
  }

  String get toTitleCase {
    return split(' ').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }
}
