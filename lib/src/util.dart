import 'package:dio/dio.dart';
import 'package:clock/clock.dart';

import 'auth.dart';
import 'config.dart';
import 'storage.dart';
import 'constants.dart';
import 'h_error.dart';
import 'dart:core';
import 'geo_point.dart';
import 'geo_polygon.dart';
import 'table_record.dart';

Future<Map<String, dynamic>> mergeRequestHeader(
    Map<String, dynamic> headers) async {
  if (config.clientID == null) {
    throw HError(602);
  }

  headers = headers ?? {};

  if (config.env != null) {
    headers['X-Hydrogen-Env-ID'] = config.env;
  }

  headers['X-Hydrogen-Client-ID'] = config.clientID;
  headers['X-Hydrogen-Client-Version'] = config.version;
  headers['X-Hydrogen-Client-Platform'] = config.platform;
  headers['X-Hydrogen-Client-SDK-Type'] = config.sdkType;

  var token = await Auth.getAuthToken();

  if (token != null) {
    headers['Authorization'] = '${config.authPrefix} $token';
  }

  return headers;
}

int getExpiredAt(int nowMilliseconds, int expiresIn) {
  return (nowMilliseconds ~/ 1000) + expiresIn - 30;
}

Future<void> handleLoginSuccess(Response res,
    [bool isAnonymous = false]) async {
  await storageAsync.set(StorageKey.authToken, res.data['token']);
  await storageAsync.set(StorageKey.uid, res.data['user_id'].toString());
  await storageAsync.set(
      StorageKey.expiresAt,
      getExpiredAt(Clock().now().millisecondsSinceEpoch, res.data['expires_in'])
          .toString());
  if (isAnonymous) {
    await storageAsync.set(StorageKey.isAnonymousUser, '1');
  } else {
    await storageAsync.set(StorageKey.isAnonymousUser, '0');
  }
}

Future<bool> isSessionExpired() async {
  int expiresAt = int.parse(await storageAsync.get(StorageKey.expiresAt));
  int now = Clock().now().millisecondsSinceEpoch ~/ 1000;

  if (expiresAt != null) {
    return now >= expiresAt;
  }
  return now >= 0;
}

Future clearSession() async {
  // 清除客户端认证 Token
  await storageAsync.remove(StorageKey.authToken);
  // 清除 BaaS 登录状态
  await storageAsync.remove(StorageKey.isAnonymousUser);
  // 清除用户信息
  await storageAsync.remove(StorageKey.uid);

  await storageAsync.remove(StorageKey.expiresAt);
}

/// 对 RegExp 类型的变量解析出不含左右斜杠和 flag 的正则字符串和 flags
/// [regExp] 正则表达式
List parseRegExp(RegExp regExp) {
  List result = [];
  String regExpString = regExp.pattern.toString();

  String firstChar = regExpString.substring(0, 1);

  if (firstChar != '/') {
    regExpString = '/' + regExpString + '/';
  }

  int lastIndex = regExpString.lastIndexOf('/');

  result.add(regExpString.substring(1, lastIndex));

  if (lastIndex != regExpString.length - 1) {
    result.add(regExpString.substring(lastIndex + 1));
  }

  return result;
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
