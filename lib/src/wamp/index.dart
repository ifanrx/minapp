import 'dart:math';
import 'package:minapp/minapp.dart';
import './connectanum/connectanum.dart';
import '../config.dart';
import './callback.dart';
import './error.dart';
import './client.dart';

Client _client;
Session _session;
Map<String, int> subscriptionList = {};

/// 实时数据库 WAMP。
/// 接收 [tableId] 必填参数，数据表 ID。
/// [eventType] 必填参数，必须为 create、update 或 delete。
/// [onInit] 订阅动作初始化成功时的回调函数。
/// [onEvent] 数据表变化时的回调函数。
/// [onError] 订阅动作出错时的回调函数。
/// [retryCount] 最大重连次数。
class Wamp {
  String tableId;
  String eventType;
  Where where;
  Function onInit;
  Function onEvent;
  Function onError;
  int retryCount;

  Wamp(
    this.tableId,
    this.eventType,
    this.where,
    this.onInit,
    this.onEvent,
    this.onError,
    this.retryCount,
  );

  static Future<Wamp> getInstance(
    String tableId,
    String eventType,
    Where where,
    Function onInit,
    Function onEvent,
    Function onError,
    int retryCount,
  ) async {
    // 初始化 Client
    if (_client == null) {
      _client = await createWampClient();
    }

    /// 初始化 Session
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

    return new Wamp(
      tableId,
      eventType,
      where,
      onInit,
      onEvent,
      onError,
      retryCount,
    );
  }

  /// 订阅实时数据库。
  Future<void> subscribe() async {
    if (_session == null) return;

    try {
      String topic = _resolveTopic(tableId, eventType);
      SubscribeOptions options = _resolveOptions(where);

      Subscribed subscription =
          await _session.subscribe(topic, options: options);
      onInit(); // 订阅成功回调

      _setSubscriptionId(subscription.subscriptionId); // 设置订阅 ID

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
    onError = onError ?? (HError error) => {};
    onSuccess = onSuccess ?? () => {};
    int subscriptionId = _getSubscriptionId();

    if (_session == null || subscriptionId == null) {
      onError(new HError(602));
      return;
    }

    try {
      await _session.unsubscribe(subscriptionId);
      onSuccess();
    } catch (e) {
      Abort abort = new Abort('Unsubscribe failed.');
      onError(errorify(abort: abort));
    }
  }

  /// 设置订阅 ID。
  /// 由于多次订阅同一个事件（如点击同一个订阅按钮多次）会报重复订阅的错，
  /// 导致取消订阅时因这个报错而找不到订阅 ID，无法取消订阅。
  /// 鉴于每条订阅有其唯一性，因此在订阅的时候设置好 key 和 ID，
  /// 在取消订阅的时候即可通过 key 获取 ID。
  void _setSubscriptionId(subscriptionId) {
    Map<String, dynamic> key = {
      'tableId': tableId,
      'eventType': eventType,
      'where': where,
    };

    subscriptionList[key.toString()] = subscriptionId;
  }

  /// 获取订阅 ID。
  /// 由于多次订阅同一个事件（如点击同一个订阅按钮多次）会报重复订阅的错，
  /// 导致取消订阅时因这个报错而找不到订阅 ID，无法取消订阅。
  /// 鉴于每条订阅有其唯一性，因此在订阅的时候设置好 key 和 ID，
  /// 在取消订阅的时候即可通过 key 获取 ID。
  int _getSubscriptionId() {
    Map<String, dynamic> key = {
      'tableId': tableId,
      'eventType': eventType,
      'where': where,
    };

    return subscriptionList[key.toString()];
  }
}

String _resolveTopic(String schemaName, String eventType) {
  return '${config.wsBasicTopic}.$schemaName.on_$eventType';
}

SubscribeOptions _resolveOptions(Where where) {
  SubscribeOptions options = new SubscribeOptions();
  options.addCustomValue('where', (serializerType) => where.get());

  return options;
}
