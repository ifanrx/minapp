import 'package:dio/dio.dart';
import 'base_record.dart';
import 'request.dart';
import 'constants.dart';

class TableRecord extends BaseRecord {
  String tableName;

  TableRecord({this.tableName});

  Future<dynamic> save() async {
    print('data: ${this.record['\$set']}');
    Map<String, dynamic> data = this.record['\$set'];

    print('saving data: $data');

    Response response = await request(
      path: Api.createRecord,
      method: 'POST',
      params: {'tableID': tableName},
      data: data,
    );

    print('res data: ${response.data}');

    return response.data;
  }
}
