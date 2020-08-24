import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'storage.dart';
import 'constants.dart';
import 'request.dart';
import 'util.dart';
import 'user.dart';
import 'h_error.dart';

String _getAuthUrl(Map<String, dynamic> data, [bool isLoginFunc = false]) {
  if (data['email'] != null) {
    return isLoginFunc ? Api.loginEmail : Api.registerEmail;
  }
  if (data['phone'] != null) {
    return isLoginFunc ? Api.loginPhone : Api.registerPhone;
  }

  return isLoginFunc ? Api.loginUsername : Api.registerUsername;
}

class Auth {
  static Future<String> getAuthToken() => storageAsync.get(StorageKey.authToken);

  static Future<CurrentUser> login({@required String password, String phone, String username, String email}) async {
    Map<String, String> data = {
      'password': password
    };

    if (email != null) {
      data.addAll({'email': email});
    } else if (phone != null) {
      data.addAll({'phone': phone});
    } else {
      data.addAll({'username': username});
    }

    String url = _getAuthUrl(data, true);
    var res = await request(
      path: url,
      method: 'POST',
      data: data,
    );

    await handleLoginSuccess(res);

    CurrentUser currentUser = CurrentUser(res.data);
    return currentUser;
  }

  static Future<CurrentUser> register({@required String password, String phone, String username, String email}) async {
    Map<String, String> data = {
      'password': password
    };

    if (email != null) {
      data.addAll({'email': email});
    } else if (phone != null) {
      data.addAll({'phone': phone});
    } else {
      data.addAll({'username': username});
    }

    String url = _getAuthUrl(data);
    Response res = await request(
      path: url,
      method: 'POST',
      data: data,
    );
    await handleLoginSuccess(res);

    CurrentUser currentUser = CurrentUser(res.data);
    return currentUser;
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

  static Future<void> logout() async {
    await request(
      path: Api.logout,
      method: 'POST',
      data: {}, // 不带 data 请求会 415
    );
    await clearSession();
  }

  static Future<CurrentUser> loginWithSmsVerificationCode(
      String mobilePhone, String smsCode,
      {bool createUser = true}) async {
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

    CurrentUser currentUser = CurrentUser(res.data);
    return currentUser;
  }

  static Future<void> requestPasswordReset(String email) async {
    await request(path: Api.passwordReset, method: 'POST', data: {
      'email': email,
    });
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
