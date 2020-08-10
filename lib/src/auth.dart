import 'package:dio/dio.dart';
import 'package:minapp/minapp.dart';

import 'storage.dart';
import 'constants.dart';
import 'request.dart';
import 'util.dart';
import 'currentUser.dart';

class Auth {
  static Future<String> getAuthToken() => storageAsync.get(StorageKey.authToken);

  static String getAuthUrl(Map<String, dynamic> data, [bool isLoginFunc = false]) {
    if (data['email'] != null) {
      return isLoginFunc ? Api.loginEmail : Api.registerEmail;
    }
    if (data['phone'] != null) {
      return isLoginFunc ? Api.loginPhone : Api.registerPhone;
    }

    return isLoginFunc ? Api.loginUsername : Api.registerUsername;
  }

  static Future<dynamic> login(Map<String, dynamic> data) async {
    String url = getAuthUrl(data, true);
    var res = await request(
      path: url,
      method: 'POST',
      data: data,
    );

    print('userid==>');
    print(res.data['user_id']);

    await handleLoginSuccess(res);

    return res.data;
  }

  static Future<dynamic> register(Map<String, dynamic> data) async {
    String url = getAuthUrl(data);
    Response res = await request(
      path: url,
      method: 'POST',
      data: data,
    );
    await handleLoginSuccess(res);

    return res.data;
  }

  static Future<CurrentUser> getCurrentUser() async {
    var id = await storageAsync.get(StorageKey.uid);
    String expiresAt = await storageAsync.get(StorageKey.expiresAt);
    bool expired = await isSessionExpired();

    if (id == null || expiresAt == null || expired) {
      return throw HError(604);
    }

    var res = await request(
      path: Api.userDetail,
      params: {'userID': id},
    );
    CurrentUser currentUser = CurrentUser(res.data);
    return currentUser;
  }

  static Future<dynamic> logout() async {
    Response res = await request(
      path: Api.logout,
      method: 'POST',
      data: {}, // 不带 data 请求会 415
    );
    await clearSession();

    return res.data;
  }

  static Future<dynamic> loginWithSmsVerificationCode (String mobilePhone, String smsCode, {bool createUser = true}) async {
    Response res = await request(
      path: Api.loginSms,
      method: 'POST',
      data: {
        'phone': mobilePhone,
        'code': smsCode,
        'create_user': createUser,
      },
    );

    await handleLoginSuccess(res);

    return res.data;
  }

  static Future requestPasswordReset(String email) async {
    var res = await request(
      path: Api.passwordReset,
      method: 'POST',
      data: {
        'email': email,
      }
    );
    return res.data;
  }

  static Future<CurrentUser> anonymousLogin() async {
    Response res = await request(
      path: Api.anonymousLogin,
      method: 'POST',
      data: {},
    );
    await handleLoginSuccess(res, true);
    CurrentUser currentUser = await getCurrentUser();
    return currentUser;
  }
}
