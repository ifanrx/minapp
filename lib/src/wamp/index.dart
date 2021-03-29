import 'dart:math';
import 'package:minapp/minapp.dart';
import './connectanum/connectanum.dart';
import './connectanum/json.dart';
import '../config.dart';
import './callback.dart';
import './error.dart';

Session _session;

class Wamp {
  Client _client;
  int _subscriptionId;

  /// 订阅实时数据库。
  /// 接收 [tableId] 必填参数，数据表 ID。
  /// [eventType] 必填参数，必须为 create、update 或 delete。
  /// [onInit] 订阅动作初始化成功时的回调函数。
  /// [onEvent] 数据表变化时的回调函数。
  /// [onError] 订阅动作出错时的回调函数。
  /// [retryCount] 最大重连次数。
  Future<void> subscribe(
    String tableId,
    String eventType,
    Where where,
    Function onInit,
    Function onEvent,
    Function onError, {
    int retryCount,
  }) async {
    String uri = await getWsAuthUri();

    if (_client == null) {
      _client = Client(
        realm: config.wsRealm,
        transport: WebSocketTransport(
          uri,
          // 'wss://a4d2d62965ddb57fa4d6.ws.myminapp.com/ws/hydrogen/?x-hydrogen-client-id=a4d2d62965ddb57fa4d6&x-hydrogen-env-id=f1eeb28c9552d4c83df1&authorization=Hydrogen-r1%20580co4jlkysw7rprsgz4edxx9pubot3s',
          Serializer(),
          WebSocketSerialization.SERIALIZATION_JSON,
        ),
      );
    }

    if (_session == null) {
      try {
        _session = await _client
            .connect(
              options: ClientConnectOptions(
                reconnectCount: retryCount,
                reconnectTime: Duration(
                  milliseconds: 200,
                ),
              ),
            )
            .first;

        _client.onNextTryToReconnect.listen((passedOptions) {
          // 断线后每隔一段时间重连
          // 当 delayTime 大于 300，则直接按 300 秒重连。这里与 iOS SDK 保持一致。
          double delayInSec =
              pow(2, retryCount - passedOptions.reconnectCount + 1) * 0.5;
          int delayTime = (min(delayInSec, 300) * 1000).round();
          passedOptions.reconnectTime = Duration(milliseconds: delayTime);
        });
      } on Abort catch (abort) {
        onError(errorify(abort: abort)); // 订阅失败回调
      }
    }

    if (_session == null) return;

    try {
      String topic = resolveTopic(tableId, eventType);
      SubscribeOptions options = resolveOptions(where);

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
      onError(errorify(abort: abort));
    } on Error catch (err) {
      Abort abort = new Abort(err.error);
      onError(errorify(abort: abort));
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
      if (onError != null) onError(new HError(602));
      return;
    }

    try {
      await _session.unsubscribe(_subscriptionId);
      if (onSuccess != null) onSuccess();
    } catch (e) {
      Abort abort = new Abort('Unsubscribe failed.');
      if (onError != null) onError(errorify(abort: abort));
    }
  }
}

Future<String> getWsAuthUri() async {
  String host = config.wsHost
      .replaceFirst(RegExp(r'/\/$/'), '')
      .replaceFirst('wss://', '');

  Map<String, dynamic> queryParameters = {
    'x-hydrogen-client-id': config.clientID,
  };

  if (config.env != null) {
    queryParameters['x-hydrogen-env-id'] = config.env;
  }

  String token = await Auth.getAuthToken();

  if (token != null) {
    queryParameters['authorization'] = '${config.authPrefix} $token';
  }

  Uri wsAuthUri = new Uri(
    scheme: 'wss',
    host: host,
    path: config.wsPath,
    queryParameters: queryParameters,
  );

  return wsAuthUri.toString();
}

String resolveTopic(String schemaName, String eventType) {
  return '${config.wsBasicTopic}.$schemaName.on_$eventType';
}

SubscribeOptions resolveOptions(Where where) {
  SubscribeOptions options = new SubscribeOptions();
  options.addCustomValue('where', (serializerType) => where.get());

  return options;
}
