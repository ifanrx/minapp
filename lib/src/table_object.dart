import 'table_record.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'request.dart';
import 'constants.dart';
import 'h_error.dart';

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

  void createMany({@required List records, bool enableTrigger = true}) async {
    Response response = await request(
      path: Api.createRecordList,
      method: 'POST',
      params: {'tableID': tableName, 'enable_trigger': enableTrigger ? 1 : 0},
      data: records,
    );

    print('create many res data: ${response.data}');
    return response.data;
  }
}
