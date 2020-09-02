import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart' as BaaS;

import 'common.dart';
import '../util.dart';

class AuthPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('用户')),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(6.0),
            child: Column(
              children: <Widget>[
                Register(),
                LoginUsername(),
                LoginWithPhone(),
                OtherSettings(),
              ],
            ),
          ),
        )
    );
  }
}

class LoginUsername extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginUsername();
}

class _LoginUsername extends State<LoginUsername> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SectionTitle('用户登录'),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: '邮箱',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: '用户名',
            ),
            keyboardType: TextInputType.text,
          ),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: '手机号码',
            ),
            keyboardType: TextInputType.phone,
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
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
                if (username.length > 0) {
                  await BaaS.Auth.loginWithUsername(
                    username: username,
                    password: password,
                  );
                } else if (_emailController.text.length > 0) {
                  await BaaS.Auth.loginWithEmail(
                    email: _emailController.text,
                    password: password,
                  );
                } else if (_phoneController.text.length > 0) {
                  await BaaS.Auth.loginWithPhone(
                    phone: _phoneController.text,
                    password: password,
                  );
                }
                showSnackBar('登录成功', context);
              } on BaaS.HError catch(e) {
                showSnackBar(e.toString(), context);
              }
            },
          ),
        ],
      ),
    );
  }
}

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Register();
}

class _Register extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String email, username, phone, password;

  @override
  void initState() {
    super.initState();
    email = '';
    username = '';
    phone = '';
    password = '';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SectionTitle('用户注册'),
          TextFormField(
            decoration: InputDecoration(
              labelText: '邮箱',
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (v) {
              setState(() {
                email = v;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: '用户名',
            ),
            keyboardType: TextInputType.text,
            onChanged: (v) {
              setState(() {
                username = v;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: '手机号',
            ),
            keyboardType: TextInputType.phone,
            onChanged: (v) {
              setState(() {
                phone = v;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: '密码',
            ),
            obscureText: true,
            onChanged: (v) {
              setState(() {
                password = v;
              });
            },
          ),
          RaisedButton(
            child: Text('注册'),
            onPressed: (email.length > 0 || phone.length > 0 || username.length > 0) && password.length > 0 ? () async {
              if (!_formKey.currentState.validate()) return;

              try {
                if (username.length > 0) {
                  await BaaS.Auth.registerWithUsername(
                    username: username,
                    password: password,
                  );
                } else if (email.length > 0) {
                  await BaaS.Auth.registerWithEmail(
                    email: email,
                    password: password,
                  );
                } else if (phone.length > 0) {
                  await BaaS.Auth.registerWithPhone(
                    phone: phone,
                    password: password,
                  );
                }
                showSnackBar('登录成功', context);
              } on BaaS.HError catch(e) {
                showSnackBar(e.toString(), context);
              }
            } : null,
          ),
        ],
      ),
    );
  }
}

class LoginWithPhone extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginWithPhone();
}

class _LoginWithPhone extends State<LoginWithPhone> {
  final _formKey = GlobalKey<FormState>();
  String phone, code;

  @override
  void initState() {
    super.initState();
    phone = '';
    code = '';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SectionTitle('手机号码登录'),
          TextFormField(
            decoration: InputDecoration(
              labelText: '手机号',
            ),
            keyboardType: TextInputType.phone,
            onChanged: (v) {
              setState(() {
                phone = v;
              });
            },
          ),
          RaisedButton(
            child: Text('获取短信验证码'),
            onPressed: () async {
              try {
                print(phone);
                await BaaS.sendSmsCode(phone: phone);
              } on BaaS.HError catch(e) {
                showSnackBar(e.toString(), context);
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: '短信验证码',
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) {
              setState(() {
                code = v;
              });
            },
          ),
          RaisedButton(
            child: Text('手机号登录'),
            onPressed: () async {
              try {
                await BaaS.Auth.loginWithSmsVerificationCode(phone, code);
                showSnackBar('登录成功', context);
              } on BaaS.HError catch(e) {
                showSnackBar(e.toString(), context);
              }
            },
          ),
        ],
      ),
    );
  }
}

class OtherSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OtherSettings();
}

class _OtherSettings extends State<OtherSettings> {
  final _emailController = TextEditingController();
  final _emailForUpdate = TextEditingController();
  final _usernameForUpdate = TextEditingController();
  final _passwordForUpdate = TextEditingController();
  final _emailSetting = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SectionTitle('其他'),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '邮箱',
                  ),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    return v.trim().length > 0 ? null : '邮箱不能为空';
                  },
                ),
                RaisedButton(
                  child: Text('忘记密码'),
                  onPressed: () async {
                    try {
                      await BaaS.Auth.requestPasswordReset(_emailController.text);
                    } on BaaS.HError catch(e) {
                      showSnackBar(e.toString(), context);
                    }
                  },
                )
              ],
            ),
          ),
          RaisedButton(
            child: Text('匿名登录'),
            onPressed: () async {
              try{
                BaaS.CurrentUser currentUser = await BaaS.Auth.anonymousLogin();
                showSnackBar(prettyJson(currentUser?.toJSON()), context);
              } on BaaS.HError catch(e) {
                showSnackBar(e.toString(), context);
              }
            },
          ),
          RaisedButton(
            child: Text('获取当前用户'),
            onPressed: () async {
              try {
                BaaS.CurrentUser currentUser = await BaaS.Auth.getCurrentUser();
                showSnackBar(prettyJson(currentUser?.toJSON()), context);
              } on BaaS.HError catch(e) {
                showSnackBar(e.toString(), context);
              }
            },
          ),
          RaisedButton(
            child: Text('登出'),
            onPressed: () async {
              try {
                await BaaS.Auth.logout();
                showSnackBar('已登出', context);
              } on BaaS.HError catch(e) {
                showSnackBar(e.toString(), context);
              }
            },
          ),
          Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: '邮箱'
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailForUpdate,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '用户名',
                  ),
                  controller: _usernameForUpdate,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '密码',
                  ),
                  obscureText: true,
                  controller: _passwordForUpdate,
                ),
                RaisedButton(
                  child: Text('设置用户名/邮箱/密码'),
                  onPressed: () async {
                    Map<String, dynamic> data = {
                      'email': _emailForUpdate.text,
                      'username': _usernameForUpdate.text,
                      'password': _passwordForUpdate.text,
                    };
                    try {
                      BaaS.CurrentUser currentUser = await BaaS.Auth.getCurrentUser();
                      await currentUser.setAccount(data);
                      showSnackBar(prettyJson(currentUser?.toJSON()), context);
                    } on BaaS.HError catch(e) {
                      showSnackBar(e.toString(), context);
                    }
                  },
                )
              ],
            ),
          ),
          Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '邮箱',
                  ),
                  controller: _emailSetting,
                ),
                RaisedButton(
                  child: Text('设置邮箱'),
                  onPressed: () async {
                    try{
                      BaaS.CurrentUser currentUser = await BaaS.Auth.getCurrentUser();
                      await currentUser.setEmail(_emailSetting.text);
                      showSnackBar(currentUser.email, context);
                    } on BaaS.HError catch(e) {
                      showSnackBar(e.toString(), context);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}