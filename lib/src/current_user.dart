part of "user.dart";

class CurrentUser extends User {
  CurrentUser(Map<String, dynamic> attribute) : super(attribute);

  /// 更新用户信息
  /// [userInfo] 需要更新的用户信息
  Future<void> updateUserInfo(Map<String, dynamic> userInfo) async {
    Response res = await config.request(
      path: Api.updateUser,
      method: 'PUT',
      data: userInfo,
    );

    this._attribute = res.data;
  }

  /// 更新密码
  Future<void> updatePassword(String password, String newPassword) async {
    if (this.isAnonymous) {
      throw HError(612);
    }
    await config.request(path: Api.accountInfo, method: 'PUT', data: {
      'password': password,
      'new_password': newPassword,
    });
  }

  /// 更新邮箱
  /// [email] email 地址
  /// [sendVerificationEmail] 是否发送验证邮件，默认 false
  Future<void> setEmail(String email,
      {bool sendVerificationEmail = false}) async {
    Response res =
        await config.request(path: Api.accountInfo, method: 'PUT', data: {
      'email': email,
    });

    this._attribute['_email'] = email;

    if (sendVerificationEmail) {
      this.requestEmailVerification();
    }
  }

  /// 设置用户名
  /// [username] 新用户名
  Future<void> setUsername(String username) async {
    if (this.isAnonymous) {
      throw HError(612);
    } else {
      Response res =
          await config.request(path: Api.accountInfo, method: 'PUT', data: {
        'username': username,
      });

      this._attribute['_username'] = username;
    }
  }

  /// 设置用户头像
  /// [avatar] 新用户头像
  Future<void> setAvatar(String avatar) async {
    if (this.isAnonymous) {
      throw HError(612);
    } else {
      Response res =
          await config.request(path: Api.accountInfo, method: 'PUT', data: {
        'avatar': avatar,
      });

      this._attribute = res.data;
    }
  }

  /// 发送验证邮件
  Future<void> requestEmailVerification() async {
    if (this.isAnonymous) {
      throw HError(612);
    } else {
      await config.request(
        path: Api.emailVerify,
        method: 'POST',
        data: {},
      );
    }
  }

  /// 初次设置账号信息
  /// [accountInfo]
  Future<void> setAccount([Map<String, dynamic> accountInfo = const {}]) async {
    if (this.isAnonymous) {
      throw HError(612);
    } else {
      if (accountInfo.containsKey('password')) {
        accountInfo.addAll({'new_password': accountInfo['password']});
        accountInfo.remove('password');
      }
      Response res = await config.request(
        path: Api.accountInfo,
        method: 'PUT',
        data: accountInfo,
      );

      this._attribute = res.data;
    }
  }

  /// 更改手机号码
  /// [phone] 新的手机号码
  Future<void> setMobilePhone(String phone) async {
    Response res =
        await config.request(path: Api.accountInfo, method: 'PUT', data: {
      'phone': phone,
    });

    this._attribute['_phone'] = phone;
  }

  /// 验证手机号
  /// [code] 短信验证码
  Future<void> verifyMobilePhone(String code) async {
    if (this.isAnonymous) {
      throw HError(612);
    }
    await config.request(path: Api.phoneVerify, method: 'POST', data: {
      'code': code,
    });
  }
}
