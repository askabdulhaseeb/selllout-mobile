import '../database/auth_methods.dart';
import 'time_date_functions.dart';

class UniqueIdFunctions {
  static String get postID =>
      '${AuthMethods.uid}${TimeDateFunctions.timestamp}';

  static String personalChatID({required String chatWith}) {
    int isGreaterThen = AuthMethods.uid.compareTo(chatWith);
    if (isGreaterThen > 0) {
      return '${AuthMethods.uid}-chats-$chatWith';
    } else {
      return '$chatWith-chats-${AuthMethods.uid}';
    }
  }

  static String chatGroupID() {
    return '${AuthMethods.uid}-group-${TimeDateFunctions.timestamp}';
  }

  static String productID(String pid) {
    return '${AuthMethods.uid}$pid';
  }
}
