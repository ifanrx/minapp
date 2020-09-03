import 'package:dio/dio.dart';
import 'h_error.dart';
import 'constants.dart';
import 'query.dart';
import 'where.dart';
import 'table_record.dart';
import 'config.dart';

class ContentGroup {
  int _contentGroupID;
  Map<String, dynamic> _data = {};

  ContentGroup(int contentGroupID) {
    _contentGroupID = contentGroupID;
  }

  ContentGroup.withInfo(this._data); // 获取内容库详情

  int get id => _data['id'];
  String get name => _data['name'];

  /// 获取内容库列表
  /// [withCount] 是否返回 total_count
  /// [offset] 偏移量
  /// [limit] 最大返回条数
  static Future<ContentList> find({
    bool withCount = false,
    int offset = 0,
    int limit = 20,
  }) async {
    Response response = await config.request(
      path: Api.contentGroupList,
      method: 'GET',
      data: {
        'offset': offset,
        'limit': limit,
        'return_total_count': withCount ? 1 : 0
      },
    );

    return ContentList(response.data);
  }

  /// 获取内容库详情
  /// [contentGroupID] 内容库 ID
  static Future<ContentGroup> get(int contentGroupID) async {
    Response response = await config.request(
      path: Api.contentGroupDetail,
      method: 'GET',
      params: {
        'contentGroupID': contentGroupID,
      },
    );

    return ContentGroup.withInfo(response.data);
  }

  /// 获取内容
  /// [richTextID] 内容 ID
  /// [select] 筛选字段
  /// [expand] 扩展字段
  Future<Content> getContent(
    int richTextID, {
    dynamic select,
    dynamic expand,
  }) async {
    Map<String, dynamic> data = {};

    if (select != null) {
      if (select is String) {
        data['keys'] = select;
      } else if (select is List<String>) {
        data['keys'] = select.join(',');
      } else {
        throw HError(605);
      }
    }

    if (expand != null) {
      if (expand is String) {
        data['expand'] = expand;
      } else if (expand is List<String>) {
        data['expand'] = expand.join(',');
      } else {
        throw HError(605);
      }
    }

    Response response = await config.request(
      path: Api.contentDetail,
      method: 'GET',
      params: {'richTextID': richTextID},
      data: data,
    );

    return Content(response.data);
  }

  /// 获取内容库列表
  /// [query] 查询条件
  /// [withCount] 是否返回 total_count
  Future<ContentList> query({
    Query query,
    bool withCount = false,
  }) async {
    Map<String, dynamic> data = query == null ? {} : query.get();
    data['return_total_count'] = withCount ? 1 : 0;
    data['content_group_id'] = _contentGroupID;

    Response response = await config.request(
      path: Api.contentList,
      method: 'GET',
      data: data,
    );

    return ContentList(response.data);
  }

  /// 获取数据记录数量
  /// [query] 查询条件
  Future<int> count({Query query}) async {
    query = query != null ? query : new Query();
    query.limit(1);
    ContentList data = await this.query(query: query, withCount: true);

    int count = data.totalCount;
    return count;
  }

  /// 获取分类详情
  /// [categoryID] 分类 ID
  Future<ContentCategory> getCategory(int categoryID) async {
    Where where = Where.compare('group_id', '=', _contentGroupID);

    Response response = await config.request(
      path: Api.contentCategoryDetail,
      method: 'GET',
      params: {
        'categoryID': categoryID,
      },
      data: {
        'where': where.get(),
      },
    );

    return ContentCategory(response.data);
  }

  /// 获取内容分类列表
  Future<ContentCategoryList> getCategoryList({bool withCount = false}) async {
    Response response = await config.request(
      path: Api.contentCategoryList,
      method: 'GET',
      data: {
        'content_group_id': _contentGroupID,
        'limit': 100,
        'return_total_count': withCount ? 1 : 0
      },
    );

    return ContentCategoryList(response.data);
  }
}

// 内容详情
class Content {
  Map<String, dynamic> _data;

  Content(this._data);

  List<int> get categories => _data['categories'];
  String get content => _data['content'];
  String get cover => _data['cover'];
  int get created_at => _data['created_at'];
  int get created_by {
    if (_data['created_by'] != null) {
      return _data['created_by'] is int
          ? _data['created_by']
          : _data['created_by']['id'];
    }
    return null;
  }

  Map<String, dynamic> get created_by_map =>
      _data['created_by'] is Map ? _data['created_by'] : null;
  String get description => _data['description'];
  int get group_id => _data['group_id'];
  int get id => _data['id'];
  String get title => _data['title'];
  int get updated_at => _data['updated_at'];
  int get visit_count => _data['visit_count'];
  String get name => _data['name'];
}

// 内容库列表
class ContentList extends RecordListMeta {
  Map<String, dynamic> _data;
  ContentList(this._data) : super(_data);

  List get contents =>
      _data['objects']?.map((object) => Content(object))?.toList();
}

// 内容分类
class ContentCategory {
  Map<String, dynamic> _data;
  ContentCategory(this._data);

  List get children => _data['children'];
  bool get have_children => _data['have_children'];
  int get id => _data['id'];
  String get name => _data['name'];
}

// 内容分类列表
class ContentCategoryList extends RecordListMeta {
  Map<String, dynamic> _data;
  ContentCategoryList(this._data) : super(_data);

  List get contentCategories =>
      _data['objects']?.map((object) => ContentCategory(object))?.toList();
}
