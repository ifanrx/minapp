import 'package:dio/dio.dart';
import 'h_error.dart';
import 'request.dart';
import 'constants.dart';
import 'query.dart';
import 'where.dart';

class ContentGroup {
  int _contentGroupID;

  ContentGroup(int contentGroupID) {
    _contentGroupID = contentGroupID;
  }

  /// 获取内容库列表
  /// [withCount] 是否返回 total_count
  /// [offset] 偏移量
  /// [limit] 最大返回条数
  static Future<Map<String, dynamic>> find({
    bool withCount = true,
    int offset = 0,
    int limit = 20,
  }) async {
    Response response = await request(
      path: Api.contentGroupList,
      method: 'GET',
      data: {
        'offset': offset,
        'limit': limit,
        'return_total_count': withCount ? 1 : 0
      },
    );

    return response.data;
  }

  /// 获取内容库详情
  /// [contentGroupID] 内容库 ID
  static Future<Map<String, dynamic>> get(int contentGroupID) async {
    Response response = await request(
      path: Api.contentGroupDetail,
      method: 'GET',
      params: {
        'contentGroupID': contentGroupID,
      },
    );

    return response.data;
  }

  /// 获取内容
  /// [richTextID] 内容 ID
  /// [select] 筛选字段
  /// [expand] 扩展字段
  Future<Map<String, dynamic>> getContent(
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

    Response response = await request(
      path: Api.contentDetail,
      method: 'GET',
      params: {'richTextID': richTextID},
      data: data,
    );

    return response.data;
  }

  /// 获取内容库列表
  /// [query] 查询条件
  /// [withCount] 是否返回 total_count
  Future<Map<String, dynamic>> query({
    Query query,
    bool withCount = false,
  }) async {
    Map<String, dynamic> data = {
      'return_total_count': withCount ? 1 : 0,
      'content_group_id': _contentGroupID,
    };

    if (query != null) {
      Map<String, dynamic> queryData = query.get();

      queryData.forEach((key, value) {
        if (value != null) {
          if (value is Where) {
            data[key] = value.get();
          } else {
            data[key] = value;
          }
        }
      });
    }

    Response response = await request(
      path: Api.contentList,
      method: 'GET',
      data: data,
    );

    return response.data;
  }

  /// 获取数据记录数量
  /// [query] 查询条件
  Future<int> count({Query query}) async {
    query = query != null ? query : new Query();
    query.limit(1);
    Map<String, dynamic> data = await this.query(query: query, withCount: true);

    int count = data['meta']['total_count'];
    return count;
  }

  /// 获取分类详情
  /// [categoryID] 分类 ID
  Future<Map<String, dynamic>> getCategory(int categoryID) async {
    Where where = Where.compare('group_id', '=', _contentGroupID);

    Response response = await request(
      path: Api.contentCategoryDetail,
      method: 'GET',
      params: {
        'categoryID': categoryID,
      },
      data: {
        'where': where.get(),
      },
    );

    return response.data;
  }

  /// 获取内容分类列表
  Future<Map<String, dynamic>> getCategoryList({bool withCount = false}) async {
    Response response = await request(
      path: Api.contentCategoryList,
      method: 'GET',
      data: {
        'content_group_id': _contentGroupID,
        'limit': 100,
        'return_total_count': withCount ? 1 : 0
      },
    );

    return response.data;
  }
}
