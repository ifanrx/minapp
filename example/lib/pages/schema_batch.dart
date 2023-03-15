import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:minapp/minapp.dart';
import '../components/custom_button.dart';
import '../components/custom_title.dart';
import './common.dart';
import '../util.dart';

Map<String, dynamic> pointerIds = getPointerIds();

class SchemaBatch extends StatefulWidget {
  @override
  _SchemaBatchState createState() => _SchemaBatchState();
}

class _SchemaBatchState extends State<SchemaBatch> {
  TableObject order = new TableObject('auto_maintable');
  bool _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext).removeCurrentSnackBar();
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(snackBar);
  }

  void showLoading(bool isLoading) {
    setState(() => _isLoading = isLoading);
  }

  Map getResult(records) {
    var list = records.operation_result.map((element) {
      if (element.success != null) {
        return {'success': element.success};
      }
      if (element.error != null) {
        return {'error': element.error};
      }
    }).toList();

    Map result = {
      'succeed': records.succeed,
      'total_count': records.total_count,
      'operation_result': list
    };

    if (records.limit != null || records.offset != null) {
      result['limit'] = records.limit;
      result['next'] = records.next;
      result['previous'] = records.previous;
      result['offset'] = records.offset;
    }

    return result;
  }

  void batchCreate() async {
    showLoading(true);

    try {
      List<Map<String, dynamic>> data = [
        {"num": 200, "str": '5ae9d18eba648b7175c6c5cb'},
        {"num": 201, "str": '5a2fa9b008443e59e0e67829'},
        {"rum": 203, "str": '5a33406909a805412e3169c3'},
      ];

      TableRecordOperationList records =
          await order.createMany(data, enableTrigger: true);
      Map result = getResult(records);
      alert(context, '$result');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void batchCreateWithoutTrigger() async {
    showLoading(true);

    try {
      List<Map<String, dynamic>> data = [
        {"num": 200, "str": '5ae9d18eba648b7175c6c5cb'},
        {"num": 201, "str": '5a2fa9b008443e59e0e67829'},
        {"rum": 203, "str": '5a33406909a805412e3169c3'},
      ];

      TableRecordOperationList records =
          await order.createMany(data, enableTrigger: false);
      Map result = getResult(records);
      alert(context, '$result');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void batchCreatePointer() async {
    showLoading(true);

    try {
      List<Map<String, dynamic>> data = [
        // {
        //   'pointer_userprofile': user.getWithoutData(pointerIds['pointer_userprofile_id'])
        // },
        {
          'pointer_test_order': new TableObject('test_order')
              .getWithoutData(recordId: pointerIds['pointer_test_order_id'])
        }
      ];

      TableRecordOperationList records = await order.createMany(data);
      Map result = getResult(records);
      alert(context, '$result');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void batchUpdateCompare() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = Where.compare('num', '>=', 200);
      query.where(where);
      TableRecord record = order.getWithoutData(query: query);
      record.set('str', 'updated');
      TableRecordOperationList records =
          await record.update(withCount: true, enableTrigger: true);
      Map result = getResult(records);
      alert(context, '$result');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void batchUpdateCompareWithoutTrigger() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = Where.compare('num', '>=', 200);
      query.where(where);
      TableRecord record = order.getWithoutData(query: query);
      record.set('str', 'updated');
      TableRecordOperationList records =
          await record.update(withCount: true, enableTrigger: false);
      Map result = getResult(records);
      alert(context, '$result');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void batchUpdateStr() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = Where.contains('str', 'a');
      query.where(where);
      TableRecord record = order.getWithoutData(query: query);
      record.set('num', 500);
      TableRecordOperationList records =
          await record.update(withCount: true, enableTrigger: false);
      Map result = getResult(records);
      alert(context, '$result');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void batchUpdateArr() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = Where.compare('array_s', '=', ['a', 'b', 'c', 'd']);
      query.where(where);
      TableRecord record = order.getWithoutData(query: query);
      record.set('str', 'update_arr');
      TableRecordOperationList records = await record.update(withCount: true);
      Map result = getResult(records);
      alert(context, '$result');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void batchUpdateNull() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = Where.notExists('int');
      query.where(where);
      TableRecord record = order.getWithoutData(query: query);
      record.set('str', 'update_null');
      TableRecordOperationList records = await record.update(withCount: true);
      Map result = getResult(records);
      alert(context, '$result');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void complexBatchUpdate() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where1 = Where.matches('str', new RegExp(r'/^\w\d?/'));
      Where where2 = Where.compare('num', '>', 50);
      Where andWhere = Where.and([where1, where2]);
      query.where(andWhere);

      TableRecord record = order.getWithoutData(query: query);
      record.append('array_s', 'update_and_or');
      TableRecordOperationList records = await record.update(withCount: true);
      Map result = getResult(records);
      alert(context, '$result');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void batchDelete() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = Where.compare('num', '>', 50);
      query
        ..limit(2)
        ..offset(0)
        ..where(where);

      var res = await order.delete(
          query: query, withCount: true, enableTrigger: true);
      alert(context, 'succeed: $res');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void batchDeleteWithoutTrigger() async {
    showLoading(true);

    try {
      Query query = new Query();
      Where where = Where.compare('num', '>', 50);
      query
        ..limit(2)
        ..offset(0)
        ..where(where);

      var res = await order.delete(
          query: query, withCount: true, enableTrigger: false);
      alert(context, 'succeed: $res');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Schema 批量操作测试')),
      body: LoadingOverlay(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                CustomButton(
                  batchCreate,
                  title: '批量新增数据',
                ),
                CustomButton(
                  batchCreateWithoutTrigger,
                  title: '批量新增数据（不触发触发器）',
                ),
                CustomButton(
                  batchCreatePointer,
                  title: '批量新增数据（Pointer）',
                ),
                CustomTitle(
                  '批量更新',
                  fontSize: 20.0,
                  textColor: Colors.black,
                ),
                CustomButton(
                  batchUpdateCompare,
                  title: '比较查询批量更新数据',
                ),
                CustomButton(
                  batchUpdateCompareWithoutTrigger,
                  title: '比较查询批量更新数据（不触发触发器）',
                ),
                CustomButton(
                  batchUpdateStr,
                  title: '字符串查询更新数据',
                ),
                CustomButton(
                  batchUpdateArr,
                  title: '数组查询更新数据',
                ),
                CustomButton(
                  batchUpdateNull,
                  title: '空查询更新数据',
                ),
                CustomButton(
                  complexBatchUpdate,
                  title: '复杂查询更新数据',
                ),
                CustomButton(
                  batchDelete,
                  title: '批量删除数据',
                ),
                CustomButton(
                  batchDeleteWithoutTrigger,
                  title: '批量删除数据（不触发触发器）',
                ),
              ],
            ),
          ),
        ),
        isLoading: _isLoading,
      ),
    );
  }
}
