import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'storage.dart';
import 'constants.dart';
import 'util.dart';
import 'user.dart';
import 'h_error.dart';
import 'config.dart';

class Auth {
  static Future<String> getAuthToken() => storageAsync.get(StorageKey.authToken);

  /// 手机号码登录
  /// [phone] 手机号码
  /// [password] 密码
  static Future<CurrentUser> loginWithPhone({@required String phone, @required String password}) async {
    Response res = await config.request(
      path: Api.loginWithPhone,
      method: 'POST',
      data: {
        'phone': phone,
        'password': password,
      },
    );

    await handleLoginSuccess(res);

    CurrentUser currentUser = CurrentUser(res.data);
    return currentUser;
  }

  /// 用户名登录
  /// [username] 用户名
  /// [password] 密码
  static Future<CurrentUser> loginWithUsername({@required String username, @required String password}) async {
    Response res = await config.request(
      path: Api.loginWithUsername,
      method: 'POST',
      data: {
        'username': username,
        'password': password,
      },
    );

    await handleLoginSuccess(res);

    CurrentUser currentUser = CurrentUser(res.data);
    return currentUser;
  }

  /// 用户名登录
  /// [email] 邮箱地址
  /// [password] 密码
  static Future<CurrentUser> loginWithEmail({@required String email, @required String password}) async {
    Response res = await config.request(
      path: Api.loginWithUsername,
      method: 'POST',
      data: {
        'email': email,
        'password': password,
      },
    );

    await handleLoginSuccess(res);

    CurrentUser currentUser = CurrentUser(res.data);
    return currentUser;
  }

  /// 通过用户名注册
  /// [username] 用户名
  /// [password] 密码
  static Future<CurrentUser> registerWithUsername({@required String username, @required String password}) async {
    Response res = await config.request(
      path: Api.registerWithUsername,
      method: 'POST',
      data: {
        'username': username,
        'password': password,
      },
    );

    await handleLoginSuccess(res);

    CurrentUser currentUser = CurrentUser(res.data);
    return currentUser;
  }

  /// 通过邮箱注册
  /// [email] 邮箱地址
  /// [password] 密码
  static Future<CurrentUser> registerWithEmail({@required String email, @required String password}) async {
    Response res = await config.request(
      path: Api.registerWithEmail,
      method: 'POST',
      data: {
        'email': email,
        'password': password,
      },
    );

    await handleLoginSuccess(res);

    CurrentUser currentUser = CurrentUser(res.data);
    return currentUser;
  }

  /// 通过手机号码注册
  /// [phone] 手机号码
  /// [password] 密码
  static Future<CurrentUser> registerWithPhone({@required String phone, @required String password}) async {
    Response res = await config.request(
      path: Api.registerWithPhone,
      method: 'POST',
      data: {
        'phone': phone,
        'password': password,
      },
    );

    await handleLoginSuccess(res);

    CurrentUser currentUser = CurrentUser(res.data);
    return currentUser;
  }

  /// 获取当前登录用户
  static Future<CurrentUser> getCurrentUser() async {
    var id = await storageAsync.get(StorageKey.uid);
    String expiresAt = await storageAsync.get(StorageKey.expiresAt);
    bool expired = await isSessionExpired();

    if (id == null || expiresAt == null || expired) {
      return throw HError(604);
    }

    var res = await config.request(
      path: Api.userDetail,
      params: {'userID': id},
    );
    CurrentUser currentUser = CurrentUser(res.data);
    return currentUser;
  }

  static Future<void> logout() async {
    await config.request(
      path: Api.logout,
      method: 'POST',
      data: {}, // 不带 data 请求会 415
    );
    await clearSession();
  }

  /// 短信验证码登录
  /// [mobilePhone] 手机号码
  /// [smsCode] 验证码
  /// [createUser] 是否创建用户，默认创建
  static Future<CurrentUser> loginWithSmsVerificationCode(
      String mobilePhone, String smsCode,
      {bool createUser = true}) async {
    Response res = await config.request(
      path: Api.loginWithSms,
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

  /// 重置密码
  /// [email] 邮箱
  static Future<void> requestPasswordReset(String email) async {
    await config.request(
      path: Api.passwordReset,
      method: 'POST',
      data: {
        'email': email,
      },
    );
  }

  /// 匿名登录
  static Future<CurrentUser> anonymousLogin() async {
    Response res = await config.request(
      path: Api.anonymousLogin,
      method: 'POST',
      data: {},
    );
    await handleLoginSuccess(res, true);
    CurrentUser currentUser = await getCurrentUser();
    return currentUser;
  }
}
