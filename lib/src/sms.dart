import 'package:flutter/cupertino.dart';

import 'request.dart';
import 'constants.dart';

Future<void> sendSmsCode({@required String phone, String signatureID}) async {
  Map<String, dynamic> data = {
    'phone': phone,
  };
  if (signatureID != null) {
    data.addAll({'signature_id': signatureID});
  }
  await request(
    path: Api.sendSmsCode,
    method: 'POST',
    data: data,
  );
}

Future<void> verifySmsCode({@required String phone, @required int code}) async {
  await request(
    path: Api.verifySmsCode,
    method: 'POST',
    data: {
      'phone': phone,
      'code': code,
    }
  );
}