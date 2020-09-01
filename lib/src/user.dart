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

  String get id => _attribute['id'].toString();
  String get username => _attribute['_username'];
  String get avatar => _attribute['avatar'];
  String get email => _attribute['_email'];
  String get phone => _attribute['_phone'];
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

  /// 以 Map 的形式返回用户信息
  Map<String, dynamic> toJSON() {
    return Map<String, dynamic>.from(this._attribute);
  }

  /// 获取单个用户
  /// [usrId] 用户 ID
  /// [expand] 需要展开的字段
  /// [select] 返回指定的字段
  static Future<User> getUser(String userId, {List<String> expand, List<String> select}) async {
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

  /// 获取用户列表
  /// [query] 筛选条件 Query 对象
  static Future<UserList> find({Query query}) async {
    Map<String, dynamic> data = query?.get();

    Response res = await config.request(
      path: Api.userList,
      method: 'GET',
      data: data,
    );

    return UserList(res.data);
  }

  /// 获取用户数量
  static Future<int> count() async {
    Query query = Query();
    query.limit(1);
    query.withTotalCount(true);
    Response res = config.request(
      path: Api.userList,
      method: 'GET',
      data: query.get(),
    );

    return res.data['meta']['total_count'];
  }
}

