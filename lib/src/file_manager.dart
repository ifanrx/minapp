import 'package:dio/dio.dart';
import 'package:minapp/minapp.dart';

import 'request.dart';
import 'constants.dart';
import 'query.dart';

class FileManager {
  static Future get(String fileID) async {
    Response res = await request(
        path: Api.fileList,
        method: 'GET',
        params: {
          'fileID': fileID
        }
    );
    return res.data;
  }

  static Future<List> find([Query query]) async {
    Response res = await request(
      path: Api.fileList,
      method: 'GET',
      data: query == null ? {} : query.get(),
    );
    print(res.request.uri);
    print(res.data);
    print(res.statusCode);
    return res.data['objects'];
  }

  static Future<void> delete(id) async {
    if (id == null) throw HError(604);

    if (id is String) {
      await request(
        path: Api.deleteFile,
        method: 'DELETE',
        params: {
          'fileID': id,
        }
      );
    } else if (id is List) {
      Response res = await request(
        path: Api.deleteFiles,
        method: 'DELETE',
        data: {
          'id__id': id.join(','),
        }
      );
    } else {
      throw HError(605);
    }
  }

  int count() {

  }
}
