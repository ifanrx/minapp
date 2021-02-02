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
    TableObject tableObject = new TableObject('danmu_jiajun');

    try {
      wamp = await tableObject.subscribe(
        'create',
        onInit: () {
          print('订阅成功');
        },
        onEvent: (result) {
          print(result.event);
          print(result.after.text);
          print(result.after.created_at);
          print(result.after.updated_at);
          print(result.after.created_by);
          print(result.after.id);
        },
        onError: (error) {
          print('失败！！！');
          print(error.message);
        },
        where: Where.compare('text', '=', 'hello'),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void unsubscribeCreate() async {
    await wamp.unsubscribe();
    print('取消订阅成功');
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
