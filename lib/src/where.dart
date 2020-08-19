import 'dart:convert';
import 'package:minapp/minapp.dart';

import 'h_error.dart';
import 'util.dart';

class Where {
  Map<String, dynamic> _condition;

  Where() {
    initCondition();
  }

  void initCondition() {
    _condition = {};
  }

  Map<String, dynamic> get condition => _condition;

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

  /// 字段为 Null 判断
  /// 判断逻辑：Record[key] 是 null
  /// [key] 用于查询判断的字段
  void isNull(dynamic key) {
    if (key is String) {
      _addCondition(key, {'isnull': true});
    } else if (key is List<String>) {
      key.forEach((k) {
        _addCondition(k, {'isnull': true});
      });
    } else {
      throw HError(605);
    }
  }

  /// 字段不为 Null 判断
  /// 判断逻辑：Record[key] 不是 null
  /// [key] 用于查询判断的字段
  void isNotNull(dynamic key) {
    if (key is String) {
      _addCondition(key, {'isnull': false});
    } else if (key is List<String>) {
      key.forEach((k) {
        _addCondition(k, {'isnull': false});
      });
    } else {
      throw HError(605);
    }
  }

  /// 字段存在判断
  /// 判断逻辑：Record[key] 不是 undefined
  /// [key] 用于查询判断的字段
  void exists(dynamic key) {
    if (key is String) {
      _addCondition(key, {'exists': true});
    } else if (key is List<String>) {
      key.forEach((k) {
        _addCondition(k, {'exists': true});
      });
    } else {
      throw HError(605);
    }
  }

  /// 字段不存在判断
  /// 判断逻辑：Record[key] 是 undefined
  /// [key] 用于查询判断的字段
  void notExists(dynamic key) {
    if (key is String) {
      _addCondition(key, {'exists': false});
    } else if (key is List<String>) {
      key.forEach((k) {
        _addCondition(k, {'exists': false});
      });
    } else {
      throw HError(605);
    }
  }

  /// Object 类型字段的属性存在判断
  /// [key] 用于查询判断的字段
  /// [fieldName] 字段名称
  void hasKey(String key, String fieldName) {
    _addCondition(key, {'has_key': fieldName});
  }

  /// and 操作符。将多个 Query 对象使用 and 操作符进行合并
  /// [wheres] where 数组
  /// [TODO] _setCondition 会把当前 _condition 覆盖掉，可能需要返回一个新的 where。待商讨
  void and(List<Where> wheres) {
    Map<String, dynamic> andWhere = {'\$and': []};
    wheres.forEach((where) {
      andWhere['\$and'].add(where._condition);
    });

    _setCondition(andWhere);
  }

  /// or 操作符。将多个 Query 对象使用 or 操作符进行合并
  /// [wheres] where 数组
  /// [TODO] _setCondition 会把当前 _condition 覆盖掉，可能需要返回一个新的 where。待商讨
  void or(List<Where> wheres) {
    Map<String, dynamic> andWhere = {'\$or': []};
    wheres.forEach((where) {
      andWhere['\$or'].add(where._condition);
    });

    _setCondition(andWhere);
  }

  /// 多边形包含判断，在指定多边形集合中找出包含某一点的多边形（geojson 类型）
  /// [key] 用于查询判断的字段
  /// [point] 点
  void include(String key, GeoPoint point) {
    _addCondition(key, {'intersects': point.geoJSON});
  }

  /// 多边形包含判断，在指定点集合中，查找包含于指定的多边形区域的点（geojson 类型）。
  /// [key] 用于查询判断的字段
  /// [polygon] 多边形
  void within(String key, GeoPolygon polygon) {
    _addCondition(key, {'within': polygon.geoJSON});
  }

  /// 圆包含判断，在指定点集合中，查找包含在指定圆心和指定半径所构成的圆形区域中的点（geojson 类型）
  /// [key] 用于查询判断的字段
  /// [point] 圆心
  /// [radius] 半径
  void withinCircle(String key, GeoPoint point, num radius) {
    Map<String, dynamic> data = {
      'radius': radius,
      'coordinates': [point.longitude, point.latitude],
    };
    _addCondition(key, {'center': data});
  }

  /// 圆环包含判断，在指定点集合中，查找包含在以某点为起点的最大和最小距离所构成的圆环区域中的点（geojson 类型）
  /// [key] 用于查询判断的字段
  /// [point] 圆心
  /// [maxDistance] 最大半径
  /// [minDistance] 最小半径
  void withinRegion(String key, GeoPoint point,
      {num maxDistance, num minDistance = 0}) {
    Map<String, dynamic> data = {
      'geometry': point.geoJSON,
      'min_distance': minDistance
    };

    if (maxDistance != null) {
      data['max_distance'] = maxDistance;
    }

    _addCondition(key, {'nearsphere': data});
  }

  void _setCondition(Map<String, dynamic> condition) {
    _condition = condition;
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

  /// 获取已被 json 序列化的 where 的查询条件
  String get() {
    return jsonEncode(_condition);
  }
}
