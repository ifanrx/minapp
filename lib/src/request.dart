import 'package:dio/dio.dart';
import 'util.dart';
import 'config.dart';
import 'h_error.dart';

final _dio = new Dio();

Map<String, dynamic> requestConfig;

RegExp _urlPat = RegExp(r'https?:\/\/');
bool _isUrl(String input) {
  return _urlPat.hasMatch(input);
}

RegExp _slashEndPat = RegExp(r'\/$');
RegExp _slashStartPat = RegExp(r'^\/');

String _join(String a, String b) {
  return '${a.replaceFirst(_slashEndPat, '')}/${b.replaceFirst(_slashStartPat, '')}';
}

Future<Response<T>> request<T>({
  String path,
  String method = 'GET',
  Map<String, dynamic> params,
  dynamic data,
  Map<String, dynamic> headers,
}) async {
  if (config.clientID == null) {
    throw HError(602);
  }

  restoreRequestConfig();
  requestConfig['data'] = data;
  requestConfig['params'] = params;

  var merged = await mergeRequestHeader(headers);

  Options options = Options(
    method: method,
    headers: merged,
  );

  if (params != null) {
    path = _toPath(path, params);
  }

  if (!_isUrl(path)) {
    path = _join(config.host, path);
  }

  try {
    if (method.toUpperCase() == 'GET') {
      return await _dio.request(path, queryParameters: data, options: options);
    }

    return await _dio.request(path, data: data, options: options);
  } on DioError catch (e) {
    if (e.response != null) {
      var msg = _extractErrorMsg(e.response);
      throw HError(e.response.statusCode, msg);
    } else {
      throw HError(601);
    }
  }
}

String _extractErrorMsg(Response<dynamic> res) {
  if (res.statusCode == 404) {
    return 'not found';
  }
  if (res.data is String) {
    return res.data.length > 0 ? res.data : res.statusMessage;
  }
  if (res.data != null &&
      (res.data['error_msg'] != null || res.data['error_message'] != null) || res.data['error'] != null) {
    if (res.data['error'] != null) return res.data['error'];
    return res.data['error_msg'] != null
        ? res.data['error_msg'] as String
        : res.data['error_message'] as String;
  }
  if (res.data != null && res.data['message'] != null) {
    return res.data['message'] as String;
  }
  return '';
}

String _toPath(String path, Map<String, dynamic> params) {
  params.forEach((key, value) {
    var v = Uri.encodeComponent(value.toString());

    var qsPat = RegExp(r'(&?)' + key + r'=:' + key);
    if (value != null) {
      path = path.replaceAllMapped(qsPat, (m) {
        return '${m[1]}$key=$v';
      });
    } else {
      path = path.replaceAllMapped(qsPat, (m) => '');
    }

    var pPat = RegExp(r':' + key);
    path = path.replaceAll(pPat, v);
  });
  return path;
}

void restoreRequestConfig() {
  requestConfig = {};
}
