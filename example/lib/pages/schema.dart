import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart';
import 'schema_change.dart';
import 'schema_query.dart';
import 'geo.dart';
import 'schema_batch.dart';

class SchemaPage extends StatefulWidget {
  @override
  _SchemaPageState createState() => _SchemaPageState();
}

class _SchemaPageState extends State<SchemaPage> {
  List cardList = [
    {'key': 'manipulate', 'title': 'Schema 增删改测试', 'page': SchemaChange()},
    {'key': 'search', 'title': 'Schema 查找测试', 'page': SchemaQuery()},
    {'key': 'geo', 'title': 'Schema Geo 类型测试', 'page': Geo()},
    {'key': 'batch', 'title': 'Schema 批量操作测试', 'page': SchemaBatch()},
  ];

  void testFn() async {
    TableObject tableObject = new TableObject('jiajun_test');
    // var select = ['pointer'];
    // var expand = ['pointer'];
    // Query query = new Query();
    // Where where = new Where();
    // where.compare('num', '>=', 126);
    // query.where(where).select(select).expand(expand);
    // var a = await tableObject.find(query);
    // print('res: ${a.records}');
    // print('limit: ${a.limit}');

    var select = ['pointer'];
    var expand = ['pointer'];
    Query query = new Query();
    Where where = new Where();
    where.compare('num', '>=', 126);
    query.where(where);
    var a = await tableObject.get('5f3631bb6526327bfa037ae8', select: select);
    print('res: ${a.recordInfo}');

    // TableRecord record =
    //     await tableObject.get('5f3631bb6526327bfa037ae8', expand: 'pointer');
    // TableRecord record = tableObject.create();
    // record.set('num1', 333);
    // var res = await record.save();
    // print('res: $res');

    // TableRecordList recordList = await tableObject.createMany([
    //   {'num1': 123},
    //   {'num1': 234},
    // ]);

    // print(recordList.totalCount);

    // TableRecord tableRecord = tableObject.getWithoutData();

    // Query query = new Query();
    // query.limit(5).offset(0);
    // Where where = new Where();
    // where.compare('num1', '>', 230);
    // query.where(where);
    // await tableObject.delete(query: query);

    // TableRecord res = await tableObject.get('5f3a0064aa5ea70180cf551f');
    // print('res: ${res.id}');
    // print('res: ${res.createdById}');
    // print('res: ${res.createdAt}');
    // print('res: ${res.updatedAt}');

    // Query query = new Query();
    // Where where = new Where();
    // where.compare('num1', '>=', 333);
    // query.where(where);

    // await tableObject.delete(query: query);

    // TableRecord record = tableObject.getWithoutData(query: query);
    // record.incrementBy('num1', 1);
    // TableRecordList records = await record.update(enableTrigger: false);
    // print('records: ${records.records}');

    // Query query = new Query();
    // query.limit(5);
    // TableRecord record = tableObject.getWithoutData(query: query);
    // record.set('num1', 123);
    // record.update();

    // GeoPoint point = new GeoPoint(10, 20);
    // print(point.latitude);

    // var result =
    //     await tableObject.get('5f3632adf0f3b02464872840', expand: 'pointer');
    // print('result: ${result.data['pointer']['str']}');
    // var tableRecord =
    //     await tableObject.get(recordId: '5f33b91bfc8b922a6952dd1c');
    // print('tableRecord: ${tableRecord.data}');

    // Query query = new Query();
    // query.limit(5);
    // Where where = new Where();
    // where.contains('str', 'good');
    // where.compare('num', '>', 1);
    // where.compare('num', '<', 5);
    // RegExp regExp = RegExp(r'/^c/');
    // where.matches('str', regExp);
    // where.arrayContains('arr', ['betty']);
    // where.compare('arr', '=', ['betty', 'alex', 'zhang']);
    // where.notExists(['num']);
    // where.hasKey('obj', 'name');
    // TableObject pointerObject = new TableObject(tableName: 'auto_maintable');
    // where.compare('pointer', '=',
    //     pointerObject.getWithoutData(recordId: '5f363299f0f3b02464872835'));
    // query.expand('pointer');
    // where.exists('pointer');
    // where.inList('pointer', [
    //   pointerObject.getWithoutData(recordId: '5f3631ab6526327aa10373bc'),
    //   pointerObject.getWithoutData(recordId: '5f363299f0f3b02464872835')
    // ]);

    // Where where1 = new Where();
    // where1.compare('num', '>', 100);
    // where1.compare('num', '<', 300);
    // Where where2 = new Where();
    // where2.contains('str', 'good');
    // where.or([where1]);

    // GeoPoint point = new GeoPoint(longitude: 10.123, latitude: 10);
    // GeoPolygon polygon = new GeoPolygon(coordinates: [
    //   [10.123, 10],
    //   [20.12453, 10],
    //   [30.564654, 20],
    //   [20.654, 30],
    //   [10.123, 10],
    // ]);
    // where.within('geo_polygon', polygon);
    // query.where(where);
    // query.expand(['pointer', 'created_by']);
    // var result = await tableObject.get('5ed778dc5764d96c8c0d5a81');
    // print('res: ${result.createdBy}');
    // print('res: ${result.createdById}');
    // print(result.recordInfo);
    // print('result: ${result.data['objects'].length}');
    // result.data['objects'].forEach((elem) => print(elem['str']));

    // int count = await tableObject.count(query: query);
    // print('count: $count');
  }

  @override
  void initState() {
    super.initState();
    testFn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('数据表')),
      body: ListView.builder(
        itemCount: cardList.length,
        itemBuilder: (context, index) {
          Map card = cardList[index];

          return Padding(
            padding: EdgeInsets.all(5),
            child: Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => card['page']));
                },
                title: Text(card['title']),
              ),
            ),
          );
        },
      ),
    );
  }
}
