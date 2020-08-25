import 'package:minapp/src/content_group.dart';

int queryLimitationDefault = 20;

class UploadConfig {
  static const uploadFileKey = 'file';
  static const headerAuth = 'Authorization';
  static const headerClient = 'X-Hydrogen-Client-ID';
  static const headerAuthValue = 'Hydrogen-r1 ';
  static const ua =
      'Mozilla/5.0 (Linux; U; Android 4.0.3; ko-kr; LG-L160L Build/IML74K) AppleWebkit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30';
}

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

  static const createRecord = '/hserve/v2.4/table/:tableID/record/';
  static const createRecordList =
      '/hserve/v2.4/table/:tableID/record/?enable_trigger=:enable_trigger';
  static const updateRecord = '/hserve/v2.4/table/:tableID/record/:recordID/';
  static const updateRecordList =
      '/hserve/v2.4/table/:tableID/record/?limit=:limit&offset=:offset&where=:where&enable_trigger=:enable_trigger&return_total_count=:return_total_count';
  static const deleteRecord = '/hserve/v2.4/table/:tableID/record/:recordID/';
  static const deleteRecordList =
      '/hserve/v2.4/table/:tableID/record/?limit=:limit&offset=:offset&where=:where&enable_trigger=:enable_trigger&return_total_count=:return_total_count';
  static const getRecord = '/hserve/v2.4/table/:tableID/record/:recordID/';
  static const queryRecordList = '/hserve/v2.4/table/:tableID/record/';

  static const cloudFunction = '/hserve/v1/cloud-function/job/';

  static const fileDetail = '/hserve/v2.1/uploaded-file/:fileID/';
  static const fileList = '/hserve/v2.2/uploaded-file/';
  static const deleteFile = '/hserve/v2.1/uploaded-file/:fileID/';
  static const deleteFiles = '/hserve/v2.1/uploaded-file/';

  static const contentGroupList = '/hserve/v2.2/content/group/';
  static const contentGroupDetail =
      '/hserve/v2.2/content/group/:contentGroupID/';
  static const contentDetail = '/hserve/v2.0/content/detail/:richTextID/';
  static const contentList = '/hserve/v2.2/content/detail/';
  static const contentCategoryDetail =
      '/hserve/v2.0/content/category/:categoryID/';
  static const contentCategoryList = '/hserve/v2.2/content/category/';
  static const fileCategoryDetail = '/hserve/v1.3/file-category/:categoryID/';
  static const fileCategoryList = '/hserve/v2.2/file-category/';
  static const upload = '/hserve/v2.1/upload/';
  static const videoSnapshot = '/hserve/v1/media/video-snapshot/';
  static const m3u8Concat = '/hserve/v1/media/m3u8-concat/';
  static const m3u8Clip = '/hserve/v1/media/m3u8-clip/';
  static const m3u8Meta = '/hserve/v1/media/m3u8-meta/';
  static const videoAudioMeta = '/hserve/v1/media/audio-video-meta/';
}
