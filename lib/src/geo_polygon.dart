import 'h_error.dart';
import 'geo_point.dart';

class GeoPolygon {
  List coordinates;
  List<GeoPoint> points;
  Map<String, dynamic> geoJSON;

  GeoPolygon({this.coordinates, this.points}) {
    // 当有 coordinates 时（如果 coordinates 和 points 都传，则只会处理 coordinates）
    if (coordinates != null) {
      if (coordinates.length < 4) {
        print('coordinates less than 4');
        throw HError(605);
      } else {
        geoJSON = {'type': 'Polygon', 'coordinates': coordinates};
      }
    } else if (points != null) {
      // 如果有 points 时，但没有 coordinates
      if (points.length < 4) {
        print('points less than 4');
        throw HError(605);
      } else {
        coordinates =
            points.map((point) => [point.longitude, point.latitude]).toList();

        geoJSON = {
          'type': 'Polygon',
          'coordinates': [coordinates]
        };
        print(geoJSON);
      }
    } else {
      throw HError(605);
    }
  }
}
