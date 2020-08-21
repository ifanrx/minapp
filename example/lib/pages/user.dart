import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart' as BaaS;

import '../util.dart';
import 'common.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPage createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BaaS.UserList userList;

  @override
  void initState() {
    super.initState();
  }

  void onFetchUserList(BaaS.UserList users) {
    setState(() {
      userList = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('用户')),
        body: Padding(
          padding: EdgeInsets.all(6.0),
          child: ListView(
            children: <Widget>[
              GetUserList(onFetchUserList: onFetchUserList),
              GetUser(userList: userList),
            ],
          ),
        ));
  }
}

class GetUserList extends StatefulWidget {
  final onFetchUserList;

  GetUserList({this.onFetchUserList});

  @override
  _GetUserList createState() => _GetUserList();
}

class _GetUserList extends State<GetUserList> {
  String orderBy;
  int limit, offset;
  BaaS.UserList userList;

  @override
  void initState() {
    super.initState();
    fetchUserList();
  }

  Future<void> fetchUserList() async {
    try {
      BaaS.Query query = BaaS.Query();
      query
        ..limit(limit ?? 20)
        ..offset(offset ?? 0)
        ..orderBy(orderBy);

      BaaS.UserList _userList = await BaaS.User.find(query: query);

      setState(() {
        userList = _userList;
      });
      widget.onFetchUserList(userList);
    } on BaaS.HError catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  List<Widget> _userListBuilder() {
    if (userList == null) return null;
    var list = userList.users.map((e) {
      return ListTile(
        title: Text(e.nickname ?? e.userId),
      );
    });
    return list.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '_userprofile 表',
          style: TextStyle(fontSize: 24),
        ),
        Container(
          child: Text(
            'order_by',
            style: TextStyle(fontSize: 16),
          ),
          alignment: Alignment.topLeft,
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: RadioListTile<String>(
                title: Text('nickname'),
                value: 'nickname',
                groupValue: orderBy,
                onChanged: (v) {
                  setState(() {
                    orderBy = v;
                  });
                  fetchUserList();
                },
              ),
            ),
            Flexible(
              child: RadioListTile<String>(
                title: Text('-nickname'),
                value: '-nickname',
                groupValue: orderBy,
                onChanged: (v) {
                  setState(() {
                    orderBy = v;
                  });
                  fetchUserList();
                },
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                'limit',
                style: TextStyle(fontSize: 16),
              ),
              alignment: Alignment.topLeft,
            ),
            NumberInputWithIncrementDecrement(
              width: 100,
              alignment: Alignment.bottomLeft,
              onChange: (v) {
                setState(() {
                  limit = v;
                });
                fetchUserList();
              },
            ),
            Container(
              child: Text(
                'offset',
                style: TextStyle(fontSize: 16),
              ),
              alignment: Alignment.topLeft,
            ),
            NumberInputWithIncrementDecrement(
              width: 100,
              alignment: Alignment.bottomLeft,
              onChange: (v) {
                setState(() {
                  offset = v;
                });
                fetchUserList();
              },
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Colors.grey,
          )),
          child: SizedBox(
              height: 300.0,
              width: 300.0,
              child: ListView(
                children: _userListBuilder(),
              )),
        ),
      ],
    );
  }
}

class GetUser extends StatefulWidget {
  final BaaS.UserList userList;

  GetUser({this.userList}) : super();

  @override
  _GetUser createState() => _GetUser();
}

class _GetUser extends State<GetUser> {
  String userId = '36395395';
  BaaS.User user;

  Future<void> initUser() async {
    if (widget.userList == null || widget.userList.users.length <= 0) return;
    setState(() {
      userId = widget.userList.users[0].userId;
    });
    user = await BaaS.User.user(widget.userList.users[0].userId);
  }

  @override
  Widget build(BuildContext context) {
    initUser();

    return Column(
      children: <Widget>[
        SectionTitle('user = "$userId"'),
        RaisedButton(
          child: Text('获取用户信息'),
          onPressed: widget.userList.users.length > 0
              ? () async {
                  try {
                    String userId = widget.userList.users.length > 0
                        ? widget.userList.users[0].userId
                        : this.userId;
                    BaaS.User user = await BaaS.User.user(userId);
                    showSimpleDialog(context, prettyJson(user.toJson()));
                  } on BaaS.HError catch (e) {
                    showSnackBar(e.toString(), context);
                  }
                }
              : null,
        ),
        RaisedButton(
          child: Text('获取用户信息 select & expand'),
          onPressed: () async {
            try {
              String userId = widget.userList.users.length > 0
                  ? widget.userList.users[0].userId
                  : this.userId;

              BaaS.User user = await BaaS.User.user(
                userId,
                expand: ['pointer_test_order'],
                select: ['nickname', 'pointer_test_order'],
              );
              showSimpleDialog(context, prettyJson(user.toJson()));
            } on BaaS.HError catch (e) {
              showSnackBar(e.toString(), context);
            }
          },
        ),
        RaisedButton(
          child: Text('查找指定用户 by user_id'),
          onPressed: () async {
            BaaS.Where where = BaaS.Where.compare('id', '=', userId);

            BaaS.Query query = BaaS.Query();
            query.orderBy('created_at');
            query.where(where);

            print(query.get());

            try {
              BaaS.UserList users = await BaaS.User.find(query: query);
              print(users.users[0]);
              alert(context, users.users[0].userId);
            } on BaaS.HError catch (e) {
              showSnackBar(e.toString(), context);
            }
          },
        ),
        RaisedButton(
          child: Text('更新当前用户信息 自定义字段'),
          onPressed: () async {
            try {
              await user.updateUserInfo({
                'age': 68,
              });
              alert(context, user.get('age').toString());
            } on BaaS.HError catch (e) {
              showSnackBar(e.toString(), context);
            }
          },
        ),
        SectionTitle('count'),
        RaisedButton(
          child: Text('count 查询'),
          onPressed: () async {
            BaaS.Query query = BaaS.Query()
              ..limit(1)
              ..withTotalCount(true);
            try {
              BaaS.UserList users = await BaaS.User.find(query: query);
              int totalCount = users.totalCount;
              alert(context, totalCount.toString());
            } on BaaS.HError catch (e) {
              showSnackBar(e.toString(), context);
            }
          },
        ),
        SectionTitle('其他'),
        RaisedButton(
          child: Text('用户信息 select（只返回 nickname）'),
          onPressed: () async {
            try {
              BaaS.User user =
                  await BaaS.User.user(userId, select: ['nickname']);
              alert(context, user.toJson().toString());
            } on BaaS.HError catch (e) {
              showSnackBar(e.toString(), context);
            }
          },
        ),
      ],
    );
  }
}
