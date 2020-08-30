import 'package:dio/dio.dart';

Map<String, dynamic> requestConfig;

void restoreRequestConfig() {
  requestConfig = {};
}

Future<Response<T>> testRequest<T>({
  String path,
  String method = 'GET',
  Map<String, dynamic> params,
  dynamic data,
  Map<String, dynamic> headers,
}) async {
  restoreRequestConfig();
  requestConfig['data'] = data;
  requestConfig['params'] = params;
  Response response = Response(
    statusCode: 200,
    data: new Map<String, dynamic>(),
  );
  return response;
}
