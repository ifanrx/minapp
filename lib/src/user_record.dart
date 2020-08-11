import 'current_user.dart';

class UserRecord {
  static Future<CurrentUser> initCurrentUser(Map<String, dynamic> userInfo) async {
    CurrentUser currentUser = CurrentUser(userInfo);
    return currentUser;
  }
}