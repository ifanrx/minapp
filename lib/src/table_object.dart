import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'table_record.dart';
import 'request.dart';
import 'constants.dart';
import 'h_error.dart';
import 'query.dart';

class TableObject {
  String tableName;
  int tableId;

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
  Future<dynamic> createMany(
      {@required List records, bool enableTrigger = true}) async {
    Response response = await request(
      path: Api.createRecordList,
      method: 'POST',
      params: {'tableID': tableName, 'enable_trigger': enableTrigger ? 1 : 0},
      data: records,
    );

    print('create many res data: ${response.data}');
    return response.data;
  }

  /// 更新数据记录
  /// [recordId] 数据项 id
  /// [query] 查询数据项
  TableRecord getWithoutData({String recordId, Query query}) {
    if (recordId != null) {
      return new TableRecord(tableName: tableName, recordId: recordId);
    } else if (query != null) {
      return new TableRecord(
          tableName: tableName, recordId: recordId, query: query);
    } else {
      throw HError(605);
    }
  }
}
