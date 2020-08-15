import 'package:dio/dio.dart';
import 'base_record.dart';
import 'request.dart';
import 'constants.dart';
import 'query.dart';

class TableRecord extends BaseRecord {
  String _tableName;
  String _recordId;
  Query _query;

  TableRecord(String tableName, {String recordId, Query query}) {
    _tableName = tableName;
    _recordId = recordId;
    _query = query;
  }

  String get recordId => _recordId;

  /// 保存数据记录
  Future<dynamic> save() async {
    Map<String, dynamic> data = this.record['\$set'];

    Response response = await request(
      path: Api.createRecord,
      method: 'POST',
      params: {'tableID': _tableName},
      data: data,
    );

    return response;
  }

  /// 更新数据记录
  Future<dynamic> update({
    bool enableTrigger = true,
    bool withCount = false,
  }) async {
    Map data = this.record;

    if (_recordId != null) {
      Response response = await request(
        path: Api.updateRecord,
        method: 'PUT',
        params: {'tableID': _tableName, 'recordID': _recordId},
        data: data,
      );

      return response;
    } else {
      Map<String, dynamic> queryData = _query.get();

      Response response = await request(
        path: Api.updateRecordList,
        method: 'PUT',
        params: {
          'tableID': _tableName,
          'limit': queryData['limit'] ?? '',
          'offset': queryData['offset'] ?? 0,
          'where': queryData['where'] ?? '',
          'enable_trigger': enableTrigger ? 1 : 0,
          'return_total_count': withCount ? 1 : 0,
        },
        data: data,
      );

      return response;
    }
  }
}
