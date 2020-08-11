import 'table_record.dart';

class TableObject {
  String tableName;
  int tableId;

  TableObject({this.tableName, this.tableId});

  TableRecord create() {
    return new TableRecord(tableName: tableName ?? tableId);
  }
}
