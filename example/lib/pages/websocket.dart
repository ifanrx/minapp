import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart';
import '../components/custom_button.dart';

class WebSocketPage extends StatefulWidget {
  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  int subscriptionId;
  Wamp wamp;

  @override
  void initState() {
    super.initState();
  }

  void subscribeCreate() async {
    wamp = new Wamp();
    int _subscriptionId = await wamp.subscribe();
    print('subscriptionId: $_subscriptionId');
    if (_subscriptionId != null) {
      setState(() => subscriptionId = _subscriptionId);
    }
  }

  void unsubscribeCreate() {
    print('gonna unscribe $subscriptionId');
    wamp.unsubscribe(subscriptionId);
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
              ),
              CustomButton(
                unsubscribeCreate,
                title: '取消订阅 create',
              )
            ],
          ),
        ),
      ),
    );
  }
}
