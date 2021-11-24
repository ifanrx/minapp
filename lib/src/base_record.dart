import 'package:minapp/minapp.dart';

import 'h_error.dart';
import 'geo_point.dart';
import 'geo_polygon.dart';
import 'util.dart';

class BaseRecord {
  Map<String, dynamic> _record;
  String _id;
  int _created_by;
  Map<String, dynamic> _created_by_map;
  int _created_at;
  int _updated_at;
  Map<String, dynamic> _recordInfo;

  BaseRecord() {
    recordValueInit();
  }

  BaseRecord.withInfo(Map<String, dynamic> recordInfo) {
    _id = recordInfo['id'].toString();
    if (recordInfo['created_by'] != null) {
      _created_by = recordInfo['created_by'] is int
          ? recordInfo['created_by']
          : recordInfo['created_by']['id'];
    }
    _created_by_map =
        recordInfo['created_by'] is Map ? recordInfo['created_by'] : null;
    _created_at = recordInfo['created_at'];
    _updated_at = recordInfo['updated_at'];
    _recordInfo = recordInfo;
    recordValueInit();
  }

  Map<String, dynamic> get record => _record;
  String get id => _id;
  int get created_by => _created_by;
  Map<String, dynamic> get created_by_map => _created_by_map;
  int get created_at => _created_at;
  int get updated_at => _updated_at;
  Map<String, dynamic> get recordInfo => _recordInfo;

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
  void set(dynamic arg1, [dynamic arg2]) {
    if (arg2 == null) {
      if (arg1 is Map<String, dynamic>) {
        Map<String, dynamic> _map = {};

        arg1.forEach((String key, dynamic value) {
          if (_record['\$unset'].containsKey(key)) {
            throw HError(605);
          }

          if (value is List) {
            _map[key] = value.map((elem) => serializeValue(elem)).toList();
          } else {
            _map[key] = serializeValue(value);
          }
        });

        _record['\$set'] = _map;
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
  }

  /// 移除字段
  /// [arg] 移除的字段或一次性赋值的键值对 map
  /// 不可同时用 set 与 unset 操作同一字段，否则会报 605 错误
  void unset(dynamic arg) {
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
  }

  /// Object 类型字段修改
  /// [key] 字段名
  /// [value] 字段对应的值
  void patchObject(String key, Map<String, dynamic> value) {
    _record['\$set'][key] = {'\$update': value};
  }

  /// 自增（计数器原子性更新）
  /// [key] 字段名
  /// [value] 字段对应的值
  void incrementBy(String key, num value) {
    _record['\$set'][key] = {'\$incr_by': value};
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
      _record['\$set'][key] = {'\$append': geoList};
    } else if (!value.isEmpty && value[0] is CloudFile) {
      List fileList = value.map((elem) => serializeValue(elem)).toList();
      _record['\$set'][key] = {'\$append': fileList};
    } else {
      _record['\$set'][key] = {'\$append': value};
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
      _record['\$set'][key] = {'\$append_unique': geoList};
    } else if (!value.isEmpty && value[0] is CloudFile) {
      List fileList = value.map((elem) => serializeValue(elem)).toList();
      _record['\$set'][key] = {'\$append_unique': fileList};
    } else {
      _record['\$set'][key] = {'\$append_unique': value};
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
      _record['\$set'][key] = {'\$remove': geoList};
    } else if (!value.isEmpty && value[0] is CloudFile) {
      List fileList = value.map((elem) => serializeValue(elem)).toList();
      _record['\$set'][key] = {'\$remove': fileList};
    } else {
      _record['\$set'][key] = {'\$remove': value};
    }
  }
}
