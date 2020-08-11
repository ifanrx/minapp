import 'package:dio/dio.dart';
import 'package:minapp/src/constants.dart';
import 'package:minapp/src/request.dart';

import 'h_error.dart';

class CurrentUser {
  Map<String, dynamic> _attribute;
  bool _anonymous;

  CurrentUser(Map attribute) {
    if (attribute is! Map) {
      throw HError(605);
    }

    _initAttribute(attribute);
  }

  void _initAttribute(Map<String, dynamic> attribute) {
    this._attribute = new Map<String, dynamic>.from(attribute);
    this._anonymous = _attribute['_anonymous'];
  }

  String get userId => _attribute['id'].toString();
  String get username => _attribute['_username'];
  String get avatar => _attribute['avatar'];
  String get email => _attribute['_email'];
  String get city => _attribute['city'];
  String get country => _attribute['country'];
  String get gender => _attribute['gender'];
  String get language => _attribute['language'];
  String get nickname => _attribute['nickname'];
  String get openid => _attribute['openid'];
  String get province => _attribute['province'];
  bool get emailVerified => _attribute['_email_verified'];

  bool isAnonymous() {
    return this._anonymous;
  }

  get(String key) {
    return _attribute[key];
  }

  Map<String, dynamic> toJson() {
    return _attribute;
  }

  Future<void> updateUserInfo(Map<String, dynamic> userInfo) async {
    Response res = await request(
      path: Api.updateUser,
      method: 'PUT',
      data: userInfo,
    );

    this._initAttribute(res.data);
  }

  Future<void> updatePassword(String password, String newPassword) async {
    if (_anonymous) {
      throw HError(612);
    }
    await request(
      path: Api.accountInfo,
      method: 'PUT',
      data: {
        'password': password,
        'new_password': newPassword,
      }
    );
  }

  Future<void> setEmail(String email, {bool sendVerificationEmail = false}) async {
    Response res = await request(
      path: Api.accountInfo,
      method: 'PUT',
      data: {
        'email': email,
      }
    );
    this._initAttribute(res.data);

    if (sendVerificationEmail) {
      this.requestEmailVerification();
    }
  }

  Future<void> setUsername(String username) async {
    if (this._anonymous) {
      throw HError(612);
    } else {
      Response res = await request(
        path: Api.accountInfo,
        method: 'PUT',
        data: {
          'username': username,
        }
      );
      this._initAttribute(res.data);
    }
  }

  // 发送验证邮件
  Future<void> requestEmailVerification() async {
    if (this._anonymous) {
      throw HError(612);
    } else {
      await request(
        path: Api.emailVerify,
        method: 'POST',
        data: {},
      );
    }
  }

  // 初次设置账号信息
  Future<void> setAccount([Map<String, dynamic> accountInfo = const {}]) async {
    if (this._anonymous) {
      throw HError(612);
    } else {
      if (accountInfo.containsKey('password')) {
        accountInfo.addAll({'new_password': accountInfo['password']});
        accountInfo.remove('password');
      }
      Response res = await request(
        path: Api.accountInfo,
        method: 'PUT',
        data: accountInfo,
      );

      this._initAttribute(res.data);
    }
  }

  Future<void> setMobilePhone(String phone) async {
    await request(
      path: Api.accountInfo,
      method: 'PUT',
      data: {
        'phone': phone,
      }
    );
  }

  Future<void> verifyMobilePhone(String code) async {
    if (this._anonymous) {
      throw HError(612);
    }
    await request(
      path: Api.phoneVerify,
      method: 'POST',
      data: {
        'code': code,
      }
    );
  }
}