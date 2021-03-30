import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart';
import '../components/custom_button.dart';

class WebSocketPage extends StatefulWidget {
  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  int subscriptionId;
  Wamp wampCreate;
  Wamp wampUpdate;
  Wamp wampDelete;

  @override
  void initState() {
    super.initState();
  }

  Future<Wamp> subscribeEvent(eventType) async {
    TableObject tableObject = new TableObject('danmu_jiajun');

    Wamp wamp;
    try {
      wamp = await tableObject.subscribe(
        eventType,
        onInit: () {
          print('订阅 $eventType 成功');
        },
        onEvent: (result) {
          print('有返回结果');
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
    return wamp;
  }

  void subscribeCreate() async {
    wampCreate = await this.subscribeEvent('create');
  }

  void unsubscribeCreate() async {
    if (wampCreate == null) return;
    await wampCreate.unsubscribe(
      onSuccess: () {
        print('取消订阅 create 成功');
      },
      onError: (err) {
        print('error: $err');
      },
    );
  }

  void subscribeUpdate() async {
    wampUpdate = await this.subscribeEvent('update');
  }

  void unsubscribeUpdate() async {
    if (wampUpdate == null) return;
    await wampUpdate.unsubscribe(
      onSuccess: () {
        print('取消订阅 update 成功');
      },
      onError: (err) {
        print('error: $err');
      },
    );
  }

  void subscribeDelete() async {
    wampDelete = await this.subscribeEvent('delete');
  }

  void unsubscribeDelete() async {
    if (wampDelete == null) return;
    await wampDelete.unsubscribe(
      onSuccess: () {
        print('取消订阅 delete 成功');
      },
      onError: (err) {
        print('error: $err');
      },
    );
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
                subscribeUpdate,
                title: '订阅 update',
              ),
              CustomButton(
                subscribeDelete,
                title: '订阅 delete',
              ),
              CustomButton(
                unsubscribeCreate,
                title: '取消订阅 create',
              ),
              CustomButton(
                unsubscribeUpdate,
                title: '取消订阅 update',
              ),
              CustomButton(
                unsubscribeDelete,
                title: '取消订阅 delete',
              )
            ],
          ),
        ),
      ),
    );
  }
}
