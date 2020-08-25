import 'dart:convert';

import 'package:dio/dio.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'request.dart';
import 'constants.dart';

/// 获取上传文件配置信息
/// [fileName] 文件名
/// [metaData] 元信息
Future<dynamic> getUploadFileConfig(
  String fileName, [
  Map<String, dynamic> metaData,
]) async {
  metaData = metaData ?? {};
  metaData['filename'] = fileName;

  Response response = await request(
    path: Api.upload,
    method: 'POST',
    data: metaData,
  );

  return response.data;
}

/// 调用又拍云上传
/// [file] 文件
/// [metaData] 元信息
Future<dynamic> uploadFile(
  File file, [
  Map<String, dynamic> metaData,
]) async {
  String filePath = file.path;
  String fileName = basename(filePath);

  Map<String, dynamic> newMetadata = {};
  metaData.forEach((key, value) {
    if (key == 'categoryID') newMetadata['category_id'] = value;
    if (key == 'categoryName') newMetadata['category_name'] = value;
  });

  // 上传前先获取配置信息
  Map<String, dynamic> fileConfig =
      await getUploadFileConfig(fileName, newMetadata);

  Map<String, dynamic> config = {
    'id': fileConfig['id'],
    'fileName': fileName,
    'policy': fileConfig['policy'],
    'authorization': fileConfig['authorization'],
    'uploadUrl': fileConfig['upload_url'],
    'filePath': fileName,
    'destLink': fileConfig['path'],
  };

  FormData formData = FormData.fromMap({
    "policy": config['policy'],
    "authorization": config['authorization'],
    "file": await MultipartFile.fromFile(filePath, filename: fileName)
  });

  Response response = await new Dio().post(config['uploadUrl'], data: formData);
  Map<String, dynamic> data = jsonDecode(response.data);
  Map<String, dynamic> result = {
    'id': config['id'],
    'path': config['destLink'],
    'name': config['fileName'],
    'created_at': data['time'],
    'mime_type': data['mimetype'],
    'cdn_path': data['url'],
    'size': data['file_size'],
  };
  return result;
}
