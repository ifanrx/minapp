import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Function fn;
  final String title;
  final Color titleColor;
  final Color bgColor;

  CustomButton(
    this.fn, {
    this.title,
    this.titleColor = Colors.white,
    this.bgColor = Colors.green,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 10),
        ButtonTheme(
          height: 50.0,
          child: RaisedButton(
            onPressed: widget.fn,
            child: Text(
              widget.title,
              style: TextStyle(color: widget.titleColor, fontSize: 18.0),
            ),
            color: widget.bgColor,
          ),
        ),
      ],
    );
  }
}
