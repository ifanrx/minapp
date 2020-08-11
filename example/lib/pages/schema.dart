import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart';

class SchemaPage extends StatefulWidget {
  @override
  _SchemaPageState createState() => _SchemaPageState();
}

class _SchemaPageState extends State<SchemaPage> {
  void setBaseRecord() async {
    TableObject tableObject = new TableObject(tableName: 'jiajun_test');
    TableRecord tableRecord = tableObject.create();
    // tableRecord.set({'num1': 123, 'num2': 123});
    // tableRecord.set('num3', 234);
    // tableRecord.set('num4', 234);

    // String now = DateTime.now().toIso8601String();
    // tableRecord.set('date', now);

    GeoPoint point1 = new GeoPoint(longitude: 10.123, latitude: 10);
    GeoPoint point2 = new GeoPoint(longitude: 20.12453, latitude: 10);
    GeoPoint point3 = new GeoPoint(longitude: 30.564654, latitude: 20);
    GeoPoint point4 = new GeoPoint(longitude: 20.654, latitude: 30);
    GeoPoint point5 = new GeoPoint(longitude: 10.123, latitude: 10);

    GeoPolygon polygon = new GeoPolygon(points: [
      point1,
      point2,
      point3,
      point4,
      point5,
    ]);

    tableRecord.set('geo_polygon', polygon);

    Map obj = {};

    await tableRecord.save();
  }

  @override
  void initState() {
    super.initState();
    setBaseRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('数据表')),
      body: Center(child: Text('数据表')),
    );
  }
}
