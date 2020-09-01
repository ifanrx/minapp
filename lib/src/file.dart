import 'package:flutter/foundation.dart';
import 'table_record.dart';

class CloudFile {
  final Map<String, dynamic> _file;
  FileCategory _category;

  CloudFile(Map<String, dynamic> file)
      : _file = file {
    if (_file['category'] != null) {
      _category = FileCategory(_file['category']);
    }
  }

  static const String QUERY_CATEGORY_ID = 'category_id';

  String get id => _file['id'];
  String get name => _file['name'];
  String get mime_type => _file['mime_type'];
  String get media_type => _file['media_type'];
  String get path => _file['path'];
  String get cdn_path => _file['cdn_path'];
  FileCategory get category => _category;
  int get size => _file['size'];
  int get created_at => _file['created_at'];
}

class CloudFileList extends RecordListMeta {
  List<CloudFile> _files;

  List<CloudFile> get files => _files;

  CloudFileList(Map<String, dynamic> recordInfo) : super(recordInfo) {
    _files = _initFiles(recordInfo['objects']);
  }

  List<CloudFile> _initFiles(List files) {
    var fileList = List<CloudFile>();
    files.forEach((file) {
      fileList.add(CloudFile(file));
    });

    return fileList;
  }
}

class FileCategory {
  final Map<String, dynamic> category;

  String get id => category['id'];
  String get name => category['name'];
  int get files => category['files'];
  int get created_at => category['created_at'];
  int get updated_at => category['updated_at'];

  FileCategory(this.category);
}

class FileCategoryList extends RecordListMeta {
  List<FileCategory> _categories;

  List<FileCategory> get fileCategories => _categories;

  FileCategoryList(Map<String, dynamic> recordInfo) : super(recordInfo) {
    _categories = _initCategories(recordInfo['objects']);
  }

  List<FileCategory> _initCategories(List categories) {
    var categoryList = List<FileCategory>();
    categories.forEach((file) {
      categoryList.add(FileCategory(file));
    });

    return categoryList;
  }
}
