import 'package:example/pages/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart';

class FilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map obj = {1: 123, 'abc': 123};
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
  List fileList = [];
  List selectedFile = [];
  String orderBy;
  int limit, offset;
  List<String> orderByList = ['name', '-name', 'size', '-size', 'created_at', '-created_at'];

  Future<void> fetchFileList() async {
    try {
      Query query = Query();
      query
        ..limit(limit ?? 10)
        ..offset(offset ?? 0)
        ..orderBy(orderBy)
        ..returnTotalCount(1);

      List files = await FileManager.find(query);
      setState(() {
        fileList = files;
        selectedFile.clear();
      });
    } on HError catch(e) {
      showSnackBar(e.toString(), context);
    }
  }

  Widget _listItemBuilder(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: CheckboxListTile(
            value: selectedFile.contains(fileList[index]['id']),
            title: Text(
              fileList[index]['name'],
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            controlAffinity: ListTileControlAffinity.leading,
            isThreeLine: false,
            onChanged: (isChecked) {
              if (isChecked) {
                setState(() {
                  selectedFile.add(fileList[index]['id']);
                });
              } else {
                setState(() {
                  selectedFile.remove(fileList[index]['id']);
                });
              }
            },
          ),
        ),
        GestureDetector(
          onTap: () async {
            try {
              await FileManager.delete(fileList[index]['id']);
              showSnackBar('删除成功', context);
              fetchFileList();
            } on HError catch(e) {
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
  }

  _handleOrderByChange(v) {
    setState(() {
      orderBy = v;
    });
    fetchFileList();
  }

  List<Widget> _orderByRadioList() {
    return orderByList.map((o) => RadioListTile<String>(
      title: Text(o),
      value: o,
      groupValue: orderBy,
      onChanged: _handleOrderByChange,
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionTitle('文件列表'),
        Wrap(
          spacing: 10.0,
          children: <Widget>[
            RaisedButton(
              child: Text('删除'),
              onPressed: selectedFile.length <=0 ? null : () async {
                try {
                  await FileManager.delete(selectedFile);
                  fetchFileList();
                  showSnackBar('删除成功', context);
                } on HError catch(e) {
                  showSnackBar(e.toString(), context);
                }

              },
            ),
          ],
        ),
        Container(
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
                children: _orderByRadioList(),
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
            )
          ),
          child: SizedBox(
            height: 300.0,
            width: 350.0,
            child: ListView.separated(
              itemCount: fileList.length,
              itemBuilder: _listItemBuilder,
              separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
