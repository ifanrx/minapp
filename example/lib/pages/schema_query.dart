import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../util.dart';
import '../components/num_stepper.dart';

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
  int _counter = 10;
  TableObject product = new TableObject('auto_maintable');
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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

  Widget customTitle(
    String title, {
    num boxHeight = 10.0,
    Color textColor = Colors.red,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: boxHeight),
        Text(
          title,
          style: TextStyle(color: textColor, fontSize: 16.0),
        ),
      ],
    );
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    var snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void alert(
    String content, {
    String title = '',
    String confirmText = '确定',
  }) {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text(title),
        content: new Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text(confirmText),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  void showLoading(bool isLoading) {
    setState(() => _isLoading = isLoading);
  }

  void getAllProduct() async {
    showLoading(true);

    try {
      TableRecordList recordList =
          await product.find(new Query(), withCount: true);
      setState(() => _records = recordList.records);
      alert('查询成功 - 总记录数为：${recordList.totalCount}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void getProduct() async {
    if (_records.length == 0) return;
    showLoading(true);
    try {
      TableRecord record = await product.get(_records[0]['id']);
      alert('查询成功 - ID 为：${record.recordInfo['id']}');
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
      TableRecord record = await product.get(_records[0]['id'], select: select);
      alert('查询成功 - str: ${record.recordInfo['str']}');
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
      TableRecord record = await product.get(_records[0]['id'], select: select);
      List<String> keys = [];
      record.recordInfo.forEach((key, value) => keys.add(key));
      alert('All keys: $keys');
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
        Where where = new Where();
        where.compare('int', operator, 50);
        query.where(where);
        TableRecordList recordList = await product.find(query, withCount: true);
        alert('查询成功 - 记录数: ${recordList.totalCount}');
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
      Where where = new Where();
      where.contains('str', 'm');
      query.where(where);
      TableRecordList recordList = await product.find(query, withCount: true);
      alert('查询成功 - 记录数: ${recordList.totalCount}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void regxQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = new Where();
      RegExp regExp = RegExp(r'/^q/i');
      where.matches('str', regExp);
      query.where(where);
      TableRecordList recordList = await product.find(query, withCount: true);
      alert('查询成功 - 记录数: ${recordList.totalCount}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void inQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = new Where();
      where.inList('array_s', ['黑', '白']);
      query.where(where);
      TableRecordList recordList = await product.find(query, withCount: true);
      alert('查询成功 - 记录数: ${recordList.totalCount}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void notInQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = new Where();
      where.notInList('array_s', ['灰']);
      query.where(where);
      TableRecordList recordList = await product.find(query, withCount: true);
      alert('查询成功 - 记录数: ${recordList.totalCount}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void arrayContainsQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = new Where();
      where.arrayContains('array_s', ['黑', '白', '灰']);
      query.where(where);
      TableRecordList recordList = await product.find(query, withCount: true);
      alert('查询成功 - 记录数: ${recordList.totalCount}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void compareSpecificQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = new Where();
      where.compare('array_s', '=', ['a', 'b', 'c', 'd']);
      query.where(where);
      TableRecordList recordList = await product.find(query, withCount: true);
      alert('查询成功 - 记录数: ${recordList.totalCount}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void nullQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = new Where();
      where.isNull('int');
      query.where(where);
      TableRecordList recordList = await product.find(query, withCount: true);
      alert('查询成功 - 记录数: ${recordList.totalCount}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void notNullQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = new Where();
      where.isNotNull('int');
      query.where(where);
      TableRecordList recordList = await product.find(query, withCount: true);
      alert('查询成功 - 记录数: ${recordList.totalCount}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void existsQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = new Where();
      where.exists(['str', 'int']);
      query.where(where);
      TableRecordList recordList = await product.find(query, withCount: true);
      alert('查询成功 - 记录数: ${recordList.totalCount}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void notExistsQuery() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = new Where();
      where.notExists('int');
      query.where(where);
      TableRecordList recordList = await product.find(query, withCount: true);
      alert('查询成功 - 记录数: ${recordList.totalCount}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void complexQueryProduct() async {
    showLoading(true);

    try {
      Where where1 = new Where();
      where1.compare('int', '>', 50);

      Where where2 = new Where();
      where2.isNotNull('str');

      Where andWhere = new Where();
      andWhere.and([where1, where2]);

      Where where3 = new Where();
      where3.inList('array_s', ['黑']);

      Query orQuery = new Query();
      Where orWhere = new Where();
      orWhere.or([andWhere, where3]);
      orQuery.where(orWhere);

      TableRecordList recordList = await product.find(orQuery, withCount: true);
      alert('查询成功 - 记录数: ${recordList.totalCount}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void changeOrderBy(String value) {
    print(value);
    setState(() {
      _orderBy = value;
    });
  }

  void getAllProductWithOptions() async {
    showLoading(true);

    try {
      Query query = new Query();
      query.limit(_limit).offset(_offset);
      if (_orderBy != null) {
        query.orderBy(_orderBy);
      }
      TableRecordList recordList = await product.find(query, withCount: true);
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
      TableRecordList recordList = await product.find(query, withCount: true);
      print(recordList.records.length);
      alert('${recordList.records}');
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
      TableRecordList recordList = await product.find(query, withCount: true);
      print(recordList.records.length);
      alert('${recordList.records}');
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
        TableRecordList recordList = await product.find(query, withCount: true);
        alert('created_by: ${recordList.records[0]['created_by']}');
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
      TableRecordList recordList = await product.find(query, withCount: true);
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
      TableRecord record = await product.get(_records[0]['id'], expand: expand);
      alert('created by: ${record.recordInfo['created_by']}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void queryByTime() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = new Where();
      int startTimeStamp =
          new DateTime(1970, 1, 19, 19, 48).millisecondsSinceEpoch;
      int endTimeStamp = startTimeStamp + 24 * 60 * 60;
      where.compare('created_at', '>=', startTimeStamp);
      where.compare('created_at', '<', endTimeStamp);
      query.where(where);

      TableRecordList recordList = await product.find(query, withCount: true);
      alert('查询成功-总记录数为：${recordList.totalCount}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void queryByDate() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = new Where();
      String time = new DateTime(2017, 12, 31, 16).toIso8601String();
      where.compare('date', '<=', time);
      query.where(where);
      TableRecordList recordList = await product.find(query, withCount: true);
      alert('查询成功-总记录数为：${recordList.totalCount}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void hasKey() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = new Where();
      where.hasKey('obj', 'num');
      query.where(where);
      TableRecordList recordList = await product.find(query, withCount: true);
      alert('查询成功-总记录数为：${recordList.totalCount}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void countItem() async {
    showLoading(true);

    try {
      Query query = new Query();
      int count = await product.count(query);
      alert('$count');
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
        Where where = new Where();

        if (type == 'exist') {
          where.exists('pointer_test_order');
        } else if (type == 'compare') {
          where.compare(
              'pointer_test_order',
              '=',
              new TableObject('pointer_test_order').getWithoutData(
                  recordId: pointerIds['pointer_test_order_id']));
        } else if (type == 'in') {
          TableObject order = new TableObject('pointer_test_order');
          where.inList('pointer_test_order', [
            order.getWithoutData(recordId: pointerIds['pointer_test_order_id']),
            order.getWithoutData(
                recordId: pointerIds['pointer_test_order_id2']),
          ]);
        } else if (type == 'notIn') {
          TableObject order = new TableObject('pointer_test_order');
          where.notInList('pointer_test_order', [
            order.getWithoutData(recordId: pointerIds['pointer_test_order_id']),
            order.getWithoutData(recordId: 'fakeid123'),
          ]);
        }

        query.where(where).expand('pointer_test_order');
        TableRecordList recordList = await product.find(query, withCount: true);
        alert('${recordList.records}');
      } catch (e) {
        _showSnackBar('失败 - ${e.toString()}');
      }

      showLoading(false);
    };
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
                customButton(fn: () {}, title: '重置'),
                customTitle('get 查询'),
                customButton(fn: getAllProduct, title: '获取所有产品(9)'),
                customButton(
                  fn: _records.length == 0 ? null : getProduct,
                  title: '获取一个产品',
                ),
                customButton(
                  fn: _records.length == 0 ? null : getProductBySelectASC,
                  title: '获取一个产品返回字段\'str\'',
                ),
                customButton(
                  fn: _records.length == 0 ? null : getProductBySelectDESC,
                  title: '获取一个产品不返回字段\'str\'',
                ),
                customTitle('compare 查询'),
                customButton(
                  fn: compareQuery('='),
                  title: 'compare 查询(int = 50)(1)',
                ),
                customButton(
                  fn: compareQuery('!='),
                  title: 'compare 查询(int != 50)(8)',
                ),
                customButton(
                  fn: compareQuery('>'),
                  title: 'compare 查询(int > 50)(3)',
                ),
                customButton(
                  fn: compareQuery('>='),
                  title: 'compare 查询(int >= 50)(4)',
                ),
                customButton(
                  fn: compareQuery('<'),
                  title: 'compare 查询(int < 50)(4)',
                ),
                customButton(
                  fn: compareQuery('<='),
                  title: 'compare 查询(int <= 50)(5)',
                ),
                customTitle('字符串查询'),
                customButton(
                  fn: containsQuery,
                  title: '字符串 contains \'m\' 查询(2)',
                ),
                customButton(
                  fn: regxQuery,
                  title: '字符串正则查询 - 构造函数(4)',
                ),
                customTitle('数组查询'),
                customButton(fn: inQuery, title: '数组 in 查询(4)'),
                customButton(fn: notInQuery, title: '数组 notIn 查询(6)'),
                customButton(
                  fn: arrayContainsQuery,
                  title: '数组 arrayContains 查询(1)',
                ),
                customButton(fn: compareSpecificQuery, title: '数组指定值查询(1)'),
                customTitle('null 查询'),
                customButton(fn: nullQuery, title: 'null 查询(1)'),
                customButton(fn: notNullQuery, title: 'not null 查询(8)'),
                customTitle('exists 查询'),
                customButton(fn: existsQuery, title: 'exists 查询(9)'),
                customButton(fn: notExistsQuery, title: 'notExists 查询(0)'),
                customTitle('多条件查询'),
                customButton(
                    fn: complexQueryProduct, title: '多条件查询 and / or(5)'),
                customTitle('分页与排序'),
                customTitle('order_by:',
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
                customTitle('limit:', textColor: Colors.black, boxHeight: 5.0),
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
                customTitle('offset:', textColor: Colors.black, boxHeight: 5.0),
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
                customButton(fn: getAllProductWithOptions, title: '查找'),
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
                              'num: ${record['num']}, str: ${record['str']}'),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                customTitle('字段过滤与扩展', boxHeight: 20.0),
                customButton(fn: selectQuery, title: '返回指定字段[num]'),
                customButton(
                    fn: unselectQuery,
                    title: '不返回指定字段 [-array_s, -str, -file]'),
                customButton(fn: expandCreatedBy(), title: 'expand created_by'),
                customButton(
                  fn: expandCreatedBy('created_by.nickname'),
                  title: 'expand created_by.nickname',
                ),
                customButton(
                    fn: getAllProductWithExpand,
                    title: '获取所有产品(expand pointer)'),
                customButton(
                  fn: _records.length == 0 ? null : getExpand,
                  title: 'tableObject get expand',
                ),
                customTitle('时间类型字段查询'),
                customButton(fn: queryByTime, title: 'created_at 查询'),
                customButton(fn: queryByDate, title: 'date 查询'),
                customTitle('hasKey 查询'),
                customButton(fn: hasKey, title: 'hasKey "num" 查询'),
                customTitle('count 查询'),
                customButton(fn: countItem, title: 'count 查询'),
                customTitle('pointer 查询'),
                customButton(
                    fn: pointerQuery('exist'), title: 'pointer 查询 exist'),
                customButton(
                    fn: pointerQuery('compare'), title: 'pointer 查询 compare'),
                customButton(fn: pointerQuery('in'), title: 'pointer 查询 in'),
                customButton(
                    fn: pointerQuery('notIn'), title: 'pointer 查询 not in'),
              ],
            ),
          ),
        ),
        isLoading: _isLoading,
      ),
    );
  }
}
