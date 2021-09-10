import 'package:flutter/cupertino.dart';

import 'constants.dart';
import 'config.dart';

/// 发送验证码
/// [phone] 手机号码
/// [signatureID] 签名 ID
Future<void> sendSmsCode({@required String phone, String signatureID}) async {
  Map<String, dynamic> data = {
    'phone': phone,
  };
  if (signatureID != null) {
    data.addAll({'signature_id': signatureID});
  }
  await config.request(
    path: Api.sendSmsCode,
    method: 'POST',
    data: data,
  );
}

/// 验证码验证
/// [phone] 手机号码
/// [code] 验证码
Future<void> verifySmsCode({@required String phone, @required String code}) async {
  await config.request(
    path: Api.verifySmsCode,
    method: 'POST',
    data: {
      'phone': phone,
      'code': code,
    }
  );
}