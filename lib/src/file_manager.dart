import 'dart:io';
import 'package:dio/dio.dart';

import 'constants.dart';
import 'query.dart';
import 'file.dart';
import 'h_error.dart';
import 'upload.dart';
import 'config.dart';

class FileManager {
  /// 根据文件 ID 获取单个文件
  static Future<CloudFile> get(String fileID) async {
    Response res = await config.request(path: Api.fileDetail, method: 'GET', params: {'fileID': fileID});
    return CloudFile(res.data);
  }

  /// 获取文件列表
  static Future<CloudFileList> find([Query query]) async {
    Map<String, dynamic> data;
    if (query != null) {
      data = query.get();
    }
    Response res = await config.request(
      path: Api.fileList,
      method: 'GET',
      data: data,
    );
    return CloudFileList(res.data);
  }

  /// 删除单个文件或批量删除
  /// [id] 可以为 String 或 List<String> 类型，String 则为单个文件 ID，删除单个文件
  /// List<String> 则为文件 ID 列表，批量删除
  static Future<void> delete(id) async {
    if (id == null) throw HError(604);

    if (id is String) {
      await config.request(path: Api.deleteFile, method: 'DELETE', params: {
        'fileID': id,
      });
    } else if (id is List<String>) {
      await config.request(path: Api.deleteFiles, method: 'DELETE', data: {
        'id__in': id,
      });
    } else {
      throw HError(605);
    }
  }

  /// 根据分类 ID 获取文件分类详情
  static Future<FileCategory> getCategory(String cateID) async {
    Response res = await config.request(
      path: Api.fileCategoryDetail,
      method: 'GET',
      params: {'categoryID': cateID},
    );

    return FileCategory(res.data);
  }

  /// 获取分类列表
  static Future<FileCategoryList> getCategoryList([Query query]) async {
    Map<String, dynamic> data;

    if (query != null) {
      data = query.get();
    }

    Response res = await config.request(
      path: Api.fileCategoryList,
      method: 'GET',
      data: data,
    );

    return FileCategoryList(res.data);
  }

  /// 上传文件
  /// [fileParams] 文件参数
  /// [metaData] 文件元信息
  static Future<CloudFile> upload(
    File file, [
    Map<String, dynamic> metaData,
  ]) async {
    CloudFile data = await uploadFile(file, metaData);
    return data;
  }

  /// 生成视频截图
  /// [params] params 参数
  static Future<Map<String, dynamic>> genVideoSnapshot(Map<String, dynamic> params) async {
    Response response = await config.request(
      path: Api.videoSnapshot,
      method: 'POST',
      data: params,
    );

    return response.data;
  }

  /// M3U8 视频拼接
  /// [params] params 参数
  static Future<Map<String, dynamic>> videoConcat(Map<String, dynamic> params) async {
    Response response = await config.request(
      path: Api.m3u8Concat,
      method: 'POST',
      data: params,
    );

    return response.data;
  }

  /// M3U8 视频剪辑
  /// [params] params 参数
  static Future<Map<String, dynamic>> videoClip(Map<String, dynamic> params) async {
    Response response = await config.request(
      path: Api.m3u8Clip,
      method: 'POST',
      data: params,
    );

    return response.data;
  }

  /// M3U8 时长和分片信息
  /// [params] params 参数
  static Future<Map<String, dynamic>> videoMeta(Map<String, dynamic> params) async {
    Response response = await config.request(
      path: Api.m3u8Meta,
      method: 'POST',
      data: params,
    );

    return response.data;
  }

  /// 音视频的元信息
  /// [params] params 参数
  static Future<Map<String, dynamic>> videoAudioMeta(Map<String, dynamic> params) async {
    Response response = await config.request(
      path: Api.videoAudioMeta,
      method: 'POST',
      data: params,
    );

    return response.data;
  }
}
