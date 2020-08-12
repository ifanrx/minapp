import 'package:dio/dio.dart';
import 'base_record.dart';
import 'request.dart';
import 'constants.dart';
import 'query.dart';

class TableRecord extends BaseRecord {
  String tableName;
  String recordId;
  Query query;

  TableRecord({this.tableName, this.recordId, this.query});

  /// 保存数据记录
  Future<dynamic> save() async {
    Map<String, dynamic> data = this.record['\$set'];

    print('saving data: $data');

    Response response = await request(
      path: Api.createRecord,
      method: 'POST',
      params: {'tableID': tableName},
      data: data,
    );

    return response.data;
  }

  /// 更新数据记录
  Future<dynamic> update({
    bool enableTrigger = true,
    bool withCount = false,
  }) async {
    Map data = this.record;

    print('saving data: $data');

    if (recordId != null) {
      Response response = await request(
        path: Api.updateRecord,
        method: 'PUT',
        params: {'tableID': tableName, 'recordID': recordId},
        data: data,
      );

      return response.data;
    } else {
      Map<String, dynamic> queryData = query.get();

      Response response = await request(
        path: Api.updateRecordList,
        method: 'PUT',
        params: {
          'tableID': tableName,
          'recordID': recordId,
          'limit': queryData['limit'] ?? '',
          'offset': queryData['offset'] ?? 0,
          'where': queryData['where'] ?? '',
          'enable_trigger': enableTrigger ? 1 : 0,
          'return_total_count': withCount ? 1 : 0,
        },
        data: data,
      );

      return response.data;
    }
  }
}
