import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clock/clock.dart';

import 'package:minapp/src/util.dart';
import 'package:minapp/src/constants.dart';

void main() {
  SharedPreferences.setMockInitialValues({});

  test('getExpiredAt', () {
    int expiresIn = 86400;
    int nowStamp = Clock.fixed(DateTime(2020, 07, 27)).now().millisecondsSinceEpoch;

    expect(getExpiredAt(nowStamp, expiresIn), equals(nowStamp ~/ 1000 + expiresIn - 30));
  });

  test('handleLoginSuccess', () async {
    const String authToken = 'authToken';
    const int userId = 1234;
    const int expiresIn = 108532;
    final int now = DateTime.now().millisecondsSinceEpoch;
    Response response = Response(
      statusCode: 200,
      data: {
        'token': authToken,
        'user_id': userId,
        'expires_in': expiresIn,
      }
    );
    SharedPreferences _sp = await SharedPreferences.getInstance();
    await handleLoginSuccess(response);

    expect(_sp.getString(StorageKey.authToken), equals(authToken));
    expect(_sp.get(StorageKey.uid), equals(userId.toString()));
    expect(_sp.get(StorageKey.expiresAt), equals(getExpiredAt(now, expiresIn).toString()));
    expect(_sp.get(StorageKey.isAnonymousUser), equals('0'));
  });

  test('clearSession', () async {
    SharedPreferences _sp = await SharedPreferences.getInstance();
    await clearSession();
    expect(_sp.getString(StorageKey.authToken), equals(null));
    expect(_sp.getString(StorageKey.uid), equals(null));
    expect(_sp.getString(StorageKey.expiresAt), equals(null));
    expect(_sp.getString(StorageKey.isAnonymousUser), equals(null));
  });
}
