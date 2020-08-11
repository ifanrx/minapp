import 'package:dio/dio.dart';

import 'query.dart';
import 'request.dart';
import 'current_user.dart';
import 'constants.dart';

class User extends CurrentUser {
  User(Map<String, dynamic> userInfo) : super(userInfo);

  static Future<User> user(String userId,
      {List<String> expand, List<String> select}) async {
    Map<String, dynamic> data = {};

    if (expand != null && expand.length > 0) {
      data.addAll({'expand': expand.join(',')});
    }

    if (select != null && select.length > 0) {
      data.addAll({'keys': select.join(',')});
    }

    Response res = await request(
      path: Api.userDetail,
      method: 'GET',
      params: {'userID': userId},
      data: data,
    );
    return User(res.data);
  }

  static Future<dynamic> find({Query query}) async {
    Response res = await request(
      path: Api.userList,
      method: 'GET',
      data: query?.get(),
    );
    List<dynamic> objects = res.data['objects'];
    var userList = List<User>();
    objects.forEach((user) {
      userList.add(User(user));
    });

    return userList;
  }
}
