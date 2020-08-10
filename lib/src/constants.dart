class StorageKey {
  static const authToken = 'auth_token';
  static const uid = 'uid';
  static const expiresAt = 'expires_at';
  static const isAnonymousUser = 'is_anonymous_user';
}

class Api {
  static const registerUsername = '/hserve/v2.1/register/username/';
  static const registerEmail = '/hserve/v2.1/register/email/';
  static const registerPhone = '/hserve/v2.1/register/phone/';
  static const loginUsername = '/hserve/v2.1/login/username/';
  static const loginEmail = '/hserve/v2.1/login/email/';
  static const loginPhone = '/hserve/v2.1/login/phone/';
  static const loginSms = '/hserve/v2.1/login/sms/';
  static const serverTime = '/hserve/v2.2/server/time/';
  static const userDetail = '/hserve/v2.0/user/info/:userID/';
  static const logout = '/hserve/v2.0/session/destroy/';
  static const sendSmsCode = '/hserve/v2.2/sms-verification-code/';
  static const accountInfo = '/hserve/v2.2/user/account/';
  static const passwordReset = '/hserve/v2.0/user/password/reset/';
  static const anonymousLogin = '/hserve/v2.0/login/anonymous/';
  static const emailVerify = '/hserve/v2.0/user/email-verify/';
  static const phoneVerify = '/hserve/v2.1/sms-phone-verification/';

  static const userList = '/hserve/v2.2/user/info/';
  static const updateUser = '/hserve/v2.4/user/info/';

  static const verifySmsCode = '/hserve/v1.8/sms-verification-code/verify/';
}
