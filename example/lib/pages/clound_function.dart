import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart';

import 'common.dart';

class CloudFunctionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('调用云函数')),
      body: Center(
        child: InvokeButtons()
      ),
    );
  }
}

class InvokeButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RaisedButton(
          child: Text('helloWorld'),
          onPressed: () async {
            try {
              var res = await invokeCloudFunction(name: 'helloWorld');
              print(res);
              showSimpleDialog(context, res['data']);
            } on HError catch(e) {
              showSnackBar(e.toString(), context);
            }
          },
        ),
        RaisedButton(
          child: Text('testRequest'),
          onPressed: () async {
            try {
              var res = await invokeCloudFunction(
                  name: 'testRequest',
                  data: {
                    'url': 'https://www.ifanr.com',
                  }
              );
              showSimpleDialog(context, res['data'].toString());
            } on HError catch(e) {
              showSnackBar(e.toString(), context);
            }
          },
        ),
      ],
    );
  }
}
