/// 对接口返回数据进行包装
class WampCallback {
  final Map<String, dynamic> callback;
  Map<String, dynamic> get before => callback['before'];
  Map<String, dynamic> get after => callback['after'];
  String get event => callback['event'];
  int get schema_id => callback['schema_id'];
  String get schema_name => callback['schema_name'];
  String get id => callback['id'];

  WampCallback(this.callback);
}

class WampEvent {
  Function unsubscribe;
  WampEvent(this.unsubscribe);
}
