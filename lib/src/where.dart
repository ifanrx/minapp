import 'dart:convert';
import 'h_error.dart';
import 'base_record.dart';
import 'util.dart';

class Where {
  Map<String, dynamic> _condition;
  Function serializeValue = new BaseRecord().serializeValue;

  Where() {
    initCondition();
  }

  void initCondition() {
    _condition = {};
  }

  /// 运算符转换
  String _convertOperator(String operator) {
    switch (operator) {
      case '=':
        return 'eq';
      case '!=':
        return 'ne';
      case '<':
        return 'lt';
      case '<=':
        return 'lte';
      case '>':
        return 'gt';
      case '>=':
        return 'gte';
      default:
        throw HError(605);
    }
  }

  /// 比较判断，将 Record[key] 与 value 使用 operator 进行判断，筛选出符合条件的 Record
  /// [key] 用于查询判断的字段
  /// [operator] 判断操作符
  /// [value] 用于判断的值
  void compare(String key, String operator, dynamic value) {
    String op = _convertOperator(operator);
    _addCondition(key, {op: serializeValue(value)});
  }

  /// 包含判断，筛选出符合条件（Record[key] 包含了字符串 str）的 Record
  /// [key] 需要查询的字段
  /// [value] 字段内容是否包含该字符串
  void contains(String key, String value) {
    _addCondition(key, {'contains': value});
  }

  /// 正则判断，筛选出符合条件（正则表达式 regExp 能匹配 Record[key]）的 Record
  /// [key] 用于查询判断的字段
  /// [regExp] 正则表达式
  void matches(String key, RegExp regExp) {
    List result = parseRegExp(regExp);

    if (result.length > 1) {
      _addCondition(key, {'regex': result[0], 'options': result[1]});
    } else {
      _addCondition(key, {'regex': result[0]});
    }
  }

  /// 包含判断，筛选出符合条件（数组 arr 包含 Record[key]）的 Record
  /// [key] 用于查询判断的字段
  /// [list] 用于判断的数组
  void inList(String key, List list) {
    _addCondition(key, {'in': list.map((e) => serializeValue(e)).toList()});
  }

  /// 不包含判断，筛选出符合条件（数组 arr 不包含 Record[key]）的 Record
  /// [key] 用于查询判断的字段
  /// [list] 用于判断的数组
  void notInList(String key, List list) {
    _addCondition(key, {'nin': list.map((e) => serializeValue(e)).toList()});
  }

  /// 数组包含判断
  /// [key] 用于查询判断的字段
  /// [list] 用于判断的数组
  void arrayContains(String key, List list) {
    _addCondition(key, {'all': list.map((e) => serializeValue(e)).toList()});
  }

  void _addCondition(String key, Map<String, dynamic> condition) {
    Map<String, dynamic> conditionMap = {key: {}};

    condition.forEach((k, v) {
      conditionMap[key]['\$$k'] = v;
    });

    if (_condition['\$and'] == null) {
      _condition['\$and'] = [];
    }

    _condition['\$and'].add(conditionMap);
  }

  String get() {
    return jsonEncode(_condition);
  }
}
