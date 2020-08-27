import 'package:test/test.dart';
import 'package:minapp/minapp.dart';

void main() {
  const List<int> CATEGORIES = [1513076252710475];
  const String CONTENT = '<h1 style="text-align: center;">iPhone&nbsp;</h1>';
  const String COVER = null;
  const int CREATED_AT = 1513076305;
  const int CREATED_BY = 16042162;
  const String DESCRIPTION = 'iPhone XS/XS Max 发布';
  const int GROUP_ID = 1513076211190694;
  const int ID = 1513076305938456;
  const String POINTER_TEST_ORDER = null;
  const String POINTER_USER = null;
  const String POINTER_USER_PROFILE = null;
  const String STRING = 'a';
  const List<String> TAGS = [];
  const int TEST = 234567;
  const String TITLE = 'iPhone XS/XS Max';
  const int UPDATED_AT = 1550109310;
  const int VISIT_COUNT = 43;

  const int LIMIT = 20;
  const String NEXT = null;
  const int OFFSET = 0;
  const String PREVIOUS = null;
  const int TOTAL_COUNT = 9;
  const List<Map<String, dynamic>> OBJECTS = [
    {'id': 1513076211190694, 'name': '最新文章（SDK用，勿删）'},
    {'id': 1515579509101670, 'name': 'ttt'}
  ];
  const List CHILDREN = [
    {'have_children': false, 'id': 1514515552050186, 'name': 'A'},
    {'have_children': false, 'id': 1514515554634507, 'name': 'B'},
    {'have_children': true, 'id': 1514515559200520, 'name': 'C'}
  ];
  const String NAME = '科技';
  const bool HAVE_CHILDREN = true;

  const Map<String, dynamic> contentData = {
    'categories': CATEGORIES,
    'content': CONTENT,
    'cover': COVER,
    'created_at': CREATED_AT,
    'created_by': CREATED_BY,
    'description': DESCRIPTION,
    'group_id': GROUP_ID,
    'id': ID,
    'pointer_test_order': POINTER_TEST_ORDER,
    'pointer_user': POINTER_USER,
    'pointer_userprofile': POINTER_USER_PROFILE,
    'string': STRING,
    'tags': TAGS,
    'test': TEST,
    'title': TITLE,
    'updated_at': UPDATED_AT,
    'visit_count': VISIT_COUNT
  };

  const Map<String, dynamic> contentListData = {
    'meta': {
      'limit': LIMIT,
      'next': NEXT,
      'offset': OFFSET,
      'previous': PREVIOUS,
      'total_count': TOTAL_COUNT
    },
    'objects': OBJECTS
  };

  const Map<String, dynamic> contentCategoryData = {
    'children': CHILDREN,
    'have_children': HAVE_CHILDREN,
    'id': ID,
    'name': NAME
  };

  test('content', () {
    Content content = new Content(contentData);
    expect(content.categories, CATEGORIES);
    expect(content.content, CONTENT);
    expect(content.cover, COVER);
    expect(content.createdAt, CREATED_AT);
    expect(content.createdBy, CREATED_BY);
    expect(content.description, DESCRIPTION);
    expect(content.groupId, GROUP_ID);
    expect(content.id, ID);
    expect(content.title, TITLE);
    expect(content.updatedAt, UPDATED_AT);
    expect(content.visitCount, VISIT_COUNT);
  });

  test('content list', () {
    ContentList contentList = new ContentList(contentListData);
    expect(contentList.limit, LIMIT);
    expect(contentList.next, NEXT);
    expect(contentList.offset, OFFSET);
    expect(contentList.previous, PREVIOUS);
    expect(contentList.totalCount, TOTAL_COUNT);
  });

  test('content category', () {
    ContentCategory contentCategory = new ContentCategory(contentCategoryData);
    expect(contentCategory.children, CHILDREN);
    expect(contentCategory.haveChildren, HAVE_CHILDREN);
    expect(contentCategory.id, ID);
    expect(contentCategory.name, NAME);
  });

  test('content category list', () {
    ContentCategoryList contentCategoryList =
        new ContentCategoryList(contentListData);
    expect(contentCategoryList.limit, LIMIT);
    expect(contentCategoryList.next, NEXT);
    expect(contentCategoryList.offset, OFFSET);
    expect(contentCategoryList.previous, PREVIOUS);
    expect(contentCategoryList.totalCount, TOTAL_COUNT);
  });
}
