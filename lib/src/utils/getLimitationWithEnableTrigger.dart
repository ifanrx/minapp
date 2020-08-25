import '../constants.dart' as constants;

getLimitationWithEnableTrigger(limit, enableTrigger) {
  // 设置了 limit，直接返回
  if (limit != null) {
    return limit;
  }

  // 如果触发触发器，则默认添加限制
  if (enableTrigger) {
    return constants.queryLimitationDefault;
  }

  // 不触发发触发器，则默认不限制
  return null;
}
