import 'dart:math';
import 'package:minapp/minapp.dart';
import './connectanum/connectanum.dart';
import './callback.dart';
import './error.dart';
import './client.dart';

Client _client;
Session _session; // 一个 session 管理所有连接。因此这里放在最顶部，而非函数内。
Map<String, Map> subscriptionMap = {};
bool isRetry = false;

/// 复制 subscriptionMap。
/// 由于在重新订阅的时候，会往 subscriptionMap 添加新内容，
/// 如果单纯遍历 subscriptionMap，会出现 `Concurrent modification during iteration`
/// 的报错，因此需要复制一份出来，再遍历。
Map<String, Map> _copySubscriptionMap() {
  Map<String, Map> copied = {};
  for (String key in subscriptionMap.keys) {
    Map subscriptionMapItem = subscriptionMap[key];
    copied[key] = subscriptionMapItem;
  }

  return copied;
}

/// 重新订阅。
/// 由于 connectanum 库没有断线重连后重新订阅的功能，
/// 因此需要通过在 SDK 初始化的时候创建一个 map，在订阅时将订阅的内容放进这个 map。
/// 在断线重连后，读取 map 内的数据，逐一订阅。
Future _resubscribe() async {
  isRetry = true;

  Map<String, Map> _subscriptionMap = _copySubscriptionMap();
  for (Map subscriptionMapItem in _subscriptionMap.values) {
    String tableId = subscriptionMapItem['tableId'];
    String eventType = subscriptionMapItem['eventType'];
    Where where = subscriptionMapItem['where'];
    Function onInit = subscriptionMapItem['onInit'];
    Function onEvent = subscriptionMapItem['onEvent'];
    Function onError = subscriptionMapItem['onError'];

    var subscribe = await wampSubscribe(
      tableId,
      eventType,
      where,
      onInit,
      onEvent,
      onError,
    );

    await subscribe();

    isRetry = false;
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

/// 实时数据库 WAMP。
/// 接收 [tableId] 必填参数，数据表 ID。
/// [eventType] 必填参数，必须为 create、update 或 delete。
/// [where] 按条件订阅。
/// [onInit] 订阅动作初始化成功时的回调函数。
/// [onEvent] 数据表变化时的回调函数。
/// [onError] 订阅动作出错时的回调函数。
Future wampSubscribe(String tableId, String eventType, Where where,
    Function onInit, Function onEvent, Function onError) async {
  int retryCount = 15; // 重试次数

  // 初始化 Client
  if (_client == null || isRetry == true) {
    _client = await createWampClient();
  }

  /// 初始化 Session
  if (_session == null || isRetry == true) {
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

      // 断线后每隔一段时间重连
      // 当 delayTime 大于 300，则直接按 300 秒重连。这里与 iOS SDK 保持一致。
      _client.onNextTryToReconnect.listen((passedOptions) {
        print('retrying....');
        double delayInSec =
            pow(2, retryCount - passedOptions.reconnectCount + 1) * 0.5;
        int delayTime = (min(delayInSec, 300) * 1000).round();
        passedOptions.reconnectTime = Duration(milliseconds: delayTime);

        // connectanum 库没有实现断线重连后重新 subscribe 的功能，这里只能手动实现
        _resubscribe();
      });
    } on Abort catch (abort) {
      onError(errorify(abort: abort)); // 订阅失败回调
    }
  }

  /// 订阅实时数据库。
  Future<WampSubscriber> subscribe() async {
    // if (_session == null) return;

    try {
      String topic = _resolveTopic(tableId, eventType);
      SubscribeOptions options = _resolveOptions(where);

      Subscribed subscription = await _session.subscribe(
        topic,
        options: options,
      );
      onInit(); // 订阅成功回调

      String key = {
        'tableId': tableId,
        'eventType': eventType,
        'where': where,
      }.toString();

      subscriptionMap[key] = {
        'tableId': tableId,
        'eventType': eventType,
        'where': where,
        'onInit': onInit,
        'onEvent': onEvent,
        'onError': onError,
        'subscriptionId': subscription.subscriptionId,
      };

      // 监听数据变化
      subscription.eventStream.listen(
        (event) {
          WampCallback result = new WampCallback(
            Map<String, dynamic>.from(event.argumentsKeywords),
          );

          onEvent(result);
        },
      );
    } on Abort catch (abort) {
      onError(errorify(abort: abort));
    } on Error catch (err) {
      Abort abort = new Abort(err.error);
      onError(errorify(abort: abort));
    }

    /// 取消订阅。
    /// [onSuccess] 取消订阅成功回调。
    /// [onError] 取消订阅失败回调。
    Future unsubscribe({
      Function onSuccess,
      Function onError,
    }) async {
      onError = onError ?? (HError error) => {};
      onSuccess = onSuccess ?? () => {};

      String key = {
        'tableId': tableId,
        'eventType': eventType,
        'where': where,
      }.toString();

      Map found = subscriptionMap[key];

      if (_session == null || found['subscriptionId'] == null) {
        onError(new HError(602));
        return;
      }

      try {
        await _session.unsubscribe(found['subscriptionId']);
        onSuccess();
        subscriptionMap.remove(key); // 取消订阅后，将订阅内容从 map 中销毁
      } catch (e) {
        Abort abort = new Abort('Unsubscribe failed.');
        onError(errorify(abort: abort));
      }
    }

    return new WampSubscriber(unsubscribe);
  }

  return subscribe;
}
