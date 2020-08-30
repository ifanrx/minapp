import 'request.dart';
import 'model/server_date.dart';
import 'constants.dart';
import 'config.dart';

Future<ServerDate> getServerDate() async {
  var res = await config.request(path: Api.serverTime);
  return ServerDate.fromJson(res.data);
}
