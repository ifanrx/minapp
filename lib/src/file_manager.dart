import 'package:dio/dio.dart';

import 'request.dart';
import 'constants.dart';
import 'query.dart';
import 'file.dart';
import 'h_error.dart';

class FileManager {
  static Future<CloudFile> get(String fileID) async {
    Response res = await request(path: Api.fileDetail, method: 'GET', params: {'fileID': fileID});
    return CloudFile(res.data);
  }

  static Future<CloudFileList> find([Query query]) async {
    Map<String, dynamic> data;
    if (query != null) {
      data = query.get();
      if (data['where'] != null) {
        data.update('where', (value) => value.get());
      }
    }
    Response res = await request(
      path: Api.fileList,
      method: 'GET',
      data: data,
    );
    return CloudFileList(res.data);
  }

  static Future<void> delete(id) async {
    if (id == null) throw HError(604);

    if (id is String) {
      await request(path: Api.deleteFile, method: 'DELETE', params: {
        'fileID': id,
      });
    } else if (id is List) {
      await request(path: Api.deleteFiles, method: 'DELETE', data: {
        'id__in': id,
      });
    } else {
      throw HError(605);
    }
  }

  static Future<FileCategory> getCategory(String cateID) async {
    Response res = await request(
      path: Api.fileCategoryDetail,
      method: 'GET',
      params: {'categoryID': cateID},
    );

    return FileCategory(res.data);
  }

  static Future<FileCategoryList> getCategoryList([Query query]) async {
    Map<String, dynamic> data;

    if (query != null) {
      data = query.get();
      if (data['where'] != null) {
        data.update('where', (value) => value.get());
      }
    }

    Response res = await request(
      path: Api.fileCategoryList,
      method: 'GET',
      data: data,
    );

    return FileCategoryList(res.data);
  }
}
