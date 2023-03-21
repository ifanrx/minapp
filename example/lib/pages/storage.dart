import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart' as BaaS;

class StoragePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext).removeCurrentSnackBar();
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('本地存储')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _keyController,
                decoration: InputDecoration(
                  labelText: 'key',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return '请填写 key 值';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valueController,
                decoration: InputDecoration(
                  labelText: 'value',
                ),
              ),
              ElevatedButton(
                child: Text('set'),
                onPressed: () async {
                  if (!_formKey.currentState.validate()) return;
                  var key = _keyController.text;
                  var value = _valueController.text;
                  var ok = await BaaS.storageAsync.set(key, value);
                  _showSnackBar('设置${ok ? '成功' : '失败'}');
                },
              ),
              ElevatedButton(
                child: Text('get'),
                onPressed: () async {
                  if (!_formKey.currentState.validate()) return;
                  var key = _keyController.text;
                  var value = await BaaS.storageAsync.get(key);
                  _showSnackBar('$key=$value');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
