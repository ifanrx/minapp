import 'package:dio/dio.dart';

import 'query.dart';
import 'constants.dart';
import 'user_list.dart';
import 'h_error.dart';
import 'config.dart';

part "current_user.dart";

class User {
  Map<String, dynamic> _attribute;
  bool _anonymous;

  User(Map<String, dynamic> userInfo) {
    this._attribute = userInfo;
    this._anonymous = _attribute['_anonymous'];
  }

  String get userId => _attribute['id'].toString();
  String get username => _attribute['_username'];
  String get avatar => _attribute['avatar'];
  String get email => _attribute['_email'];
  String get city => _attribute['city'];
  String get country => _attribute['country'];
  String get language => _attribute['language'];
  String get nickname => _attribute['nickname'];
  String get openid => _attribute['openid'];
  String get province => _attribute['province'];
  int get gender => _attribute['gender'];
  bool get emailVerified => _attribute['_email_verified'];
  bool get isAnonymous => _anonymous;

  get(String key) {
    return _attribute[key];
  }

  Map toJson() {
    return _attribute;
  }

  static Future<User> user(String userId, {List<String> expand, List<String> select}) async {
    Map<String, dynamic> data = {};

    if (expand != null && expand.length > 0) {
      data.addAll({'expand': expand.join(',')});
    }

    if (select != null && select.length > 0) {
      data.addAll({'keys': select.join(',')});
    }

    Response res = await config.request(
      path: Api.userDetail,
      method: 'GET',
      params: {'userID': userId},
      data: data,
    );
    return User(res.data);
  }

  static Future<UserList> find({Query query}) async {
    Map<String, dynamic> data = query?.get();

    Response res = await config.request(
      path: Api.userList,
      method: 'GET',
      data: data,
    );

    return UserList(res.data);
  }
}

