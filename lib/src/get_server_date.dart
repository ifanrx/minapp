import 'request.dart';
import 'model/server_date.dart';
import 'constants.dart';

Future<ServerDate> getServerDate() async {
  var res = await request(path: Api.serverTime);
  return ServerDate.fromJson(res.data);
}
