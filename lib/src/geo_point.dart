import 'package:flutter/cupertino.dart';

class GeoPoint {
  num longitude;
  num latitude;
  Map<String, dynamic> geoJSON;

  GeoPoint({@required this.longitude, @required this.latitude}) {
    this.geoJSON = {
      'type': 'Point',
      'coordinates': [this.longitude, this.latitude]
    };
  }
}
