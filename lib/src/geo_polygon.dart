import 'h_error.dart';
import 'geo_point.dart';

class GeoPolygon {
  List _coordinates;
  Map<String, dynamic> geoJSON;

  GeoPolygon({List coordinates, List<GeoPoint> points}) {
    // 当有 coordinates 时（如果 coordinates 和 points 都传，则只会处理 coordinates）
    if (coordinates != null) {
      if (coordinates.length < 4) {
        throw HError(605);
      } else {
        _coordinates = coordinates;
        geoJSON = {
          'type': 'Polygon',
          'coordinates': [_coordinates]
        };
      }
    } else if (points != null) {
      // 如果有 points 时，但没有 coordinates
      if (points.length < 4) {
        throw HError(605);
      } else {
        _coordinates =
            points.map((point) => [point.longitude, point.latitude]).toList();

        geoJSON = {
          'type': 'Polygon',
          'coordinates': [_coordinates]
        };
      }
    } else {
      throw HError(605);
    }
  }
}
