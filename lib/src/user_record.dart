import 'current_user.dart';

import './user.dart';

class UserList {
  int _limit;
  int _offset;
  int _totalCount;
  String _next;
  String _previous;
  List _users;

  int get limit => _limit;
  int get offset => _offset;
  int get totalCount => _totalCount;
  String get next => _next;
  String get previous => _previous;
  List get users => _users;

  UserList(Map<String, dynamic> recordInfo) {
    Map<String, dynamic> meta = recordInfo['meta'];
    _limit = meta == null ? recordInfo['limit'] : meta['limit'];
    _offset = meta == null ? recordInfo['offset'] : meta['offset'];
    _totalCount =
    meta == null ? recordInfo['total_count'] : meta['total_count'];
    _next = meta == null ? recordInfo['next'] : meta['next'];
    _previous = meta == null ? recordInfo['previous'] : meta['previous'];
    _users =
    meta == null ? recordInfo['operation_result'] : initUsers(recordInfo['objects']);
  }

  List<User> initUsers(List users) {
    var userList = List<User>();
    users.forEach((user) {
      userList.add(User(user));
    });

    return userList;
  }
}