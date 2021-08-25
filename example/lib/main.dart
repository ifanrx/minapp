import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart' as BaaS;
import 'pages/index.dart';

void main() {
  BaaS.init('a4d2d62965ddb57fa4d6', env: 'f1eeb28c9552d4c83df1');

  runApp(MaterialApp(
    title: '测试应用',
    home: IndexPage(),
  ));
}
