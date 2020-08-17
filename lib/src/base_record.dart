import 'package:minapp/minapp.dart';

import 'h_error.dart';
import 'geo_point.dart';
import 'geo_polygon.dart';
import 'util.dart';

class BaseRecord {
  Map<String, dynamic> _record;
  String _id;
  int _createdById;
  Map<String, dynamic> _createdBy;
  int _createdAt;
  int _updatedAt;

  BaseRecord() {
    recordValueInit();
  }

  BaseRecord.withInfo(Map<String, dynamic> recordInfo) {
    _id = recordInfo['id'];
    _createdById = recordInfo['created_by'];
    _createdAt = recordInfo['created_at'];
    _updatedAt = recordInfo['updated_at'];
    recordValueInit();
  }

  Map<String, dynamic> get record => _record;
  String get id => _id;
  int get createdById => _createdById;
  int get createdAt => _createdAt;
  int get updatedAt => _updatedAt;

  void recordValueInit() {
    _record = {
      '\$set': new Map<String, dynamic>(),
      '\$unset': new Map<String, dynamic>(),
    };
  }

  /// 给字段赋值
  /// 接收 [arg1] 为 Map<String, dynamic> 的参数。此为一次性赋值。
  /// 或接收 [arg1] 为字符串，[arg2] 为任意值作为参数。此为逐个赋值。
  /// 不可同时用 set 与 unset 操作同一字段，否则会报 605 错误
  BaseRecord set(dynamic arg1, [dynamic arg2]) {
    if (arg2 == null) {
      if (arg1 is Map<String, dynamic>) {
        arg1.forEach((String key, dynamic value) {
          if (_record['\$unset'].containsKey(key)) {
            throw HError(605);
          }

          if (value is List) {
            arg1[key] = value.map((elem) => serializeValue(elem)).toList();
          } else {
            arg1[key] = serializeValue(value);
          }
        });

        _record['\$set'] = arg1;
      } else {
        throw HError(605);
      }
    } else if (arg1 is String) {
      if (_record['\$unset'].containsKey(arg1)) {
        throw HError(605);
      }

      if (arg2 is List) {
        _record['\$set'][arg1] =
            arg2.map((elem) => serializeValue(elem)).toList();
      } else {
        _record['\$set'][arg1] = serializeValue(arg2);
      }
    } else {
      throw HError(605);
    }

    return this;
  }

  /// 移除字段
  /// [arg] 移除的字段或一次性赋值的键值对 map
  /// 不可同时用 set 与 unset 操作同一字段，否则会报 605 错误
  BaseRecord unset(dynamic arg) {
    if (arg is String) {
      if (_record['\$set'].containsKey(arg)) {
        throw HError(605);
      }
      _record['\$unset'][arg] = '';
    } else if (arg is Map<String, dynamic>) {
      Map<String, dynamic> recordToUnset = {};
      arg.forEach((String key, dynamic value) {
        if (_record['\$set'].containsKey(key)) {
          throw HError(605);
        }
        recordToUnset[key] = '';
      });
      _record['\$unset'] = recordToUnset;
    } else {
      throw HError(605);
    }

    return this;
  }

  /// Object 类型字段修改
  /// [key] 字段名
  /// [value] 字段对应的值
  BaseRecord patchObject(String key, Map<String, dynamic> value) {
    _record['\$set'][key] = {'\$update': value};
    return this;
  }

  /// 自增（计数器原子性更新）
  /// [key] 字段名
  /// [value] 字段对应的值
  BaseRecord incrementBy(String key, num value) {
    _record['\$set'][key] = {'\$incr_by': value};
    return this;
  }

  /// 数组添加元素
  /// [key] 字段名
  /// [value] 字段对应的值
  BaseRecord append(String key, dynamic value) {
    if (value is! List) {
      value = [value];
    }

    if (!value.isEmpty && (value[0] is GeoPoint || value[0] is GeoPolygon)) {
      List geoList = value.map((geo) => geo.geoJSON).toList();
      _record['\$set'][key] = {'\$append': geoList};
    } else {
      _record['\$set'][key] = {'\$append': value};
    }

    return this;
  }

  /// 数组添加不包含在原数组的元素
  /// [key] 字段名
  /// [value] 字段对应的值
  BaseRecord uAppend(String key, dynamic value) {
    if (value is! List) {
      value = [value];
    }

    if (!value.isEmpty && (value[0] is GeoPoint || value[0] is GeoPolygon)) {
      List geoList = value.map((geo) => geo.geoJSON).toList();
      _record['\$set'][key] = {'\$append_unique': geoList};
    } else {
      _record['\$set'][key] = {'\$append_unique': value};
    }

    return this;
  }

  /// 数组移除元素
  /// [key] 字段名
  /// [value] 字段对应的值
  BaseRecord remove(String key, dynamic value) {
    if (value is! List) {
      value = [value];
    }

    if (!value.isEmpty && (value[0] is GeoPoint || value[0] is GeoPolygon)) {
      List geoList = value.map((geo) => geo.geoJSON).toList();
      _record['\$set'][key] = {'\$remove': geoList};
    } else {
      _record['\$set'][key] = {'\$remove': value};
    }

    return this;
  }
}
