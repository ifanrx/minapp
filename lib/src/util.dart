import 'auth.dart';
import 'config.dart';
import 'h_error.dart';

Future<Map<String, dynamic>> mergeRequestHeader(Map<String, dynamic> headers) async {
  if (config.clientID == null) {
    throw HError(602);
  }

  headers = headers ?? {};

  if (config.env != null) {
    headers['X-Hydrogen-Env-ID'] = config.env;
  }

  headers['X-Hydrogen-Client-ID'] = config.clientID;
  headers['X-Hydrogen-Client-Version'] = config.version;
  headers['X-Hydrogen-Client-Platform'] = config.platform;
  headers['X-Hydrogen-Client-SDK-Type'] = config.sdkType;

  var token = await getAuthToken();

  if (token != null) {
    headers['Authorization'] = '${config.authPrefix} $token';
  }

  return headers;
}
