import 'package:flutter/material.dart';

class CustomTitle extends StatefulWidget {
  final String title;
  final num boxHeight;
  final Color textColor;

  CustomTitle(
    this.title, {
    this.boxHeight = 10.0,
    this.textColor = Colors.red,
  });

  @override
  _CustomTitleState createState() => _CustomTitleState();
}

class _CustomTitleState extends State<CustomTitle> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: widget.boxHeight),
        Text(
          widget.title,
          style: TextStyle(color: widget.textColor, fontSize: 16.0),
        ),
      ],
    );
  }
}
