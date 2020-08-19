import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        title,
        style: TextStyle(color: Colors.red, fontSize: 18),
      ),
      margin: EdgeInsets.only(top: 30.0),
      padding: EdgeInsets.only(left: 20.0),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
        color: Colors.red,
        width: 3,
        style: BorderStyle.solid,
      ))),
    );
  }
}

void showSnackBar(String message, BuildContext context) {
  Scaffold.of(context).removeCurrentSnackBar();
  var snackBar = SnackBar(content: Text(message));
  Scaffold.of(context).showSnackBar(snackBar);
}

class NumberInputWithIncrementDecrement extends StatefulWidget {
  final double width;
  final AlignmentGeometry alignment;
  final onChange;
  NumberInputWithIncrementDecrement(
      {this.width, this.alignment, this.onChange});

  @override
  _NumberInputWithIncrementDecrementState createState() =>
      _NumberInputWithIncrementDecrementState();
}

class _NumberInputWithIncrementDecrementState
    extends State<NumberInputWithIncrementDecrement> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = "0"; // Setting the initial value for the field.
  }

  void handleChange(int value) {
    if (widget.onChange != null) {
      widget.onChange(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      alignment: widget.alignment,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              controller: _controller,
              keyboardType: TextInputType.numberWithOptions(
                decimal: false,
                signed: true,
              ),
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              onChanged: (v) {
                handleChange(int.parse(v));
              },
            ),
          ),
          Container(
            height: 38.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: InkWell(
                    child: Icon(
                      Icons.arrow_drop_up,
                      size: 18.0,
                    ),
                    onTap: () {
                      int currentValue = int.parse(_controller.text);
                      setState(() {
                        currentValue++;
                        _controller.text =
                            currentValue.toString(); // incrementing value
                      });
                      handleChange(currentValue);
                    },
                  ),
                ),
                InkWell(
                  child: Icon(
                    Icons.arrow_drop_down,
                    size: 18.0,
                  ),
                  onTap: () {
                    int currentValue = int.parse(_controller.text);
                    setState(() {
                      currentValue--;
                      _controller.text = (currentValue > 0 ? currentValue : 0)
                          .toString(); // decrementing value
                    });
                    handleChange(currentValue);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showSimpleDialog(BuildContext context, String content) {
  showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            Text(content),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('关闭'),
                  )
                ],
              ),
            )
          ],
        );
      });
}

void alert(
  BuildContext context,
  String content, {
  String title = '',
  String confirmText = '确定',
}) {
  showDialog(
    context: context,
    builder: (_) => new AlertDialog(
      title: new Text(title),
      content: new Text(content),
      actions: <Widget>[
        FlatButton(
          child: Text(confirmText),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    ),
  );
}
