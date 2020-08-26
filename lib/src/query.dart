import 'where.dart';
import 'h_error.dart';

class Query {
  int _offset, _limit;
  dynamic _orderBy;
  List<String> _keys, _expand;
  bool _returnTotalCount;
  Where _where;

  Query() {
    _initQueryParams();
  }

  void _initQueryParams() {
    _limit = null;
    _offset = 0;
    _orderBy = null;
    _keys = null;
    _expand = null;
  }

  void offset(int offset) {
    _offset = offset;
  }

  void limit(int limit) {
    _limit = limit;
  }

  /// 指定需要展开的 orderBy 类型字段
  /// [key] 字段名称
  void orderBy(dynamic key) {
    if (key is String) {
      _orderBy = [key];
    } else if (key is List<String>) {
      _orderBy = key;
    } else {
      throw HError(605);
    }
  }

  void where(Where where) {
    _where = where;
  }

  /// 指定需要展开的 pointer 类型字段
  /// [key] 字段名称
  void expand(dynamic key) {
    if (key is String) {
      _expand = [key];
    } else if (key is List<String>) {
      _expand = key;
    } else {
      throw HError(605);
    }
  }

  void select(dynamic key) {
    if (key is String) {
      _keys = [key];
    } else if (key is List<String>) {
      _keys = key;
    } else {
      throw HError(605);
    }
  }

  void withTotalCount(bool returnTotalCount) {
    _returnTotalCount = returnTotalCount;
  }

  Map<String, dynamic> get() {
    Map<String, dynamic> data = {};

    if (_offset != null) data.addAll({'offset': _offset});

    if (_limit != null) data.addAll({'limit': _limit});

    if (_orderBy != null) data.addAll({'order_by': _orderBy.join(',')});

    if (_expand != null) data.addAll({'expand': _expand.join(',')});

    if (_keys != null) data.addAll({'keys': _keys.join(',')});

    if (_where != null) data.addAll({'where': _where});

    if (_returnTotalCount != null) {
      data.addAll({'return_total_count': _returnTotalCount == true ? 1 : 0});
    }

    return data;
  }
}
