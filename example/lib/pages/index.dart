import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart' as BaaS;

import 'auth.dart';
import 'storage.dart';
import 'user.dart';
import 'schema.dart';
import 'content.dart';
import 'file.dart';
import 'clound_function.dart';
import 'sms.dart';

class _Feature {
  final String name;
  final Widget page;

  _Feature({this.name, this.page});
}

final _features = [
  _Feature(name: '登入&登出', page: AuthPage()),
  _Feature(name: '本地存储', page: StoragePage()),
  _Feature(name: '用户', page: UserPage()),
  _Feature(name: '数据表', page: SchemaPage()),
  _Feature(name: '内容库', page: ContentPage()),
  _Feature(name: '文件', page: FilePage()),
  _Feature(name: '调用云函数', page: CloundFunctionPage()),
  _Feature(name: '短信验证码', page: SmsPage()),
];

class IndexPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    var snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    var list = _features
        .map<Widget>((item) => RaisedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => item.page));
              },
              child: Text(item.name),
            ))
        .toList();

    list.add(RaisedButton(
      onPressed: () async {
        var data = await BaaS.getServerDate();
        _showSnackBar(data.time);
      },
      child: Text('获取服务器时间'),
    ));

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('测试应用')),
      body: Center(
        child: Column(
          children: list,
        ),
      ),
    );
  }
}
