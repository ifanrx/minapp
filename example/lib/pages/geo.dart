import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:minapp/minapp.dart';
import '../components/custom_button.dart';
import '../components/custom_title.dart';
import './common.dart';

class Geo extends StatefulWidget {
  @override
  _GeoState createState() => _GeoState();
}

class _GeoState extends State<Geo> {
  TableObject spot = new TableObject('test_spot');
  bool _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    var snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void showLoading(bool isLoading) {
    setState(() => _isLoading = isLoading);
  }

  void addPoint() async {
    showLoading(true);

    try {
      TableRecord record = spot.create();
      GeoPoint point = new GeoPoint(20, 20);
      record.set('position', point);
      await record.save();
      alert(context, '成功');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void addPolygon1() async {
    showLoading(true);

    try {
      TableRecord record = spot.create();
      GeoPoint point1 = new GeoPoint(10, 10);
      GeoPoint point2 = new GeoPoint(20, 10);
      GeoPoint point3 = new GeoPoint(30, 20);
      GeoPolygon polygon =
          new GeoPolygon(points: [point1, point2, point3, point1]);
      record.set('area', polygon);
      await record.save();
      alert(context, '成功');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  void addPolygon2() async {
    showLoading(true);

    try {
      TableRecord record = spot.create();
      GeoPolygon polygon = new GeoPolygon(coordinates: [
        [10, 10],
        [20, 10],
        [30, 20],
        [10, 10],
      ]);
      record.set('area', polygon);
      await record.save();
      alert(context, '成功');
    } catch (e) {
      _showSnackBar('失败 - ${e.toString()}');
    }

    showLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Schema Geo 类型测试')),
      body: LoadingOverlay(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomTitle('spot 表'),
              CustomButton(
                addPoint,
                title: '添加 point',
              ),
              CustomButton(
                addPolygon1,
                title: '添加 polygon',
              ),
              CustomButton(
                addPolygon2,
                title: '添加 polygon，方式 2',
              ),
            ],
          ),
        ),
        isLoading: _isLoading,
      ),
    );
  }
}
