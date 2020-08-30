import 'package:test/test.dart';

import 'package:minapp/src/file.dart';

void main() {
  const int LIMIT = 20;
  const int OFFSET = 0;
  const int TOTAL_COUNT = 22;
  const String NEXT = 'next';
  const String PREVIOUS = 'previous';

  const String FILE_ID = 'file_id';
  const String FILE_NAME = 'file_name';
  const String MIME_TYPE = 'mime_type';
  const String PATH = 'file_path';
  const String CDN_PATH = 'cdn_path';
  const Map<String, String> CATEGORY = {
    'id': 'category_id',
    'name': 'category_name',
  };
  const int SIZE = 111;
  const int FILE_CREATED_AT = 123455;

  const String CATEGORY_ID = 'category_id';
  const String CATEGORY_NAME = 'category_name';
  const int FILES = 0;
  const int CATEGORY_CREATED_AT = 23456;
  const int CATEGORY_UPDATED_AT = 34567;

  Map<String, dynamic> file = {
    'id': FILE_ID,
    'name': FILE_NAME,
    'mime_type': MIME_TYPE,
    'path': PATH,
    'cdn_path': CDN_PATH,
    'category': CATEGORY,
    'size': SIZE,
    'created_at': FILE_CREATED_AT,
  };

  Map<String, dynamic> category = {
    'id': CATEGORY_ID,
    'name': CATEGORY_NAME,
    'files': FILES,
    'created_at': CATEGORY_CREATED_AT,
    'updated_at': CATEGORY_UPDATED_AT,
  };

  test('class RecordListBase', () {
    Map<String, dynamic> recordListBase = {
      'limit': LIMIT,
      'offset': OFFSET,
      'total_count': TOTAL_COUNT,
      'next': NEXT,
      'previous': PREVIOUS,
    };

    RecordListBase recordList = RecordListBase(recordListBase);

    expect(recordList.limit, LIMIT);
    expect(recordList.offset, OFFSET);
    expect(recordList.totalCount, TOTAL_COUNT);
    expect(recordList.next, NEXT);
    expect(recordList.previous, PREVIOUS);
  });

  test('class CloudFile', () {
    CloudFile cloudFile = CloudFile(file);

    expect(cloudFile.id, FILE_ID);
    expect(cloudFile.name, FILE_NAME);
    expect(cloudFile.path, PATH);
    expect(cloudFile.cdn_path, CDN_PATH);
    expect(cloudFile.category.runtimeType, FileCategory);
    expect(cloudFile.size, SIZE);
    expect(cloudFile.created_at, FILE_CREATED_AT);
  });

  test('class CloudFile without category', () {
    Map<String, dynamic> cloudFileWithoutCategory = Map<String, dynamic>.from(file);
    cloudFileWithoutCategory.remove('category');

    CloudFile cloudFile = CloudFile(cloudFileWithoutCategory);

    expect(cloudFile.category, null);
  });

  test('class FileListBase', () {
    Map<String, dynamic> recordListBase = {
      'limit': LIMIT,
      'offset': OFFSET,
      'total_count': TOTAL_COUNT,
      'next': NEXT,
      'previous': PREVIOUS,
    };
    RecordListBase recordList = RecordListBase(recordListBase);

    expect(recordList.limit, LIMIT);
    expect(recordList.offset, OFFSET);
    expect(recordList.totalCount, TOTAL_COUNT);
    expect(recordList.next, NEXT);
    expect(recordList.previous, PREVIOUS);
  });

  test('class FileList with one file', () {
    List fileList = [file];
    Map<String, dynamic> files = {
      'limit': LIMIT,
      'offset': OFFSET,
      'total_count': TOTAL_COUNT,
      'next': NEXT,
      'previous': PREVIOUS,
      'objects': fileList,
    };
    CloudFileList recordList = CloudFileList(files);

    expect(recordList.limit, LIMIT);
    expect(recordList.offset, OFFSET);
    expect(recordList.totalCount, TOTAL_COUNT);
    expect(recordList.next, NEXT);
    expect(recordList.previous, PREVIOUS);
    expect(recordList.files.length, fileList.length);
  });

  test('class FileList with empty files', () {
    Map<String, dynamic> files = {
      'limit': LIMIT,
      'offset': OFFSET,
      'total_count': TOTAL_COUNT,
      'next': NEXT,
      'previous': PREVIOUS,
      'objects': [],
    };
    CloudFileList recordList = CloudFileList(files);

    expect(recordList.limit, LIMIT);
    expect(recordList.offset, OFFSET);
    expect(recordList.totalCount, TOTAL_COUNT);
    expect(recordList.next, NEXT);
    expect(recordList.previous, PREVIOUS);
    expect(recordList.files.length, 0);
  });

  test('class FileCategory', () {
    FileCategory fileCategory = FileCategory(category);

    expect(fileCategory.id, CATEGORY_ID);
    expect(fileCategory.name, CATEGORY_NAME);
    expect(fileCategory.files, FILES);
    expect(fileCategory.created_at, CATEGORY_CREATED_AT);
    expect(fileCategory.updated_at, CATEGORY_UPDATED_AT);
  });

  test('class FileCategoryList', (){
    List categoryList = [category];
    Map<String, dynamic> categories = {
      'limit': LIMIT,
      'offset': OFFSET,
      'total_count': TOTAL_COUNT,
      'next': NEXT,
      'previous': PREVIOUS,
      'objects': categoryList,
    };

    FileCategoryList fileCategoryList = FileCategoryList(categories);

    expect(fileCategoryList.limit, LIMIT);
    expect(fileCategoryList.offset, OFFSET);
    expect(fileCategoryList.totalCount, TOTAL_COUNT);
    expect(fileCategoryList.next, NEXT);
    expect(fileCategoryList.previous, PREVIOUS);
    expect(fileCategoryList.fileCategories.length, categoryList.length);
  });

  test('class FileCategoryList with empty category', (){
    Map<String, dynamic> categories = {
      'limit': LIMIT,
      'offset': OFFSET,
      'total_count': TOTAL_COUNT,
      'next': NEXT,
      'previous': PREVIOUS,
      'objects': [],
    };

    FileCategoryList fileCategoryList = FileCategoryList(categories);

    expect(fileCategoryList.limit, LIMIT);
    expect(fileCategoryList.offset, OFFSET);
    expect(fileCategoryList.totalCount, TOTAL_COUNT);
    expect(fileCategoryList.next, NEXT);
    expect(fileCategoryList.previous, PREVIOUS);
    expect(fileCategoryList.fileCategories.length, 0);
  });
}
