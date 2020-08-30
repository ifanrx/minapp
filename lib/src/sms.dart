import 'package:flutter/cupertino.dart';

import 'request.dart';
import 'constants.dart';
import 'config.dart';

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

Future<void> verifySmsCode({@required String phone, @required int code}) async {
  await config.request(
    path: Api.verifySmsCode,
    method: 'POST',
    data: {
      'phone': phone,
      'code': code,
    }
  );
}