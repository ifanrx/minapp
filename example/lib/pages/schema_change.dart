import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart';
import 'dart:math';
import 'dart:convert';
import 'common.dart';

Map<String, dynamic> object = {
  'a': 'b',
  'c': ['d', 'array', 'dog'],
  'f': {'f': 123.44}
};

class ValueGenerator {
  String string() {
    var random = Random.secure();
    var values = List<int>.generate(6, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  int integer() => new Random().nextInt(100);
  double number() => new Random().nextDouble();
  bool boolean() => new Random().nextBool();
  List<String> arrayString() => [this.string(), this.string()];
  List<int> arrayInteger() => [this.integer(), this.integer()];
  List<double> arrayNumber() => [this.number(), this.number()];
  List<bool> arrayBoolean() => [this.boolean(), this.boolean()];
  String date() => DateTime.now().toIso8601String();
  GeoPolygon polygon() => new GeoPolygon(coordinates: [
        [10.123, 10],
        [20.12453, 10],
        [30.564654, 20],
        [20.654, 30],
        [10.123, 10],
      ]);
  GeoPoint point() => new GeoPoint(longitude: 10.123, latitude: 8.543);
}

class SchemaChange extends StatefulWidget {
  @override
  _SchemaChangeState createState() => _SchemaChangeState();
}

class _SchemaChangeState extends State<SchemaChange> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    var snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget customButton({
    Function fn,
    String title,
    Color titleColor = Colors.white,
    Color bgColor = Colors.green,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 10),
        ButtonTheme(
          height: 50.0,
          child: RaisedButton(
            onPressed: fn,
            child: Text(
              title,
              style: TextStyle(color: titleColor, fontSize: 18.0),
            ),
            color: bgColor,
          ),
        ),
      ],
    );
  }

  void createRecordA() async {
    ValueGenerator valueGenerator = new ValueGenerator();

    TableObject tableObject = new TableObject(tableName: 'auto_maintable');
    TableRecord tableRecord = tableObject.create();

    Map<String, dynamic> options = {
      'str': valueGenerator.string(),
      'int': valueGenerator.integer(),
      'num': valueGenerator.number(),
      'boo': valueGenerator.boolean(),
      'array_i': valueGenerator.arrayInteger(),
      'array_n': valueGenerator.arrayNumber(),
      'array_b': valueGenerator.arrayBoolean(),
      'array_s': valueGenerator.arrayString(),
      'date': valueGenerator.date(),
      'geo_polygon': valueGenerator.polygon().geoJSON,
      'geo_point': valueGenerator.point().geoJSON,
      'obj': object,
    };

    print('options: $options');
    tableRecord.set(options);
    try {
      await tableRecord.save();
      _showSnackBar('创建成功');
    } on HError catch (e) {
      _showSnackBar('创建失败: ${e.toString()}');
    }
  }

  void createRecordB() async {
    ValueGenerator valueGenerator = new ValueGenerator();

    TableObject tableObject = new TableObject(tableName: 'auto_maintable');
    TableRecord tableRecord = tableObject.create();

    Map<String, dynamic> options = {
      'str': valueGenerator.string(),
      'int': valueGenerator.integer(),
      'num': valueGenerator.number(),
      'boo': valueGenerator.boolean(),
      'array_i': valueGenerator.arrayInteger(),
      'array_n': valueGenerator.arrayNumber(),
      'array_b': valueGenerator.arrayBoolean(),
      'array_s': valueGenerator.arrayString(),
      'date': valueGenerator.date(),
      'geo_polygon': valueGenerator.polygon().geoJSON,
      'geo_point': valueGenerator.point().geoJSON,
      'obj': object,
    };

    tableRecord.set('str', options['str']);
    tableRecord.set('int', options['int']);
    tableRecord.set('num', options['num']);
    tableRecord.set('boo', options['boo']);
    tableRecord.set('array_i', options['array_i']);
    tableRecord.set('array_n', options['array_n']);
    tableRecord.set('array_b', options['array_b']);
    tableRecord.set('array_s', options['array_s']);
    tableRecord.set('date', options['date']);
    tableRecord.set('geo_point', options['geo_point']);
    tableRecord.set('geo_polygon', options['geo_polygon']);
    tableRecord.set('obj', options['obj']);

    try {
      await tableRecord.save();
      _showSnackBar('创建成功');
    } on HError catch (e) {
      _showSnackBar('创建失败: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Schema 增删改测试')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('请先创建一条记录，再进行下一步操作',
                  style: TextStyle(color: Colors.red, fontSize: 16.0)),
              customButton(
                fn: createRecordA,
                title: '添加记录（整体 set）',
              ),
              customButton(
                fn: createRecordB,
                title: '添加记录（单独 set）',
              ),
              customButton(
                fn: null,
                title: '删除记录',
              ),
              SizedBox(height: 10),
              Text('更新字段 -- pointer', style: TextStyle(fontSize: 16.0)),
              customButton(
                fn: () {},
                title: 'updatePointer',
              ),
              SizedBox(height: 10),
              Text('更新字段 -- int', style: TextStyle(fontSize: 16.0)),
              customButton(
                fn: () {},
                title: 'int = 100',
              ),
              customButton(
                fn: () {},
                title: 'int = 1',
              ),
              customButton(
                fn: () {},
                title: 'int += 1',
              ),
              SizedBox(height: 10),
              Text('更新字段 -- array_int[]', style: TextStyle(fontSize: 16.0)),
              customButton(
                fn: () {},
                title: 'add[123, 456]',
              ),
              customButton(
                fn: () {},
                title: 'add 123456',
              ),
              customButton(
                fn: () {},
                title: 'remove []',
              ),
              customButton(
                fn: () {},
                title: 'remove',
              ),
              SizedBox(height: 10),
              Text('更新字段 -- obj.num', style: TextStyle(fontSize: 16.0)),
              customButton(
                fn: () {},
                title: 'pathObject',
              ),
              SizedBox(height: 10),
              Text('更新字段 -- unset', style: TextStyle(fontSize: 16.0)),
              customButton(
                fn: () {},
                title: 'unset obj',
              ),
              customButton(
                fn: () {},
                title: 'unset str',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
