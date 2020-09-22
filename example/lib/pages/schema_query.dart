import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../util.dart';
import '../components/num_stepper.dart';
import '../components/custom_button.dart';
import '../components/custom_title.dart';
import '../common/data.dart';
import './common.dart';

Map<String, dynamic> pointerIds = getPointerIds();

class SchemaQuery extends StatefulWidget {
  @override
  _SchemaQueryState createState() => _SchemaQueryState();
}

class _SchemaQueryState extends State<SchemaQuery> {
  bool _isLoading = false;
  List _records = [];
  String _orderBy;
  int _offset = 0;
  int _limit = 10;
  String sortKey = '';
  TableObject product = new TableObject('auto_maintable');
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    var snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void showLoading(bool isLoading) {
    setState(() => _isLoading = isLoading);
  }

  void getAllProduct() async {
    showLoading(true);

    try {
      TableRecordList recordList =
          await product.find(query: new Query(), withCount: true);
      setState(() => _records = recordList.records);
      alert(context, '查询成功 - 总记录数为：${recordList.total_count}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void getProduct() async {
    if (_records.length == 0) return;
    showLoading(true);
    try {
      TableRecord record = await product.get(_records[0].id);
      alert(context, '查询成功 - ID 为：${record.recordInfo['id']}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void getProductBySelectASC() async {
    if (_records.length == 0) return;
    showLoading(true);
    try {
      List<String> select = ['str'];
      TableRecord record = await product.get(_records[0].id, select: select);
      alert(context, '查询成功 - str: ${record.recordInfo['str']}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }
    showLoading(false);
  }

  void getProductBySelectDESC() async {
    if (_records.length == 0) return;
    showLoading(true);
    try {
      List<String> select = ['-str', '-array_i'];
      TableRecord record = await product.get(_records[0].id, select: select);
      List<String> keys = [];
      record.recordInfo.forEach((key, value) => keys.add(key));
      alert(context, 'All keys: $keys');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }
    showLoading(false);
  }

  Function compareQuery(String operator) {
    return () async {
      showLoading(true);

      try {
        Query query = new Query();
        Where where = Where.compare('int', operator, 50);
        query.where(where);
        TableRecordList recordList = await product.find(query: query, withCount: true);
        alert(context, '查询成功 - 记录数: ${recordList.total_count}');
      } catch (e) {
        _showSnackBar('失败 - ${e.toString()}');
      }
      showLoading(false);
    };
  }

  void containsQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = Where.contains('str', 'm');
      query.where(where);
      TableRecordList recordList = await product.find(query: query, withCount: true);
      alert(context, '查询成功 - 记录数: ${recordList.total_count}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void regxQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      RegExp regExp = RegExp(r'/^q/i');
      Where where = Where.matches('str', regExp);
      query.where(where);
      TableRecordList recordList = await product.find(query: query, withCount: true);
      alert(context, '查询成功 - 记录数: ${recordList.total_count}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void inQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = Where.inList('array_s', ['黑', '白']);
      query.where(where);
      TableRecordList recordList = await product.find(query: query, withCount: true);
      alert(context, '查询成功 - 记录数: ${recordList.total_count}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void notInQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = Where.notInList('array_s', ['灰']);
      query.where(where);
      TableRecordList recordList = await product.find(query: query, withCount: true);
      alert(context, '查询成功 - 记录数: ${recordList.total_count}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void arrayContainsQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = Where.arrayContains('array_s', ['黑', '白', '灰']);
      query.where(where);
      TableRecordList recordList = await product.find(query: query, withCount: true);
      alert(context, '查询成功 - 记录数: ${recordList.total_count}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void compareSpecificQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = Where.compare('array_s', '=', ['a', 'b', 'c', 'd']);
      query.where(where);
      TableRecordList recordList = await product.find(query: query, withCount: true);
      alert(context, '查询成功 - 记录数: ${recordList.total_count}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void nullQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = Where.isNull('int');
      query.where(where);
      TableRecordList recordList = await product.find(query: query, withCount: true);
      alert(context, '查询成功 - 记录数: ${recordList.total_count}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void notNullQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = Where.isNotNull('int');
      query.where(where);
      TableRecordList recordList = await product.find(query: query, withCount: true);
      alert(context, '查询成功 - 记录数: ${recordList.total_count}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void existsQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = Where.exists(['str', 'int']);
      query.where(where);
      TableRecordList recordList = await product.find(query: query, withCount: true);
      alert(context, '查询成功 - 记录数: ${recordList.total_count}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void notExistsQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = Where.notExists('int');
      query.where(where);
      TableRecordList recordList = await product.find(query: query, withCount: true);
      alert(context, '查询成功 - 记录数: ${recordList.total_count}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void complexQueryProduct() async {
    showLoading(true);

    try {
      Where where1 = Where.compare('int', '>', 50);

      Where where2 = Where.isNotNull('str');

      Where andWhere = Where.and([where1, where2]);

      Where where3 = Where.inList('array_s', ['黑']);

      Query orQuery = new Query();
      Where orWhere = Where.or([andWhere, where3]);
      orQuery.where(orWhere);

      TableRecordList recordList = await product.find(query: orQuery, withCount: true);
      alert(context, '查询成功 - 记录数: ${recordList.total_count}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void changeOrderBy(String value) {
    setState(() {
      _orderBy = value;
    });
  }

  void getAllProductWithOptions() async {
    showLoading(true);

    try {
      Query query = new Query();
      query
        ..limit(_limit)
        ..offset(_offset);
      if (_orderBy != null) {
        query.orderBy(_orderBy);
      }
      TableRecordList recordList = await product.find(query: query, withCount: true);
      print(recordList.records.length);
      setState(() => _records = recordList.records);
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void selectQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      query.select(['num']);
      TableRecordList recordList = await product.find(query: query, withCount: true);
      var result = recordList.records.map((item) {
        Map map = {};
        item.recordInfo.forEach((k, v) => map[k] = v);
        return map;
      }).toList();
      alert(context, '$result');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void unselectQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      query.select(['-array_s', '-str', '-file']);
      TableRecordList recordList = await product.find(query: query, withCount: true);
      var result = recordList.records.map((item) {
        Map map = {};
        item.recordInfo.forEach((k, v) => map[k] = v);
        return map;
      }).toList();
      alert(context, '$result');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  Function expandCreatedBy([String field]) {
    return () async {
      showLoading(true);

      try {
        Query query = new Query();
        query.expand('created_by');
        if (field != null) {
          query.select(field);
        }
        TableRecordList recordList = await product.find(query: query, withCount: true);
        alert(context, 'created_by: ${recordList.records[0].recordInfo['created_by']}');
      } catch (e) {
        _showSnackBar('失败 - ${e.toString()}');
      }

      showLoading(false);
    };
  }

  void getAllProductWithExpand() async {
    showLoading(true);

    try {
      Query query = new Query();
      query.expand(['pointer_userprofile', 'pointer_test_order']);
      TableRecordList recordList = await product.find(query: query, withCount: true);
      setState(() => _records = recordList.records);
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void getExpand() async {
    if (_records.length == 0) return;
    showLoading(true);

    try {
      List<String> expand = ['created_by'];
      TableRecord record = await product.get(_records[0].id, expand: expand);
      alert(context, 'created by: ${record.recordInfo['created_by']}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void queryByTime() async {
    showLoading(true);

    try {
      Query query = new Query();
      int startTimeStamp =
          new DateTime(1970, 1, 19, 19, 48).millisecondsSinceEpoch;
      int endTimeStamp = startTimeStamp + 24 * 60 * 60;
      Where where1 = Where.compare('created_at', '>=', 1597939200);
      Where where2 = Where.compare('created_at', '<', 1598025600);
      Where andWhere = Where.and([where1, where2]);
      query.where(andWhere);

      TableRecordList recordList = await product.find(query: query, withCount: true);
      alert(context, '查询成功-总记录数为：${recordList.total_count}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void queryByDate() async {
    showLoading(true);

    try {
      Query query = new Query();
      String time = new DateTime(2017, 12, 31, 16).toIso8601String();
      Where where = Where.compare('date', '<=', time);
      query.where(where);
      TableRecordList recordList = await product.find(query: query, withCount: true);
      alert(context, '查询成功-总记录数为：${recordList.total_count}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void hasKey() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = Where.hasKey('obj', 'num');
      query.where(where);
      TableRecordList recordList = await product.find(query: query, withCount: true);
      alert(context, '查询成功-总记录数为：${recordList.total_count}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void countItem() async {
    showLoading(true);

    try {
      Query query = new Query();
      int count = await product.count(query: query);
      alert(context, '$count');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  Function pointerQuery(String type) {
    return () async {
      showLoading(true);

      try {
        Query query = new Query();
        Where where;

        if (type == 'exist') {
          where = Where.exists('pointer_test_order');
        } else if (type == 'compare') {
          where = Where.compare(
              'pointer_test_order',
              '=',
              new TableObject('pointer_test_order').getWithoutData(
                  recordId: pointerIds['pointer_test_order_id']));
        } else if (type == 'in') {
          TableObject order = new TableObject('pointer_test_order');
          where = Where.inList('pointer_test_order', [
            order.getWithoutData(recordId: pointerIds['pointer_test_order_id']),
            order.getWithoutData(
                recordId: pointerIds['pointer_test_order_id2']),
          ]);
        } else if (type == 'notIn') {
          TableObject order = new TableObject('pointer_test_order');
          where = Where.notInList('pointer_test_order', [
            order.getWithoutData(recordId: pointerIds['pointer_test_order_id']),
            order.getWithoutData(recordId: 'fakeid123'),
          ]);
        }

        query
          ..where(where)
          ..expand('pointer_test_order');
        TableRecordList recordList = await product.find(query: query, withCount: true);
        alert(context, '${recordList.records}');
      } catch (e) {
        _showSnackBar('失败 - ${e.toString()}');
      }

      showLoading(false);
    };
  }

  void handleResetData() async {
    await deleteAllRecords();
    createRecords();
  }

  void createRecords() async {
    try {
      await product.createMany(mockData);
      alert(context, '重置成功');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }
  }

  Future<void> deleteAllRecords() async {
    Query query = new Query();
    query.limit(1000);
    query.offset(0);
    Future<void> deleteRecord() async {
      try {
        Map<String, dynamic> res = await product.delete(query: query);
        if (res['next'] != null) {
          await deleteRecord();
        }
      } catch (e) {
        _showSnackBar('失败 - ${e.toString()}');
      }
    }

    await deleteRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Schema 查找测试'),
      ),
      body: LoadingOverlay(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '重置数据',
                  style: TextStyle(color: Colors.red, fontSize: 16.0),
                ),
                CustomButton(handleResetData, title: '重置'),
                CustomTitle('get 查询'),
                CustomButton(getAllProduct, title: '获取所有产品(9)'),
                CustomButton(
                  _records.length == 0 ? null : getProduct,
                  title: '获取一个产品',
                ),
                CustomButton(
                  _records.length == 0 ? null : getProductBySelectASC,
                  title: '获取一个产品返回字段\'str\'',
                ),
                CustomButton(
                  _records.length == 0 ? null : getProductBySelectDESC,
                  title: '获取一个产品不返回字段\'str\'',
                ),
                CustomTitle('compare 查询'),
                CustomButton(
                  compareQuery('='),
                  title: 'compare 查询(int = 50)(1)',
                ),
                CustomButton(
                  compareQuery('!='),
                  title: 'compare 查询(int != 50)(8)',
                ),
                CustomButton(
                  compareQuery('>'),
                  title: 'compare 查询(int > 50)(3)',
                ),
                CustomButton(
                  compareQuery('>='),
                  title: 'compare 查询(int >= 50)(4)',
                ),
                CustomButton(
                  compareQuery('<'),
                  title: 'compare 查询(int < 50)(4)',
                ),
                CustomButton(
                  compareQuery('<='),
                  title: 'compare 查询(int <= 50)(5)',
                ),
                CustomTitle('字符串查询'),
                CustomButton(
                  containsQuery,
                  title: '字符串 contains \'m\' 查询(2)',
                ),
                CustomButton(
                  regxQuery,
                  title: '字符串正则查询 - 构造函数(4)',
                ),
                CustomTitle('数组查询'),
                CustomButton(inQuery, title: '数组 in 查询(4)'),
                CustomButton(notInQuery, title: '数组 notIn 查询(6)'),
                CustomButton(
                  arrayContainsQuery,
                  title: '数组 arrayContains 查询(1)',
                ),
                CustomButton(compareSpecificQuery, title: '数组指定值查询(1)'),
                CustomTitle('null 查询'),
                CustomButton(nullQuery, title: 'null 查询(1)'),
                CustomButton(notNullQuery, title: 'not null 查询(8)'),
                CustomTitle('exists 查询'),
                CustomButton(existsQuery, title: 'exists 查询(9)'),
                CustomButton(notExistsQuery, title: 'notExists 查询(0)'),
                CustomTitle('多条件查询'),
                CustomButton(complexQueryProduct, title: '多条件查询 and / or(5)'),
                CustomTitle('分页与排序'),
                CustomTitle('order_by:',
                    textColor: Colors.black, boxHeight: 5.0),
                Row(
                  children: [
                    Radio(
                      value: 'num',
                      groupValue: _orderBy,
                      onChanged: (value) {
                        changeOrderBy(value);
                      },
                    ),
                    Text(
                      'num',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Radio(
                      value: '-num',
                      groupValue: _orderBy,
                      onChanged: (value) {
                        changeOrderBy(value);
                      },
                    ),
                    Text(
                      '-num',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Radio(
                      value: 'str',
                      groupValue: _orderBy,
                      onChanged: (value) {
                        changeOrderBy(value);
                      },
                    ),
                    Text(
                      'str',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Radio(
                      value: '-str',
                      groupValue: _orderBy,
                      onChanged: (value) {
                        changeOrderBy(value);
                      },
                    ),
                    Text(
                      '-str',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                CustomTitle('limit:', textColor: Colors.black, boxHeight: 5.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NumberStepper(
                    count: _limit,
                    size: 30,
                    activeForegroundColor: Colors.white,
                    activeBackgroundColor: Colors.green,
                    didChangeCount: (count) {
                      setState(() {
                        _limit = count;
                      });
                    },
                  ),
                ),
                CustomTitle('offset:', textColor: Colors.black, boxHeight: 5.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NumberStepper(
                    count: _offset,
                    size: 30,
                    activeForegroundColor: Colors.white,
                    activeBackgroundColor: Colors.green,
                    didChangeCount: (count) {
                      setState(() {
                        _offset = count;
                      });
                    },
                  ),
                ),
                CustomButton(getAllProductWithOptions, title: '查找'),
                ConstrainedBox(
                  constraints: new BoxConstraints(
                    maxHeight: 260.0,
                  ),
                  child: Scrollbar(
                    child: ListView(
                      shrinkWrap: true,
                      children: _records.map((record) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'num: ${record.recordInfo['num']}, str: ${record.recordInfo['str']}'),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                CustomTitle('字段过滤与扩展', boxHeight: 20.0),
                CustomButton(selectQuery, title: '返回指定字段[num]'),
                CustomButton(unselectQuery,
                    title: '不返回指定字段 [-array_s, -str, -file]'),
                CustomButton(expandCreatedBy(), title: 'expand created_by'),
                CustomButton(
                  expandCreatedBy('created_by.nickname'),
                  title: 'expand created_by.nickname',
                ),
                CustomButton(getAllProductWithExpand,
                    title: '获取所有产品(expand pointer)'),
                CustomButton(
                  _records.length == 0 ? null : getExpand,
                  title: 'tableObject get expand',
                ),
                CustomTitle('时间类型字段查询'),
                CustomButton(queryByTime, title: 'created_at 查询'),
                CustomButton(queryByDate, title: 'date 查询'),
                CustomTitle('hasKey 查询'),
                CustomButton(hasKey, title: 'hasKey "num" 查询'),
                CustomTitle('count 查询'),
                CustomButton(countItem, title: 'count 查询'),
                CustomTitle('pointer 查询'),
                CustomButton(pointerQuery('exist'), title: 'pointer 查询 exist'),
                CustomButton(pointerQuery('compare'),
                    title: 'pointer 查询 compare'),
                CustomButton(pointerQuery('in'), title: 'pointer 查询 in'),
                CustomButton(pointerQuery('notIn'), title: 'pointer 查询 not in'),
              ],
            ),
          ),
        ),
        isLoading: _isLoading,
      ),
    );
  }
}
