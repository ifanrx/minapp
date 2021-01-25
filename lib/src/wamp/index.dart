import 'package:connectanum/connectanum.dart';
import 'package:connectanum/json.dart';
import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart';
import '../config.dart';

//TODO: use Uri.http to consctruct URL
Future<String> getWsAuthToken() async {
  List qs = [];
  qs.add('x-hydrogen-client-id=${config.clientID}');

  if (config.env != null) {
    qs.add('x-hydrogen-env-id=${config.env}');
  }

  String token = await Auth.getAuthToken();

  if (token != null) {
    qs.add('authorization=${config.authPrefix} $token');
  }

  return qs.join('&');
}

String resolveTopic(String schemaName, String eventType) {
  return '${config.wsBasicTopic}.$schemaName.on_$eventType';
}

/// 包装接口回调数据中的 before 和 after
class WampBeforeAfter {
  final Map<String, dynamic> beforeAfter;
  String get text => beforeAfter['text'];
  int get created_at => beforeAfter['created_at'];
  int get updated_at => beforeAfter['updated_at'];
  int get created_by => beforeAfter['created_by'];
  String get id => beforeAfter['id'];

  WampBeforeAfter(this.beforeAfter);
}

/// 对接口返回数据进行包装
class WampCallback {
  final Map<String, dynamic> callback;
  WampBeforeAfter get after =>
      new WampBeforeAfter(Map<String, dynamic>.from(callback['after']));
  WampBeforeAfter get before =>
      new WampBeforeAfter(Map<String, dynamic>.from(callback['before']));
  String get event => callback['event'];
  int get schema_id => callback['schema_id'];
  String get schema_name => callback['schema_name'];
  String get id => callback['id'];

  WampCallback(this.callback);
}

class Wamp {
  Client _client;
  Session _session;
  int _subscriptionId;

  /// 订阅实时数据库
  /// 接收 [tableId] 必填参数，数据表 ID。
  /// [eventType] 必填参数，必须为 create、update 或 delete。
  /// [oninit] 订阅动作初始化成功时的回调函数。
  /// [onevent] 数据表变化时的回调函数。
  /// [onerror] 订阅动作出错时的回调函数。
  Future<void> subscribe(
    String tableId,
    String eventType,
    Function oninit,
    Function onevent,
    Function onerror,
  ) async {
    String url =
        config.wsHost.replaceFirst(RegExp(r'/\/$/'), '') + '/' + config.wsPath;
    String token = await getWsAuthToken();

    if (_client == null) {
      _client = Client(
        realm: config.wsRealm,
        transport: WebSocketTransport(
          // '$url?$token',
          'wss://a4d2d62965ddb57fa4d6.ws.myminapp.com/ws/hydrogen/?x-hydrogen-client-id=a4d2d62965ddb57fa4d6&x-hydrogen-env-id=f1eeb28c9552d4c83df1&authorization=Hydrogen-r1%20580co4jlkysw7rprsgz4edxx9pubot3s',
          Serializer(),
          WebSocketSerialization.SERIALIZATION_JSON,
        ),
      );

      try {
        _session = await _client.connect().first;
        String topic = resolveTopic(tableId, eventType);

        SubscribeOptions options = new SubscribeOptions();
        options.addCustomValue('where', (serializerType) => '{}');

        Subscribed subscription =
            await _session.subscribe(topic, options: options);
        oninit(); // 订阅成功回调

        // 监听数据变化
        subscription.eventStream.listen(
          (event) {
            WampCallback result = new WampCallback(
                Map<String, dynamic>.from(event.argumentsKeywords));
            onevent(result);
          },
        );

        _subscriptionId = subscription.subscriptionId;
      } on Abort catch (abort) {
        onerror(abort); // 订阅失败回调
      }
    }
  }

  void unsubscribe() async {
    if (_session != null && _subscriptionId != null) {
      try {
        await _session.unsubscribe(_subscriptionId);
      } catch (e) {
        print(e);
      }
    }
  }
}
