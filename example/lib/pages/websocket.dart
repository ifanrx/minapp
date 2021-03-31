import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart';
import '../components/custom_button.dart';

class WebSocketPage extends StatefulWidget {
  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  Map<String, dynamic> subscriptions = {};

  @override
  void initState() {
    super.initState();
  }

  Future subscribeEvent(eventType) async {
    TableObject tableObject = new TableObject('danmu_jiajun');

    try {
      subscriptions[eventType] = await tableObject.subscribe(
        eventType,
        onInit: () {
          print('订阅 $eventType 成功');
        },
        onEvent: (result) {
          print('有返回结果 $eventType');
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
          print(error.details);
        },
        // where: Where.compare('text', '=', 'hello'),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void subscribe(eventType) async {
    subscribeEvent(eventType);
  }

  void unsubscribe(eventType) async {
    WampSubscriber subscriber = subscriptions[eventType];
    if (subscriber == null) return;

    subscriber.unsubscribe(onSuccess: () {
      print('取消订阅成功');
    }, onError: (error) {
      print('取消订阅失败');
      print(error.toString());
    });
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
                () => subscribe('create'),
                title: '订阅 create',
              ),
              CustomButton(
                () => subscribe('update'),
                title: '订阅 update',
              ),
              CustomButton(
                () => subscribe('delete'),
                title: '订阅 delete',
              ),
              CustomButton(
                () => unsubscribe('create'),
                title: '取消订阅 create',
              ),
              CustomButton(
                () => unsubscribe('update'),
                title: '取消订阅 update',
              ),
              CustomButton(
                () => unsubscribe('delete'),
                title: '取消订阅 delete',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
