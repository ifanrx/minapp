import 'dart:io';
import 'package:example/pages/common.dart';
import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart';
import 'package:file_picker/file_picker.dart';
import '../components/custom_button.dart';

class FilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('文件')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Column(
            children: <Widget>[
              FileListView(),
            ],
          ),
        ),
      ),
    );
  }
}

class FileListView extends StatefulWidget {
  @override
  _FileListView createState() => _FileListView();
}

class _FileListView extends State<FileListView> {
  CloudFileList fileList;
  List selectedFile = [];
  FileCategoryList categoryList;
  String orderBy, currentCate, currentFileID, defaultCateID, currentCateName;
  Map<String, dynamic> cateAll = {};
  int limit, offset;
  int cateLimit, cateOffset;
  List<String> orderByList = [
    'name',
    '-name',
    'size',
    '-size',
    'created_at',
    '-created_at'
  ];

  Future<void> fetchFileList() async {
    try {
      Query query = Query();
      query
        ..limit(limit ?? 10)
        ..offset(offset ?? 0);
      if (orderBy != null) {
        query.orderBy(orderBy);
      }
      if (currentCate != null) {
        Where where = Where.compare(CloudFileList.QUERY_CATEGORY_ID, '=', currentCate);
        query.where(where);
      }

      CloudFileList files = await FileManager.find(query);
      setState(() {
        fileList = files;
        currentFileID = fileList.files.length > 0 ? fileList.files[0].id : null;
        selectedFile.clear();
      });
    } on HError catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  Future<void> fetchCategoryList() async {
    try {
      FileCategoryList list = await FileManager.getCategoryList();
      setState(() {
        categoryList = list;
        defaultCateID = categoryList?.fileCategories[0]?.id;
      });
    } on HError catch (e) {
      showSnackBar(e.toString(), context);
    }
  }
  void uploadFileWithName() async {
    try {
      Map<String, dynamic> metaData = {
        'categoryName': currentCateName,
      };
      File file = await FilePicker.getFile();
      await FileManager.upload(file, metaData);
      showSnackBar('文件上传成功', context);
    } catch (e) {
      showSnackBar('获取文件失败', context);
    }
  }

  void uploadFileWithId() async {
    try {
      Map<String, dynamic> metaData = {
        'categoryID': currentCate,
      };
      File file = await FilePicker.getFile();
      await FileManager.upload(file, metaData);
      showSnackBar('文件上传成功', context);
    } catch (e) {
      showSnackBar('获取文件失败', context);
    }
  }

  Widget _listItemBuilder(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: CheckboxListTile(
            value: selectedFile.contains(fileList.files[index].id),
            title: Text(
              fileList.files[index].name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            controlAffinity: ListTileControlAffinity.leading,
            isThreeLine: false,
            onChanged: (isChecked) {
              if (isChecked) {
                setState(() {
                  selectedFile.add(fileList.files[index].id);
                });
              } else {
                setState(() {
                  selectedFile.remove(fileList.files[index].id);
                });
              }
            },
          ),
        ),
        GestureDetector(
          onTap: () async {
            try {
              await FileManager.delete(fileList.files[index].id);
              showSnackBar('删除成功', context);
              fetchFileList();
            } on HError catch (e) {
              showSnackBar(e.toString(), context);
            }
          },
          child: Text('删除'),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    fetchFileList();
    fetchCategoryList();
  }

  _handleOrderByChange(v) {
    setState(() {
      orderBy = v;
    });
    fetchFileList();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomButton(
          uploadFileWithName,
          title: '上传文件(cate name)',
        ),
        CustomButton(
          uploadFileWithId,
          title: '上传文件(cate id)',
        ),
        SectionTitle('分类列表'),
        Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Text(
                  'limit',
                  style: TextStyle(fontSize: 16),
                ),
                alignment: Alignment.topLeft,
              ),
              NumberInputWithIncrementDecrement(
                width: 100,
                alignment: Alignment.bottomLeft,
                onChange: (v) {
                  setState(() {
                    cateLimit = v;
                  });
                  fetchFileList();
                },
              ),
              Container(
                child: Text(
                  'offset',
                  style: TextStyle(fontSize: 16),
                ),
                alignment: Alignment.topLeft,
              ),
              NumberInputWithIncrementDecrement(
                width: 100,
                alignment: Alignment.bottomLeft,
                onChange: (v) {
                  setState(() {
                    cateOffset = v;
                  });
                  fetchFileList();
                },
              ),
              Container(
                height: 20.0,
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryList != null ? categoryList.fileCategories.length : 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: GestureDetector(
                        child: Container(
                          child: Text(
                            categoryList.fileCategories[index].name,
                            style: TextStyle(color: categoryList.fileCategories[index].id == currentCate ? Colors.red : Colors.black),
                          ),
                          padding: EdgeInsets.only(right: 5.0, left: 5.0),
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                  style: BorderStyle.solid,
                                )
                              )
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            currentCate = categoryList.fileCategories[index].id;
                            currentCateName =
                                categoryList.fileCategories[index].name;
                          });
                          fetchFileList();
                        },
                      ),
                    );
                  },
                ),
              ),
              RaisedButton(
                child: Text('全部'),
                onPressed: () {
                  setState(() {
                    currentCate = null;
                  });
                  fetchFileList();
                },
              )
            ],
          ),
        ),
        SectionTitle('文件列表'),
        Wrap(
          spacing: 10.0,
          children: <Widget>[
            RaisedButton(
              child: Text('删除'),
              onPressed: selectedFile.length <= 0
                  ? null
                  : () async {
                      try {
                        await FileManager.delete(selectedFile);
                        fetchFileList();
                        showSnackBar('删除成功', context);
                      } on HError catch (e) {
                        showSnackBar(e.toString(), context);
                      }
                    },
            ),
          ],
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            children: <Widget>[
              Container(
                child: Text(
                  'order_by',
                  style: TextStyle(fontSize: 16),
                ),
                alignment: Alignment.topLeft,
              ),
              Wrap(
                spacing: 10.0,
                direction: Axis.horizontal,
                runSpacing: 10.0,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: orderByList.map((o) => Container(
                  width: 150.0,
                  height: 50.0,
                  child: RadioListTile<String>(
                    title: Text(o),
                    value: o,
                    groupValue: orderBy,
                    onChanged: _handleOrderByChange,
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  'order_by',
                  style: TextStyle(fontSize: 16),
                ),
                alignment: Alignment.topLeft,
              ),
              NumberInputWithIncrementDecrement(
                width: 100,
                alignment: Alignment.bottomLeft,
                onChange: (v) {
                  setState(() {
                    limit = v;
                  });
                  fetchFileList();
                },
              ),
              Container(
                child: Text(
                  'offset',
                  style: TextStyle(fontSize: 16),
                ),
                alignment: Alignment.topLeft,
              ),
              NumberInputWithIncrementDecrement(
                width: 100,
                alignment: Alignment.bottomLeft,
                onChange: (v) {
                  setState(() {
                    offset = v;
                  });
                  fetchFileList();
                },
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Colors.grey,
          )),
          child: SizedBox(
            height: 300.0,
            width: 350.0,
            child: ListView.separated(
              itemCount: fileList == null ? 0 : fileList.files.length,
              itemBuilder: _listItemBuilder,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(color: Colors.grey),
            ),
          ),
        ),
        Container(
          child: Column(
            children: currentFileID == null ? [] : <Widget>[
              SectionTitle('获取文件详情'),
              SectionTitle('record id = $currentFileID'),
              RaisedButton(
                child: Text('获取文件详情'),
                onPressed: () async {
                  try {
                    CloudFile file = await FileManager.get(currentFileID);
                    alert(context, 'name: ${file.name}, category: ${file.category}, mime_type: ${file.mimeType}');
                  } on HError catch(e) {
                    showSnackBar(e.toString(), context);
                  }
                },
              )
            ],
          ),
        ),
        Container(
          child: Column(
            children: defaultCateID == null ? [] : <Widget>[
              SectionTitle('文件分类'),
              SectionTitle('cate id = $defaultCateID'),
              RaisedButton(
                child: Text('获取分类详情'),
                onPressed: () async {
                  try {
                    FileCategory cate = await FileManager.getCategory(defaultCateID);
                    alert(context, 'id: ${cate.id}, name: ${cate.name}, files: ${cate.files}');
                  } on HError catch(e) {
                    showSnackBar(e.toString(), context);
                  }
                },
              ),
              RaisedButton(
                child: Text('获取分类下所有文件'),
                onPressed: () async {
                  try {
                    Where where = Where.compare(CloudFileList.QUERY_CATEGORY_ID, '=', currentCate);
                    Query query = Query()..where(where);
                    CloudFileList files = await FileManager.find(query);
                    alert(context, files.files.length.toString());
                  } on HError catch(e) {
                    showSnackBar(e.toString(), context);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
