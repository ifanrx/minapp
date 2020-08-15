import 'package:minapp/minapp.dart';

import 'h_error.dart';
import 'geo_point.dart';
import 'geo_polygon.dart';

class BaseRecord {
  Map<String, dynamic> record;

  BaseRecord() {
    recordValueInit();
  }

  void recordValueInit() {
    record = {
      '\$set': new Map<String, dynamic>(),
      '\$unset': new Map<String, dynamic>(),
    };
  }

  /// 解析不同类型 value 的内容
  serializeValue(value) {
    if (value is GeoPoint || value is GeoPolygon) {
      return value.geoJSON;
    } else if (value is TableRecord) {
      return value.recordId;
    } else {
      return value;
    }
  }

  /// 给字段赋值
  /// 接收 [arg1] 为 Map<String, dynamic> 的参数。此为一次性赋值。
  /// 或接收 [arg1] 为字符串，[arg2] 为任意值作为参数。此为逐个赋值。
  /// 不可同时用 set 与 unset 操作同一字段，否则会报 605 错误
  void set(dynamic arg1, [dynamic arg2]) {
    if (arg2 == null) {
      if (arg1 is Map<String, dynamic>) {
        arg1.forEach((String key, dynamic value) {
          if (record['\$unset'].containsKey(key)) {
            throw HError(605);
          }

          if (value is List) {
            arg1[key] = value.map((elem) => serializeValue(elem)).toList();
          } else {
            arg1[key] = serializeValue(value);
          }
        });

        record['\$set'] = arg1;
      } else {
        throw HError(605);
      }
    } else if (arg1 is String) {
      if (record['\$unset'].containsKey(arg1)) {
        throw HError(605);
      }

      if (arg2 is List) {
        record['\$set'][arg1] =
            arg2.map((elem) => serializeValue(elem)).toList();
      } else {
        record['\$set'][arg1] = serializeValue(arg2);
      }
    } else {
      throw HError(605);
    }
  }

  /// 移除字段
  /// [arg] 移除的字段或一次性赋值的键值对 map
  /// 不可同时用 set 与 unset 操作同一字段，否则会报 605 错误
  void unset(dynamic arg) {
    if (arg is String) {
      if (record['\$set'].containsKey(arg)) {
        throw HError(605);
      }
      record['\$unset'][arg] = '';
    } else if (arg is Map<String, dynamic>) {
      Map<String, dynamic> recordToUnset = {};
      arg.forEach((String key, dynamic value) {
        if (record['\$set'].containsKey(key)) {
          throw HError(605);
        }
        recordToUnset[key] = '';
      });
      record['\$unset'] = recordToUnset;
    } else {
      throw HError(605);
    }
  }

  /// Object 类型字段修改
  /// [key] 字段名
  /// [value] 字段对应的值
  void patchObject(String key, Map<String, dynamic> value) {
    record['\$set'][key] = {'\$update': value};
  }

  /// 自增（计数器原子性更新）
  /// [key] 字段名
  /// [value] 字段对应的值
  void incrementBy(String key, num value) {
    record['\$set'][key] = {'\$incr_by': value};
  }

  /// 数组添加元素
  /// [key] 字段名
  /// [value] 字段对应的值
  void append(String key, dynamic value) {
    if (value is! List) {
      value = [value];
    }

    if (!value.isEmpty && (value[0] is GeoPoint || value[0] is GeoPolygon)) {
      List geoList = value.map((geo) => geo.geoJSON).toList();
      record['\$set'][key] = {'\$append': geoList};
    } else {
      record['\$set'][key] = {'\$append': value};
    }
  }

  /// 数组添加不包含在原数组的元素
  /// [key] 字段名
  /// [value] 字段对应的值
  void uAppend(String key, dynamic value) {
    if (value is! List) {
      value = [value];
    }

    if (!value.isEmpty && (value[0] is GeoPoint || value[0] is GeoPolygon)) {
      List geoList = value.map((geo) => geo.geoJSON).toList();
      record['\$set'][key] = {'\$append_unique': geoList};
    } else {
      record['\$set'][key] = {'\$append_unique': value};
    }
  }

  /// 数组移除元素
  /// [key] 字段名
  /// [value] 字段对应的值
  void remove(String key, dynamic value) {
    if (value is! List) {
      value = [value];
    }

    if (!value.isEmpty && (value[0] is GeoPoint || value[0] is GeoPolygon)) {
      List geoList = value.map((geo) => geo.geoJSON).toList();
      record['\$set'][key] = {'\$remove': geoList};
    } else {
      record['\$set'][key] = {'\$remove': value};
    }
  }
}
