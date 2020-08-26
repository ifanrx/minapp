import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:minapp/minapp.dart';
import '../components/num_stepper.dart';
import '../components/custom_button.dart';
import '../components/custom_title.dart';
import './common.dart';

class ContentPage extends StatefulWidget {
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  bool _isLoading = false;
  int groupId = 1513076211190694;
  ContentGroup contentGroup;
  List categoryList = [
    {'name': '全部', 'id': 'all'},
  ];
  int limit = 10;
  int offset = 0;
  List contentList = [];
  String orderBy;
  String categoryId = 'all';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    var snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void showLoading(bool isLoading) {
    setState(() => _isLoading = isLoading);
  }

  void getCategoryList() async {
    showLoading(true);
    try {
      var data = await contentGroup.getCategoryList();
      setState(() {
        categoryList.addAll(data.contents);
      });
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void queryContent() async {
    showLoading(true);

    try {
      Query query = new Query();
      query
        ..limit(limit)
        ..offset(offset)
        ..expand(['pointer_test_order']);

      if (orderBy != null) {
        query.orderBy(orderBy);
      }

      if (categoryId != 'all') {
        Where where =
            Where.arrayContains('categories', [int.parse(categoryId)]);
        query.where(where);
      }

      var data = await contentGroup.query(
        query: query,
        withCount: true,
      );

      setState(() {
        contentList = data.contents;
      });
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void queryContentByName() async {
    if (contentList.length < 1) return;

    showLoading(true);

    try {
      Query query = new Query();
      query
        ..limit(limit)
        ..offset(offset);

      Where where = Where.compare('title', '!=', contentList[0]['title']);
      query.where(where);

      var data = await contentGroup.query(
        query: query,
        withCount: true,
      );

      setState(() {
        contentList = data.contents;
      });
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void changeOrderBy(String value) {
    setState(() {
      orderBy = value;
    });
  }

  Function getContent([bool withConfig = false]) {
    return () async {
      if (contentList.length == 0) return;
      showLoading(true);

      try {
        var data = await contentGroup.getContent(
          contentList[0]['id'],
          expand: withConfig ? ['pointer_test_order'] : '',
          select: withConfig ? ['title', 'pointer_test_order'] : '',
        );

        alert(context, '查询成功 - ${data.title}');
      } catch (e) {
        _showSnackBar('失败 - ${e.toString()}');
      }

      showLoading(false);
    };
  }

  void getCategory() async {
    if (categoryList.length <= 1) return;
    showLoading(true);

    try {
      var data = await contentGroup.getCategory(categoryList[1]['id']);
      alert(context,
          '查询成功 - children: ${data.children}, have_children: ${data.haveChildren}, name: ${data.name}, id: ${data.id}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void count() async {
    showLoading(true);

    try {
      int count = await contentGroup.count();
      alert(context, '查询成功 - $count');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void getContentGroupDetail() async {
    showLoading(true);
    try {
      var data = await ContentGroup.get(groupId);
      alert(context, '查询成功 - id: ${data.id}, name: ${data.name}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void getContentGroupList() async {
    showLoading(true);
    try {
      var data = await ContentGroup.find();
      alert(context, '查询成功 - ${data.contents}');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  @override
  void initState() {
    super.initState();
    contentGroup = new ContentGroup(groupId);
    getCategoryList();
    queryContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('内容库')),
      body: LoadingOverlay(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Wrap(
                  children: categoryList.map((category) {
                    return GestureDetector(
                      child: Text(
                        '${category['name']} | ',
                        style: TextStyle(
                          color: categoryId == category['id'].toString()
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                      onTap: () {
                        setState(() => categoryId = category['id'].toString());
                        queryContent();
                      },
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 10.0,
                ),
                CustomTitle('order_by:',
                    textColor: Colors.black, boxHeight: 5.0),
                Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Radio(
                      value: 'title',
                      groupValue: orderBy,
                      onChanged: (value) {
                        changeOrderBy(value);
                      },
                    ),
                    Text(
                      'title',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    Radio(
                      value: '-title',
                      groupValue: orderBy,
                      onChanged: (value) {
                        changeOrderBy(value);
                      },
                    ),
                    Text(
                      '-title',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    Radio(
                      value: 'created_at',
                      groupValue: orderBy,
                      onChanged: (value) {
                        changeOrderBy(value);
                      },
                    ),
                    Text(
                      'created_at',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    Radio(
                      value: '-created_at',
                      groupValue: orderBy,
                      onChanged: (value) {
                        changeOrderBy(value);
                      },
                    ),
                    Text(
                      '-created_at',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                CustomTitle('limit:', textColor: Colors.black, boxHeight: 5.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      NumberStepper(
                        count: limit,
                        size: 30,
                        activeForegroundColor: Colors.white,
                        activeBackgroundColor: Colors.green,
                        didChangeCount: (count) {
                          setState(() {
                            limit = count;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                CustomTitle('offset:', textColor: Colors.black, boxHeight: 5.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      NumberStepper(
                        count: offset,
                        size: 30,
                        activeForegroundColor: Colors.white,
                        activeBackgroundColor: Colors.green,
                        didChangeCount: (count) {
                          setState(() {
                            offset = count;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: new BoxConstraints(
                    maxHeight: 260.0,
                  ),
                  child: Scrollbar(
                    child: ListView(
                      shrinkWrap: true,
                      children: contentList.map((record) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(record['title']),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                CustomButton(queryContent, title: '查找内容'),
                CustomTitle(
                    contentList.length == 0
                        ? '没有文件'
                        : '获取 title != \'${contentList[0]['title']}\' 的内容',
                    boxHeight: 20.0),
                CustomButton(
                    contentList.length == 0 ? null : queryContentByName,
                    title: '获取内容'),
                CustomTitle(
                    contentList.length == 0
                        ? '没有文件'
                        : '获取内容详情 title = \'${contentList[0]['title']}\'',
                    boxHeight: 20.0),
                CustomButton(contentList.length == 0 ? null : getContent(),
                    title: '获取内容详情'),
                CustomButton(contentList.length == 0 ? null : getContent(true),
                    title: '获取内容详情 select & expand'),
                CustomTitle(
                    '获取分类详情 name = \'${categoryList.length > 1 ? categoryList[1]['name'] : ''}\'',
                    boxHeight: 20.0),
                CustomButton(getCategory, title: '获取分类详情'),
                CustomTitle('count', boxHeight: 20.0),
                CustomButton(count, title: 'count 查询'),
                CustomTitle('获取内容库详情', boxHeight: 20.0),
                CustomButton(getContentGroupDetail, title: '获取内容库详情'),
                CustomTitle('获取内容库列表', boxHeight: 20.0),
                CustomButton(getContentGroupList, title: '获取内容库列表'),
              ],
            ),
          ),
        ),
        isLoading: _isLoading,
      ),
    );
  }
}
