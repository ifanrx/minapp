class GeoPoint {
  num _longitude;
  num _latitude;
  Map<String, dynamic> _geoJSON;

  num get longitude => _longitude;
  num get latitude => _latitude;
  Map<String, dynamic> get geoJSON => _geoJSON;

  GeoPoint(num longitude, num latitude) {
    _longitude = longitude;
    _latitude = latitude;
    _geoJSON = {
      'type': 'Point',
      'coordinates': [_longitude, _latitude]
    };
  }
}
