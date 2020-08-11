class Query {
  int _offset, _limit;
  String _orderBy;

  void offset(int offset) {
    _offset = offset;
  }

  void limit(int limit) {
    _limit = limit;
  }

  void orderBy(String orderBy) {
    _orderBy = orderBy;
  }

  Map<String, dynamic> get() {
    return {
      'offset': _offset,
      'limit': _limit,
      'order_by': _orderBy,
    };
  }
}
