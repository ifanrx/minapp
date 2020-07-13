import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart' as BaaS;

import '../util.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    var snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('用户')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child:  Column(
          children: <Widget>[
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: '用户名',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return '请填写用户名';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: '密码',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return '请填写密码';
                }
                return null;
              },
            ),
            RaisedButton(
              child: Text('登录'),
              onPressed: () async {
                if (!_formKey.currentState.validate()) return;

                var username = _usernameController.text;
                var password = _passwordController.text;

                try {
                  await BaaS.login({
                    'username': username,
                    'password': password,
                  });
                  _showSnackBar('登录成功');
                } on BaaS.HError catch(e) {
                  _showSnackBar(e.toString());
                }
              },
            ),
            RaisedButton(
              child: Text('获取当前用户'),
              onPressed: () async {
                try {
                  var res = await BaaS.getCurrentUser();
                  _showSnackBar(prettyJson(res));
                } on BaaS.HError catch(e) {
                  _showSnackBar(e.toString());
                }
              },
            ),
          ],
        ),
        ),
      ),
    );
  }
}
