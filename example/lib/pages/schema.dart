import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart';
import 'dart:convert';

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

    String now = DateTime.now().toIso8601String();
    // print(now.toIso8601String());

    tableRecord.set('date', now);

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
