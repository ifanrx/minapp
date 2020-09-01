import 'package:dio/dio.dart';
import 'base_record.dart';
import 'constants.dart';
import 'query.dart';
import 'config.dart';
import 'utils/getLimitationWithEnableTrigger.dart' as constants;

class TableRecord extends BaseRecord {
  String _tableName;
  String _recordId;
  Query _query;

  TableRecord(String tableName, {String recordId, Query query}) {
    _tableName = tableName;
    _recordId = recordId;
    _query = query;
  }

  /// 接收服务端返回的数据
  TableRecord.withInfo(Map<String, dynamic> recordInfo)
      : super.withInfo(recordInfo);

  String get recordId => _recordId;

  /// 保存数据记录
  Future<TableRecord> save() async {
    Map<String, dynamic> data = this.record['\$set'];

    Response response = await config.request(
      path: Api.createRecord,
      method: 'POST',
      params: {'tableID': _tableName},
      data: data,
    );

    this.recordValueInit();

    return new TableRecord.withInfo(response.data);
  }

  /// 更新数据记录
  /// [enableTrigger] 是否触发触发器
  /// [withCount] 是否返回 total_count
  Future<dynamic> update({
    bool enableTrigger = true,
    bool withCount = false,
  }) async {
    Map data = this.record;

    if (_recordId != null) {
      Response response = await config.request(
        path: Api.updateRecord,
        method: 'PUT',
        params: {'tableID': _tableName, 'recordID': _recordId},
        data: data,
      );

      this.recordValueInit();

      return new TableRecord.withInfo(response.data);
    } else {
      Map<String, dynamic> queryData = _query.get();

      Response response = await config.request(
        path: Api.updateRecordList,
        method: 'PUT',
        params: {
          'tableID': _tableName,
          'limit': constants.getLimitationWithEnableTrigger(
              queryData['limit'], enableTrigger),
          'offset': queryData['offset'] ?? 0,
          'where': queryData['where'] ?? '',
          'enable_trigger': enableTrigger ? 1 : 0,
          'return_total_count': withCount ? 1 : 0,
        },
        data: data,
      );

      this.recordValueInit();

      return new TableRecordList(response.data);
    }
  }
}

class RecordListMeta {
  int _limit;
  int _offset;
  int _totalCount;
  String _next;
  String _previous;

  int get limit => _limit;
  int get offset => _offset;
  int get totalCount => _totalCount;
  String get next => _next;
  String get previous => _previous;

  RecordListMeta(Map<String, dynamic> recordInfo) {
    Map<String, dynamic> meta = recordInfo['meta'];
    _limit = meta == null ? recordInfo['limit'] : meta['limit'];
    _offset = meta == null ? recordInfo['offset'] : meta['offset'];
    _totalCount =
        meta == null ? recordInfo['total_count'] : meta['total_count'];
    _next = meta == null ? recordInfo['next'] : meta['next'];
    _previous = meta == null ? recordInfo['previous'] : meta['previous'];
  }
}

class TableRecordList extends RecordListMeta {
  Map<String, dynamic> _recordInfo;
  List get records => _recordInfo['meta'] == null
      ? _recordInfo['operation_result']
      : _recordInfo['objects'];

  TableRecordList(this._recordInfo) : super(_recordInfo);
}
