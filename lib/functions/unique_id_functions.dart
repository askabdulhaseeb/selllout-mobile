import '../database/auth_methods.dart';
import 'time_date_functions.dart';

class UniqueIdFunctions {
  static String get postID =>
      '${AuthMethods.uid}${TimeDateFunctions.timestamp}';
}
