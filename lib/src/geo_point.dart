import 'util.dart';

class GeoPoint {
  double longitude;
  double latitude;
  Map geoJSON;

  Map toGeoJSON() {
    // return cloneDeep(this.geoJSON);
  }

  GeoPoint({this.longitude, this.latitude}) {
    this.geoJSON = {
      'type': 'Point',
      'coordinates': [this.longitude, this.latitude]
    };
  }
}
