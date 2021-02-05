import 'dart:math';

import 'package:connectanum/connectanum.dart';
import 'package:connectanum/json.dart';
import 'package:minapp/minapp.dart';
import '../config.dart';

class Wamp {
  Client _client;
  Session _session;
  int _subscriptionId;

  /// 订阅实时数据库。
  /// 接收 [tableId] 必填参数，数据表 ID。
  /// [eventType] 必填参数，必须为 create、update 或 delete。
  /// [onInit] 订阅动作初始化成功时的回调函数。
  /// [onEvent] 数据表变化时的回调函数。
  /// [onError] 订阅动作出错时的回调函数。
  /// [retryCount] 最大重连次数。
  /// [delayTime] 重连时间间隔。
  Future<void> subscribe(
    String tableId,
    String eventType,
    String where,
    Function onInit,
    Function onEvent,
    Function onError, {
    int retryCount,
    int delayTime,
  }) async {
    String url =
        config.wsHost.replaceFirst(RegExp(r'/\/$/'), '') + '/' + config.wsPath;
    String token = await getWsAuthToken();

    if (_client == null) {
      _client = Client(
        realm: config.wsRealm,
        transport: WebSocketTransport(
          '$url?$token',
          // 'wss://a4d2d62965ddb57fa4d6.ws.myminapp.com/ws/hydrogen/?x-hydrogen-client-id=a4d2d62965ddb57fa4d6&x-hydrogen-env-id=f1eeb28c9552d4c83df1&authorization=Hydrogen-r1%20580co4jlkysw7rprsgz4edxx9pubot3s',
          Serializer(),
          WebSocketSerialization.SERIALIZATION_JSON,
        ),
      );
    }

    if (_session == null) {
      try {
        Duration reconnectTime = new Duration(
          seconds: delayTime ?? getDefaultDelaytime(retryCount),
        );

        _session = await _client
            .connect(
              reconnectTime: reconnectTime,
              reconnectCount: retryCount,
            )
            .first;
      } on Abort catch (abort) {
        HError error = errorify(abort);
        onError(error); // 订阅失败回调
      }
    }

    try {
      String topic = resolveTopic(tableId, eventType);
      SubscribeOptions options = new SubscribeOptions();
      options.addCustomValue('where', (serializerType) => where);

      Subscribed subscription =
          await _session.subscribe(topic, options: options);
      _subscriptionId = subscription.subscriptionId;
      onInit(); // 订阅成功回调

      // 监听数据变化
      subscription.eventStream.listen(
        (event) {
          WampCallback result = new WampCallback(
              Map<String, dynamic>.from(event.argumentsKeywords));
          onEvent(result);
        },
      );
    } on Abort catch (abort) {
      HError error = errorify(abort);
      onError(error); // 订阅失败回调
    }
  }

  /// 取消订阅。
  /// [onSuccess] 取消订阅成功回调。
  /// [onError] 取消订阅失败回调。
  Future<void> unsubscribe({
    Function onSuccess,
    Function onError,
  }) async {
    if (_session == null || _subscriptionId == null) {
      HError error = new HError(602);
      if (onError != null) onError(error);
      return;
    }

    try {
      await _session.unsubscribe(_subscriptionId);
      if (onSuccess != null) onSuccess();
    } catch (e) {
      HError error = new HError(0);
      error.message = e.details ?? 'Unsubscribe failed.';
      if (onError != null) onError(error);
    }
  }
}

/// 包装接口回调数据中的 before 和 after
class WampSchemaHistory {
  final Map<String, dynamic> beforeAfter;
  String get text => beforeAfter['text'];
  int get created_at => beforeAfter['created_at'];
  int get updated_at => beforeAfter['updated_at'];
  int get created_by => beforeAfter['created_by'];
  String get id => beforeAfter['id'];

  WampSchemaHistory(this.beforeAfter);
}

/// 对接口返回数据进行包装
class WampCallback {
  final Map<String, dynamic> callback;
  WampSchemaHistory get before =>
      new WampSchemaHistory(Map<String, dynamic>.from(callback['before']));
  WampSchemaHistory get after =>
      new WampSchemaHistory(Map<String, dynamic>.from(callback['after']));
  String get event => callback['event'];
  int get schema_id => callback['schema_id'];
  String get schema_name => callback['schema_name'];
  String get id => callback['id'];

  WampCallback(this.callback);
}

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

int getDefaultDelaytime(int retryCount) {
  double delayTime = pow(2, retryCount) * 0.5;
  print(min(delayTime.round(), 300));
  return min(delayTime.round(), 300);
}

HError errorify(Abort abort) {
  Map<String, dynamic> lookup = {
    'unreachable': 601,
    'wamp.error.not_authorized': 603,
  };

  int errorCode = lookup[abort.reason] ?? 0;

  return HError(errorCode, abort.reason, abort.message.message);
}

Future<void> subscribe(
  String tableId,
  String eventType,
  String where,
  Function onInit,
  Function onEvent,
  Function onError, {
  int retryCount,
  int delayTime,
}) async {
  String url =
      config.wsHost.replaceFirst(RegExp(r'/\/$/'), '') + '/' + config.wsPath;
  String token = await getWsAuthToken();

  
}
