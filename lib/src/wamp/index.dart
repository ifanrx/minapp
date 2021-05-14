import 'dart:math';
import 'dart:convert';
import 'package:minapp/minapp.dart';
import './connectanum/connectanum.dart';
import './callback.dart';
import './error.dart';
import './client.dart';

Client _client;
Session _session; // 一个 session 管理所有连接。因此这里放在最顶部，而非函数内。
Map<String, Map> _subscriptionMap = {};

/// 一个 session 需要管理所有连接，以及 retry 的时候会新建一个 session。
/// 为了避免 retry 时遍历方法把 session 重复新建，
/// 这里用一个 _isRetry 变量，判断是否应该新建。
bool _isRetry = false;

/// 当所有订阅都被取消后，断开连接
void _disconnect() {
  _session.close();
  _session = null;
  _client = null;
  print('disconnected');
}

/// 校验 where 条件查询是否合法
bool _validateWhereOptions(Where where) {
  Map _where = jsonDecode(where.get());

  if (_where.isEmpty) {
    return true;
  }

  List optionList = _where['\$and'];
  if (optionList.length != 1) {
    return false;
  }

  List entryList = optionList[0].entries.toList();
  String key = entryList[0].key;
  if (optionList[0][key] == null) {
    return false;
  }

  return true;
}

/// 重新订阅。
/// 由于 connectanum 库没有断线重连后重新订阅的功能，
/// 因此需要通过在 SDK 初始化的时候创建一个 map，在订阅时将订阅的内容放进这个 map。
/// 在断线重连后，读取 map 内的数据，逐一订阅。
Future _resubscribe() async {
  _isRetry = true;

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

    _isRetry = false;
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
Future wampSubscribe(
  String tableId,
  String eventType,
  Where where,
  Function onInit,
  Function onEvent,
  Function onError,
) async {
  int retryCount = 15; // 重试次数

  /// 订阅实时数据库。
  Future<WampEvent> subscribe() async {
    /// 如果无法成功创建 session，则不再往下执行，直接返回一个空函数
    if (_session == null) {
      return new WampEvent(() {});
    }

    try {
      String topic = _resolveTopic(tableId, eventType);
      SubscribeOptions options = _resolveOptions(where);

      Subscribed subscription = await _session.subscribe(
        topic,
        options: options,
      );
      onInit(); // 订阅成功回调

      /// 订阅成功后，会创建一个唯一的 key（以 tableId、eventType 和 where 判断）。
      /// 之后往 _subscriptionMap 放数据，值为用户传入的订阅条件等内容。
      /// 这样做是为了在断线重连后 SDK 能够自动发起重新订阅，保证连接是持续的。
      String key = {
        'tableId': tableId,
        'eventType': eventType,
        'where': where.get(),
      }.toString();

      _subscriptionMap[key] = {
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
          onEvent(
            new WampCallback(
              Map<String, dynamic>.from(event.argumentsKeywords),
            ),
          );
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

      /// 通过 key 获取 subscriptionId，保证断线重连后能成功取消订阅
      String key = {
        'tableId': tableId,
        'eventType': eventType,
        'where': where.get(),
      }.toString();

      Map found = _subscriptionMap[key];

      if (_session == null || found == null) {
        onError(new HError(602));
        return;
      }

      try {
        await _session.unsubscribe(found['subscriptionId']);
        onSuccess();
        _subscriptionMap.remove(key); // 取消订阅后，将订阅内容从 map 中销毁
        // 如果 map 为空，再销毁 session 和 client
        if (_subscriptionMap.isEmpty) {
          _disconnect();
        }
      } catch (e) {
        onError(errorify(abort: new Abort('Unsubscribe failed.')));
      }
    }

    return new WampEvent(unsubscribe);
  }

  if (!_validateWhereOptions(where)) {
    onError(new HError(616));
    return subscribe;
  }

  // 初始化 Client
  if (_client == null || _isRetry == true) {
    _client = await createWampClient();
  }

  /// 初始化 Session
  if (_session == null || _isRetry == true) {
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

        /// 这里往下还可以判断，如果 retry 次数用完，直接抛错给开发者。
        /// 由于目前还不能测试到一直断线重连的情况，这里先暂时搁置。
      });
    } on Abort catch (abort) {
      onError(errorify(abort: abort)); // 订阅失败回调
    }
  }

  return subscribe;
}
