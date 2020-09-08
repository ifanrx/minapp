import './user.dart';
import 'table_record.dart';

class UserList extends RecordListMeta {
  List<User> _users;

  List<User> get users => _users;

  UserList(Map<String, dynamic> recordInfo) : super(recordInfo) {
    _users = _initUsers(recordInfo['objects']);
  }

  List<User> _initUsers(List users) {
    var userList = List<User>();
    users.forEach((user) {
      userList.add(User(user));
    });

    return userList;
  }
}
