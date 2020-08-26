import 'package:flutter/foundation.dart';

class RecordListBase {
  int _limit;
  int _offset;
  int _totalCount;
  String _next;
  String _previous;

  int get limit => _limit;
  int get offset => _offset;
  int get totalCount => _totalCount;
  String get next => _next;
  String get previous => _previous;

  RecordListBase(Map<String, dynamic> recordInfo) {
    Map<String, dynamic> meta = recordInfo['meta'];
    _limit = meta == null ? recordInfo['limit'] : meta['limit'];
    _offset = meta == null ? recordInfo['offset'] : meta['offset'];
    _totalCount = meta == null ? recordInfo['total_count'] : meta['total_count'];
    _next = meta == null ? recordInfo['next'] : meta['next'];
    _previous = meta == null ? recordInfo['previous'] : meta['previous'];
  }
}

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
  String get mimeType => _file['mime_type'];
  String get mediaType => _file['media_type'];
  String get path => _file['path'];
  String get cdnPath => _file['cdn_path'];
  FileCategory get category => _category;
  int get size => _file['size'];
  int get createdAt => _file['created_at'];
}

class CloudFileList extends RecordListBase {
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
  int get createdAt => category['created_at'];
  int get updatedAt => category['updated_at'];

  FileCategory(this.category);
}

class FileCategoryList extends RecordListBase {
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
