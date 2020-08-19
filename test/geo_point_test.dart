import 'package:flutter_test/flutter_test.dart';
import 'package:minapp/minapp.dart';

void main() {
  test('Get point coordinates', () {
    GeoPoint point = new GeoPoint(10, 20);
    Map<String, dynamic> geoJSON = point.geoJSON;
    expect(geoJSON['coordinates'][0], equals(10));
    expect(geoJSON['coordinates'][1], equals(20));
  });

  test('Get point info', () {
    GeoPoint point = new GeoPoint(10, 20);
    expect(
      point.geoJSON,
      equals({
        'type': 'Point',
        'coordinates': [10, 20]
      }),
    );
  });
}
