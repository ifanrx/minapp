import 'package:dio/dio.dart';
import 'table_record.dart';
import 'request.dart';
import 'constants.dart';
import 'h_error.dart';
import 'query.dart';
import 'where.dart';
import 'util.dart';
import 'utils/getLimitationWithEnableTrigger.dart' as constants;

class TableObject {
  String _tableName;
  num _tableId;

  /// 构造函数，接收数据表名的参数（[String] 类型）
  TableObject(String tableName) {
    _tableName = tableName;
  }

  /// 构造函数，接收数据表 id 的参数（num 类型）
  TableObject.withId(num tableId) {
    _tableId = tableId;
  }

  TableRecord create() {
    return new TableRecord(_tableName ?? _tableId);
  }

  /// 创建多条数据
  /// [records] 多条数据项
  /// [enableTrigger] 是否触发触发器
  Future<TableRecordList> createMany(
    List<Map<String, dynamic>> records, {
    bool enableTrigger = true,
  }) async {
    records = records.map((record) {
      record.forEach((key, value) => record[key] = serializeValue(value));
      return record;
    }).toList();

    Response response = await request(
      path: Api.createRecordList,
      method: 'POST',
      params: {'tableID': _tableName, 'enable_trigger': enableTrigger ? 1 : 0},
      data: records,
    );

    return new TableRecordList(response.data);
  }

  /// 更新数据记录
  /// [recordId] 数据项 id
  /// [query] 查询数据项
  TableRecord getWithoutData({String recordId, Query query}) {
    if (recordId != null) {
      return new TableRecord(_tableName, recordId: recordId);
    } else if (query != null) {
      return new TableRecord(
        _tableName,
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
      await request(
        path: Api.deleteRecord,
        method: 'DELETE',
        params: {'tableID': _tableName, 'recordID': recordId},
      );
    } else if (query != null) {
      Map<String, dynamic> queryData = query.get();

      queryData.forEach((key, value) {
        if (value != null) {
          if (value is Where) {
            queryData[key] = value.get();
          } else {
            queryData[key] = value;
          }
        }
      });

      Response response = await request(
        path: Api.deleteRecordList,
        method: 'DELETE',
        params: {
          'tableID': _tableName,
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

    Response response = await request(
      path: Api.getRecord,
      method: 'GET',
      params: {'tableID': _tableName, 'recordID': recordId},
      data: data,
    );

    return new TableRecord.withInfo(response.data);
  }

  /// 获取数据记录列表
  /// [query] 查询条件
  /// [withCount] 是否返回 total_count
  Future<TableRecordList> find(
    Query query, {
    bool withCount = false,
    dynamic select,
    dynamic expand,
  }) async {
    Map<String, dynamic> data = {
      'return_total_count': withCount ? 1 : 0,
    };

    if (query != null) {
      Map<String, dynamic> queryData = query.get();
      queryData.forEach((key, value) {
        if (value != null) {
          if (value is Where) {
            data[key] = value.get();
          } else {
            data[key] = value;
          }
        }
      });
    }

    Response response = await request(
      path: Api.queryRecordList,
      method: 'GET',
      params: {'tableID': _tableName},
      data: data,
    );

    return new TableRecordList(response.data);
  }

  /// 获取数据记录数量
  /// [query] 查询条件
  Future<int> count({Query query}) async {
    query = query != null ? query : new Query();
    query.limit(1);
    TableRecordList response = await find(query, withCount: true);

    int count = response.totalCount;
    return count;
  }
}
