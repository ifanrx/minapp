import 'storage.dart';
import 'constants.dart';
import 'request.dart';

Future<String> getAuthToken() => storageAsync.get(StorageKey.authToken);

Future login(Map<String, dynamic> data) async {
  var res = await request(
    path: Api.loginUsername,
    method: 'POST',
    data: data,
  );

  print('userid==>');
  print(res.data['user_id']);

  await storageAsync.set(StorageKey.authToken, res.data['token']);
  await storageAsync.set(StorageKey.uid, res.data['user_id'].toString());
  return res.data;
}

Future getCurrentUser () async {
  var id = await storageAsync.get(StorageKey.uid);
  var res = await request(
    path: Api.userDetail,
    params: {'userID': id},
  );
  return res.data;
}
