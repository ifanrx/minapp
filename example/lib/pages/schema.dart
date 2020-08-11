import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart' as BaaS;
import 'schema_change.dart';

class SchemaPage extends StatefulWidget {
  @override
  _SchemaPageState createState() => _SchemaPageState();
}

class _SchemaPageState extends State<SchemaPage> {
  List cardList = [
    {'key': 'manipulate', 'title': 'Schema 增删改测试', 'page': SchemaChange()},
    {'key': 'search', 'title': 'Schema 查找测试'},
    {'key': 'geo', 'title': 'Schema Geo 类型测试'},
    {'key': 'batch', 'title': 'Schema 批量操作测试'},
  ];

  @override
  void initState() {
    super.initState();
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
