import 'package:dio/dio.dart';
import 'table_record.dart';
import 'constants.dart';
import 'h_error.dart';
import 'query.dart';
import 'util.dart';
import 'config.dart';
import 'utils/getLimitationWithEnableTrigger.dart' as constants;
import 'wamp/index.dart';
import 'where.dart';

class TableObject {
  String _tableId;

  /// 构造函数，传入数据表名或数据表 id（[String] 类型）
  TableObject(String tableId) {
    _tableId = tableId;
  }

  TableRecord create() {
    return new TableRecord(_tableId);
  }

  /// 创建多条数据
  /// [records] 多条数据项
  /// [enableTrigger] 是否触发触发器
  Future<TableRecordOperationList> createMany(
    List records, {
    bool enableTrigger = true,
  }) async {
    records = records.map((record) {
      record.forEach((key, value) => record[key] = serializeValue(value));
      return record;
    }).toList();

    Response response = await config.request(
      path: Api.createRecordList,
      method: 'POST',
      params: {
        'tableID': _tableId,
        'enable_trigger': enableTrigger ? 1 : 0,
      },
      data: records,
    );

    return new TableRecordOperationList(response.data);
  }

  /// 更新数据记录
  /// [recordId] 数据项 id
  /// [query] 查询数据项
  TableRecord getWithoutData({String recordId, Query query}) {
    if (recordId != null && recordId.trim() != '') {
      return new TableRecord(_tableId, recordId: recordId);
    } else if (query != null) {
      return new TableRecord(
        _tableId,
        query: query,
      );
    } else {
      throw HError(605);
    }
  }

  /// 删除数据记录
  /// [recordId] 数据项 id
  /// 批量删除数据记录
  /// [query] 数据记录查询条件
  /// [enableTrigger] 是否触发触发器
  /// [withCount] 是否返回 total_count
  Future<dynamic> delete({
    String recordId,
    Query query,
    bool enableTrigger = true,
    bool withCount = false,
  }) async {
    if (recordId != null) {
      await config.request(
        path: Api.deleteRecord,
        method: 'DELETE',
        params: {'tableID': _tableId, 'recordID': recordId},
      );
    } else if (query != null) {
      Map<String, dynamic> queryData = query.get();

      Response response = await config.request(
        path: Api.deleteRecordList,
        method: 'DELETE',
        params: {
          'tableID': _tableId,
          'limit': constants.getLimitationWithEnableTrigger(
              queryData['limit'], enableTrigger),
          'offset': queryData['offset'] ?? 0,
          'where': queryData['where'] ?? '',
          'enable_trigger': enableTrigger ? 1 : 0,
          'return_total_count': withCount ? 1 : 0,
        },
      );

      return response.data;
    } else {
      throw HError(605);
    }
  }

  /// 获取单条数据
  /// [recordId] 数据项 id
  Future<TableRecord> get(String recordId,
      {dynamic select, dynamic expand}) async {
    Map<String, dynamic> data = {};

    if (select != null) {
      if (select is String) {
        data['keys'] = select;
      } else if (select is List<String>) {
        data['keys'] = select.join(',');
      } else {
        throw HError(605);
      }
    }

    if (expand != null) {
      if (expand is String) {
        data['expand'] = expand;
      } else if (expand is List<String>) {
        data['expand'] = expand.join(',');
      } else {
        throw HError(605);
      }
    }

    Response response = await config.request(
      path: Api.getRecord,
      method: 'GET',
      params: {'tableID': _tableId, 'recordID': recordId},
      data: data,
    );

    return new TableRecord.withInfo(response.data);
  }

  /// 获取数据记录列表
  /// [query] 查询条件
  /// [withCount] 是否返回 total_count
  Future<TableRecordList> find({
    Query query,
    bool withCount = false,
  }) async {
    Map<String, dynamic> data = query == null ? {} : query.get();
    data['return_total_count'] = withCount ? 1 : 0;

    Response response = await config.request(
      path: Api.queryRecordList,
      method: 'GET',
      params: {'tableID': _tableId},
      data: data,
    );

    return new TableRecordList(response.data);
  }

  /// 获取数据记录数量
  /// [query] 查询条件
  Future<int> count({Query query}) async {
    query = query != null ? query : new Query();
    query.limit(1);
    TableRecordList response = await find(query: query, withCount: true);

    int count = response.total_count;
    return count;
  }

  /// 实时数据库订阅
  /// 接收 [eventType] 必填参数，必须为 create、update 或 delete。
  /// [onInit] 订阅动作初始化成功时的回调函数。
  /// [onEvent] 数据表变化时的回调函数。
  /// [onError] 订阅动作出错时的回调函数。
  Future<dynamic> subscribe(
    String eventType, {
    Where where,
    Function onInit,
    Function onEvent,
    Function onError,
    int retryCount = 15, // 最大重连次数
    int delayTime, // 重连时间间隔
  }) async {
    if (eventType != 'create' &&
        eventType != 'update' &&
        eventType != 'delete') {
      throw HError(605);
    }

    Wamp wamp = new Wamp();
    wamp.subscribe(
      _tableId,
      eventType,
      where != null ? where.get() : '{}',
      onInit ?? () => {},
      onEvent ?? (result) => {},
      onError ?? (erorr) => {},
      retryCount: retryCount,
      delayTime: delayTime,
    );

    return wamp;
  }
}
