part of "user.dart";

class CurrentUser extends User {
  CurrentUser(Map<String, dynamic> attribute) : super(attribute);

  Future<void> updateUserInfo(Map<String, dynamic> userInfo) async {
    Response res = await config.request(
      path: Api.updateUser,
      method: 'PUT',
      data: userInfo,
    );

    this._attribute = res.data;
  }

  Future<void> updatePassword(String password, String newPassword) async {
    if (this.isAnonymous) {
      throw HError(612);
    }
    await config.request(
      path: Api.accountInfo,
      method: 'PUT',
      data: {
        'password': password,
        'new_password': newPassword,
      }
    );
  }

  Future<void> setEmail(String email, {bool sendVerificationEmail = false}) async {
    Response res = await config.request(
      path: Api.accountInfo,
      method: 'PUT',
      data: {
        'email': email,
      }
    );

    this._attribute = res.data;

    if (sendVerificationEmail) {
      this.requestEmailVerification();
    }
  }

  Future<void> setUsername(String username) async {
    if (this.isAnonymous) {
      throw HError(612);
    } else {
      Response res = await config.request(
        path: Api.accountInfo,
        method: 'PUT',
        data: {
          'username': username,
        }
      );

      this._attribute = res.data;
    }
  }

  // 发送验证邮件
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

  // 初次设置账号信息
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

  Future<void> setMobilePhone(String phone) async {
    Response res = await config.request(
      path: Api.accountInfo,
      method: 'PUT',
      data: {
        'phone': phone,
      }
    );

    this._attribute = res.data;
  }

  Future<void> verifyMobilePhone(String code) async {
    if (this.isAnonymous) {
      throw HError(612);
    }
    await config.request(
      path: Api.phoneVerify,
      method: 'POST',
      data: {
        'code': code,
      }
    );
  }
}