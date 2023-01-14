import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart';

import 'common.dart';

class SmsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('短信验证码')),
      body: Padding(
        padding: EdgeInsets.all(6.0),
        child: SmsForm(),
      ),
    );
  }
}

class SmsForm extends StatefulWidget {
  @override
  State createState() => _SmsState();
}

class _SmsState extends State<SmsForm> {
  final _phoneController = TextEditingController();
  final _signController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: '手机号',
          ),
          keyboardType: TextInputType.phone,
        ),
        TextFormField(
          controller: _signController,
          decoration: InputDecoration(
            labelText: '签名 ID',
          ),
        ),
        ElevatedButton(
          child: Text('发送短信验证码'),
          onPressed: () async {
            try {
              await sendSmsCode(
                phone: _phoneController.text,
                signatureID: _signController.text,
              );
              showSnackBar('验证码已发送', context);
            } on HError catch (e) {
              showSnackBar(e.toString(), context);
            }
          },
        ),
        TextFormField(
          controller: _codeController,
          decoration: InputDecoration(
            labelText: '验证码',
          ),
          keyboardType: TextInputType.number,
        ),
        ElevatedButton(
          child: Text('验证短信验证码'),
          onPressed: () async {
            try {
              await verifySmsCode(
                phone: _phoneController.text,
                code: _codeController.text,
              );
              showSnackBar('验证成功', context);
            } on HError catch (e) {
              showSnackBar(e.toString(), context);
            }
          },
        ),
      ],
    );
  }
}
