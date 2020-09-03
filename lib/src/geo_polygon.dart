import 'h_error.dart';
import 'geo_point.dart';

class GeoPolygon {
  List _coordinates;
  List<GeoPoint> _points;
  Map<String, dynamic> _geoJSON;

  Map<String, dynamic> get geoJSON => _geoJSON;

  GeoPolygon({List coordinates, List<GeoPoint> points}) {
    _coordinates = coordinates;
    _points = points;
    // 当有 coordinates 时（如果 coordinates 和 points 都传，则只会处理 coordinates）
    if (_coordinates != null) {
      if (_coordinates.length < 4) {
        throw HError(605);
      } else {
        _geoJSON = {
          'type': 'Polygon',
          'coordinates': [_coordinates]
        };
      }
    } else if (_points != null) {
      // 如果只有 points 时
      if (_points.length < 4) {
        throw HError(605);
      } else {
        _coordinates =
            _points.map((point) => [point.longitude, point.latitude]).toList();

        _geoJSON = {
          'type': 'Polygon',
          'coordinates': [_coordinates]
        };
      }
    } else {
      throw HError(605);
    }
  }
}
