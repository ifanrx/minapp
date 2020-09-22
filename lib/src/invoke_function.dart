import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'constants.dart';
import 'config.dart';

Future invokeCloudFunction({@required String name, Map<String, dynamic> data, bool sync: true}) async {
  Map<String, dynamic> params = {
    'function_name': name,
    'sync': sync,
  };

  if (data != null) {
    params.addAll({'data': data});
  }

  Response res = await config.request(
    path: Api.cloudFunction,
    method: 'POST',
    data: params,
  );

  return res.data;
}
