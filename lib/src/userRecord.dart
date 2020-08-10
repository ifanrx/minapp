import 'currentUser.dart';

class UserRecord {
  static Future<CurrentUser> initCurrentUser(Map<String, dynamic> userInfo) async {
    CurrentUser currentUser = CurrentUser(userInfo);
    return currentUser;
  }
}