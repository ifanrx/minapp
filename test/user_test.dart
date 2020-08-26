import 'package:test/test.dart';

import 'package:minapp/src/user.dart';

void main() {
  const String USERNAME = 'abc';
  const int ID = 1234567890;
  const String NICKNAME = 'hello';
  const int GENDER = 1;
  const String EMAIL = 'email';
  const String AVATAR = 'avatar';
  const bool ANONYMOUS = false;
  const String CITY = 'city';
  const String COUNTRY = 'country';
  const String LANGUAGE = 'language';
  const String OPENID = 'openid';
  const String PROVINCE = 'province';
  const bool EMAIL_VERIFIED = false;
  const int AGE = 33;
  const bool CUSTOM_BOOL = false;

  Map<String, dynamic> userInfo = {
    '_username': USERNAME,
    'id': ID,
    'nickname': NICKNAME,
    'avatar': AVATAR,
    '_email': EMAIL,
    '_anonymous': ANONYMOUS,
    'gender': GENDER,
    'city': CITY,
    'country': COUNTRY,
    'language': LANGUAGE,
    'openid': OPENID,
    'province': PROVINCE,
    '_email_verified': EMAIL_VERIFIED,
    'age': AGE,
    'custom_bool': CUSTOM_BOOL,
  };

  test('get user info', () {
    User user = User(userInfo);

    expect(user.username, USERNAME);
    expect(user.userId, ID.toString());
    expect(user.nickname, NICKNAME);
    expect(user.avatar, AVATAR);
    expect(user.email, EMAIL);
    expect(user.isAnonymous, ANONYMOUS);
    expect(user.gender, GENDER);
    expect(user.city, CITY);
    expect(user.country, COUNTRY);
    expect(user.language, LANGUAGE);
    expect(user.openid, OPENID);
    expect(user.province, PROVINCE);
    expect(user.emailVerified, EMAIL_VERIFIED);
    expect(user.get('age'), AGE);
    expect(user.get('custom_bool'), CUSTOM_BOOL);
  });

  test('currentUser', () {
    CurrentUser user = CurrentUser(userInfo);

    expect(user.username, USERNAME);
    expect(user.userId, ID.toString());
    expect(user.nickname, NICKNAME);
    expect(user.avatar, AVATAR);
    expect(user.email, EMAIL);
    expect(user.isAnonymous, ANONYMOUS);
    expect(user.gender, GENDER);
    expect(user.city, CITY);
    expect(user.country, COUNTRY);
    expect(user.language, LANGUAGE);
    expect(user.openid, OPENID);
    expect(user.province, PROVINCE);
    expect(user.emailVerified, EMAIL_VERIFIED);
    expect(user.get('age'), AGE);
    expect(user.get('custom_bool'), CUSTOM_BOOL);
  });
}
