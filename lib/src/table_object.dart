import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'table_record.dart';
import 'request.dart';
import 'constants.dart';
import 'h_error.dart';
import 'query.dart';
import 'base_record.dart';
import 'where.dart';

class TableObject {
  String tableName;
  int tableId;
  Function serializeValue = new BaseRecord().serializeValue;

  TableObject({this.tableName, this.tableId}) {
    if (tableName == null && tableId == null) {
      throw HError(605);
    }
  }

  TableRecord create() {
    return new TableRecord(tableName: tableName ?? tableId);
  }

  /// 创建多条数据
  /// [records] 多条数据项
  /// [enableTrigger] 是否触发触发器
  Future<dynamic> createMany({
    @required List records,
    bool enableTrigger = true,
  }) async {
    records = records.map((record) {
      record.forEach((key, value) => record[key] = serializeValue(value));
      return record;
    }).toList();

    Response response = await request(
      path: Api.createRecordList,
      method: 'POST',
      params: {'tableID': tableName, 'enable_trigger': enableTrigger ? 1 : 0},
      data: records,
    );

    return response;
  }

  /// 更新数据记录
  /// [recordId] 数据项 id
  /// [query] 查询数据项
  TableRecord getWithoutData({String recordId, Query query}) {
    if (recordId != null) {
      return new TableRecord(tableName: tableName, recordId: recordId);
    } else if (query != null) {
      return new TableRecord(
        tableName: tableName,
        recordId: recordId,
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
      Response response = await request(
        path: Api.deleteRecord,
        method: 'DELETE',
        params: {'tableID': tableName, 'recordID': recordId},
      );
      return response;
    } else if (query != null) {
      Map<String, dynamic> queryData = query.get();

      Response response = await request(
        path: Api.deleteRecordList,
        method: 'DELETE',
        params: {
          'tableID': tableName,
          'limit': queryData['limit'] ?? '',
          'offset': queryData['offset'] ?? 0,
          'where': queryData['where'] ?? '',
          'enable_trigger': enableTrigger ? 1 : 0,
          'return_total_count': withCount ? 1 : 0,
        },
      );
      return response;
    } else {
      throw HError(605);
    }
  }

  /// 获取单条数据
  /// [recordId] 数据项 id
  Future<dynamic> get({@required String recordId}) async {
    Response response = await request(
      path: Api.deleteRecord,
      method: 'GET',
      params: {'tableID': tableName, 'recordID': recordId},
    );

    return response;
  }

  /// 获取数据记录列表
  /// [query] 查询条件
  /// [withCount] 是否返回 total_count
  Future<dynamic> find({Query query, bool withCount = false}) async {
    Map<String, dynamic> data = {
      'return_total_count': withCount ? 1 : 0,
    };

    if (query != null) {
      Map<String, dynamic> queryData = query.get();
      print('query get: $queryData');
      queryData.forEach((key, value) {
        if (value != null) {
          if (value is Where) {
            data[key] = value.get();
          } else {
            data[key] = value;
          }
        }
      });

      print('data: $data');
    }

    Response response = await request(
      path: Api.queryRecordList,
      method: 'GET',
      params: {'tableID': tableName},
      data: data,
    );

    return response;
  }

  /// 获取数据记录数量
  /// [query] 查询条件
  Future<int> count({Query query}) async {
    query.limit(1);
    var response = await find(query: query, withCount: true);

    int count = response.data['meta']['total_count'];
    return count;
  }
}
