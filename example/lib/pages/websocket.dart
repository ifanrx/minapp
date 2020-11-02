import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart';
import '../components/custom_button.dart';

class WebSocketPage extends StatefulWidget {
  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  @override
  void initState() {
    super.initState();
  }

  void subscribeCreate() {
    Wamp wamp = new Wamp();
    wamp.subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WS 实时数据库测试')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomButton(
                subscribeCreate,
                title: '订阅 create',
              )
            ],
          ),
        ),
      ),
    );
  }
}
