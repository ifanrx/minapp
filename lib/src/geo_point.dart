class GeoPoint {
  num longitude;
  num latitude;
  Map<String, dynamic> geoJSON;

  GeoPoint({this.longitude, this.latitude}) {
    this.geoJSON = {
      'type': 'Point',
      'coordinates': [this.longitude, this.latitude]
    };
  }
}
