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
  List<BaaS.User> userList;

  @override
  void initState() {
    super.initState();
    userList = [];
  }

  void onFetchUserList(List<BaaS.User> users) {
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
        )
    );
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
  List<BaaS.User> userList = [];

  @override
  void initState() {
    super.initState();
    fetchUserList();
  }

  Future<void> fetchUserList() async {
    try {
      BaaS.Query query = BaaS.Query();
      query.limit(limit ?? 20);
      query.offset(offset ?? 0);
      query.orderBy(orderBy);

      var _userList = await BaaS.User.find(query: query);

      setState(() {
        userList = _userList;
      });
      widget.onFetchUserList(userList);
    } on BaaS.HError catch(e) {
      showSnackBar(e.toString(), context);
    }
  }

  List<Widget> _userListBuilder() {
    var list = userList.map((e) {
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
            )
          ),
          child: SizedBox(
            height: 300.0,
            width: 300.0,
            child: ListView(
              children: _userListBuilder(),
            )
          ),
        ),
      ],
    );
  }
}

class GetUser extends StatefulWidget {
  final List<BaaS.User> userList;

  GetUser({this.userList}) : super();

  @override
  _GetUser createState() => _GetUser();
}

class _GetUser extends State<GetUser> {
  final String userId = '36395395';
  BaaS.User user;

  Future<void> initUser() async {
    if (widget.userList.length <= 0) return;
    user = await BaaS.User.user(widget.userList[0].userId);
  }

  @override
  Widget build(BuildContext context) {
    initUser();

    return Column(
      children: <Widget>[
        SectionTitle('user = "$userId"'),
        RaisedButton(
          child: Text('获取用户信息'),
          onPressed: widget.userList.length > 0 ? () async {
            try {
              String userId = widget.userList.length > 0 ? widget.userList[0].userId : this.userId;
              BaaS.User user = await BaaS.User.user(userId);
              showSimpleDialog(context, prettyJson(user.toJson()));
            } on BaaS.HError catch(e) {
              showSnackBar(e.toString(), context);
            }
          } : null,
        ),
        RaisedButton(
          child: Text('获取用户信息 select & expand'),
          onPressed: () async {
            try {
              String userId = widget.userList.length > 0 ? widget.userList[0].userId : this.userId;

              BaaS.User user = await BaaS.User.user(
                userId,
                expand: ['pointer_test_order'],
                select: ['nickname', 'pointer_test_order'],
              );
              showSimpleDialog(context, prettyJson(user.toJson()));
            } on BaaS.HError catch(e) {
              showSnackBar(e.toString(), context);
            }
          },
        ),
        RaisedButton(
          child: Text('查找指定用户 by user_id'),
          onPressed: () async {
            BaaS.Query query = BaaS.Query();
            query.orderBy('created_at');
            print(query.get());
          },
        ),
        RaisedButton(
          child: Text('更新当前用户信息 自定义字段'),
          onPressed: () async {
            try {
              await user.updateUserInfo({
                'age': 68,
              });
              showSnackBar(user.get('age').toString(), context);
            } on BaaS.HError catch(e) {
              showSnackBar(e.toString(), context);
            }
          },
        ),
      ],
    );
  }
}
