import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart';
import 'dart:math';
import 'dart:convert';
import '../util.dart';

Map<String, dynamic> object = {
  'a': 'b',
  'c': ['d', 'array', 'dog'],
  'f': {'f': 123.44}
};

Map<String, dynamic> pointerIds = getPointerIds();

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
  GeoPoint point() => new GeoPoint(10.123, 8.543);
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

  TableObject tableObject = new TableObject('auto_maintable');
  ValueGenerator valueGenerator = new ValueGenerator();
  Map<String, dynamic> record;

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
      'pointer_test_order': new TableObject('test_order')
          .getWithoutData(recordId: pointerIds['pointer_test_order_id']),
      'array_obj': [object, object],
      'array_geo': [valueGenerator.point(), valueGenerator.polygon()],
    };

    tableRecord.set(options);
    try {
      TableRecord _record = await tableRecord.save();
      print(_record.createdAt);
      setState(() => record = _record.recordInfo);
      _showSnackBar('创建成功');
    } on HError catch (e) {
      _showSnackBar('创建失败: ${e.toString()}');
    }
  }

  void createRecordB() async {
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
      'pointer_test_order': new TableObject('test_order')
          .getWithoutData(recordId: pointerIds['pointer_test_order_id']),
      'array_obj': [object, object],
      'array_geo': [valueGenerator.point(), valueGenerator.polygon()],
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
    tableRecord.set('pointer_test_order', options['pointer_test_order']);
    tableRecord.set('array_obj', options['array_obj']);
    tableRecord.set('array_geo', options['array_geo']);

    try {
      TableRecord _record = await tableRecord.save();
      setState(() => record = _record.recordInfo);
      _showSnackBar('创建成功');
    } on HError catch (e) {
      _showSnackBar('创建失败: ${e.toString()}');
    }
  }

  void deleteRecord() async {
    try {
      await tableObject.delete(recordId: record['id']);
      setState(() => record = null);
      _showSnackBar('成功');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }
  }

  void updatePointer() async {
    // 获取一个 tableRecord 实例
    TableObject order = new TableObject('test_order');
    TableRecord orderRecord =
        order.getWithoutData(recordId: pointerIds['pointer_test_order_id2']);

    // 创建一行数据
    TableRecord product = tableObject.getWithoutData(recordId: record['id']);

    // 给 pointer 字段赋值
    product.set('pointer_test_order', orderRecord);

    try {
      await product.update();
      _showSnackBar('成功');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }
  }

  void updateRecord() async {
    TableRecord tableRecord =
        tableObject.getWithoutData(recordId: record['id']);
    tableRecord.set('int', 100);
    try {
      TableRecord _record = await tableRecord.update();
      setState(() => record = _record.recordInfo);
      _showSnackBar('成功');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }
  }

  void increment(String key, int value) async {
    TableRecord tableRecord =
        tableObject.getWithoutData(recordId: record['id']);
    tableRecord.incrementBy(key, value);
    try {
      TableRecord _record = await tableRecord.update();
      setState(() => record = _record.recordInfo);
      _showSnackBar('成功');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }
  }

  void minusOne() {
    increment('int', -1);
  }

  void plusOne() {
    increment('int', 1);
  }

  Function addNumbersToArray(String key, dynamic value) {
    return () async {
      if (value is! List) {
        value = [value];
      }

      TableRecord tableRecord =
          tableObject.getWithoutData(recordId: record['id']);
      tableRecord.append(key, value);

      try {
        TableRecord _record = await tableRecord.update();
        setState(() => record = _record.recordInfo);
        _showSnackBar('成功');
      } catch (e) {
        _showSnackBar('失败 - ${e.toString()}');
      }
    };
  }

  Function removeNumbersFromArray(String key, dynamic value) {
    return () async {
      List<int> numArray = [];
      if (value is List) {
        numArray.addAll([value[0], value[1]]);
      } else {
        numArray.add(value);
      }

      TableRecord tableRecord =
          tableObject.getWithoutData(recordId: record['id']);
      tableRecord.remove('array_i', numArray);

      try {
        TableRecord _record = await tableRecord.update();
        setState(() => record = _record.recordInfo);
        _showSnackBar('成功');
      } catch (e) {
        _showSnackBar('失败 - ${e.toString()}');
      }
    };
  }

  void patchObject() async {
    TableRecord tableRecord =
        tableObject.getWithoutData(recordId: record['id']);

    tableRecord.patchObject('obj', {'num': valueGenerator.integer()});

    try {
      TableRecord _record = await tableRecord.update();
      setState(() => record = _record.recordInfo);
      _showSnackBar('成功');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }
  }

  void unsetField(TableRecord tableRecord) async {
    try {
      await tableRecord.update();
      setState(() => record = null);
      _showSnackBar('成功');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }
  }

  void unsetObj() {
    TableRecord tableRecord =
        tableObject.getWithoutData(recordId: record['id']);

    num randomNum = valueGenerator.number();
    tableRecord.set('num', randomNum);
    tableRecord.unset('array_obj');
    tableRecord.unset('array_file');
    tableRecord.unset('array_geo');
    unsetField(tableRecord);
  }

  void unsetStr() {
    TableRecord tableRecord =
        tableObject.getWithoutData(recordId: record['id']);

    num randomNum = valueGenerator.number();
    tableRecord.set('num', randomNum);
    tableRecord.unset({
      'array_obj': 'abc',
      'array_file': {'a': 10},
      'array_geo': true,
    });
    unsetField(tableRecord);
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
                fn: record == null ? null : deleteRecord,
                title: '删除记录',
              ),
              SizedBox(height: 10),
              Text('更新字段 -- pointer', style: TextStyle(fontSize: 16.0)),
              customButton(
                fn: record == null ? null : updatePointer,
                title: 'updatePointer',
              ),
              SizedBox(height: 10),
              Text('更新字段 -- int: ${record != null ? record['int'] : ''}',
                  style: TextStyle(fontSize: 16.0)),
              customButton(
                fn: record == null ? null : updateRecord,
                title: 'int = 100',
              ),
              customButton(
                fn: record == null ? null : minusOne,
                title: 'int -= 1',
              ),
              customButton(
                fn: record == null ? null : plusOne,
                title: 'int += 1',
              ),
              SizedBox(height: 10),
              Text(
                  '更新字段 -- array_int[]: ${record != null ? record['array_i'] : ''}',
                  style: TextStyle(fontSize: 16.0)),
              customButton(
                fn: record == null
                    ? null
                    : addNumbersToArray('array_i', [123, 456]),
                title: 'add[123, 456]',
              ),
              customButton(
                fn: record == null
                    ? null
                    : addNumbersToArray('array_i', 123456),
                title: 'add 123456',
              ),
              customButton(
                fn: record == null || record['array_i'].length <= 1
                    ? null
                    : removeNumbersFromArray('array_i',
                        [record['array_i'][0], record['array_i'][1]]),
                title: record != null && record['array_i'].length > 1
                    ? 'remove [${record['array_i'][0]}, ${record['array_i'][1]}]'
                    : 'remove []',
              ),
              customButton(
                fn: record == null || record['array_i'].length == 0
                    ? null
                    : removeNumbersFromArray('array_i', record['array_i'][0]),
                title: record != null && record['array_i'].length > 0
                    ? 'remove ${record['array_i'][0]}'
                    : 'remove',
              ),
              SizedBox(height: 10),
              Text(
                  '更新字段 -- obj.num: ${record != null && record['obj']['num'] != null ? record['obj']['num'] : ''}',
                  style: TextStyle(fontSize: 16.0)),
              customButton(
                fn: record == null ? null : patchObject,
                title: 'pathObject',
              ),
              SizedBox(height: 10),
              Text('更新字段 -- unset', style: TextStyle(fontSize: 16.0)),
              customButton(
                fn: record == null ? null : unsetObj,
                title: 'unset obj',
              ),
              customButton(
                fn: record == null ? null : unsetStr,
                title: 'unset str',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
