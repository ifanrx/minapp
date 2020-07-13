import 'package:flutter/material.dart';
import 'package:minapp/minapp.dart' as BaaS;
import 'pages/index.dart';

void main() {
  BaaS.init(
    '995140f59511a222c937',
    host: 'https://i-v5204.eng.szx.ifanrx.com',
  );

  runApp(MaterialApp(
    title: '测试应用',
    home: IndexPage(),
  ));
}
