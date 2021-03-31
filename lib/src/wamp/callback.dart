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

class WampSubscription {
  WampSubscriber subscribe;
  WampSubscription(this.subscribe);
}

class WampSubscriber {
  Function unsubscribe;
  WampSubscriber(this.unsubscribe);
}
