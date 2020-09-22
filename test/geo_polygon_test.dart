import 'package:flutter_test/flutter_test.dart';
import 'package:minapp/minapp.dart';

void main() {
  test('Init with a 2D array', () {
    List<List<num>> coordinates = [
      [1, 1],
      [1, 1],
      [1, 1],
      [1, 1]
    ];

    GeoPolygon polygon = new GeoPolygon(coordinates: coordinates);
    expect(
      polygon.geoJSON,
      equals({
        'type': 'Polygon',
        'coordinates': [coordinates]
      }),
    );
  });

  test('Init with geo points', () {
    GeoPoint point1 = new GeoPoint(1, 1);
    GeoPoint point2 = new GeoPoint(1, 1);
    GeoPoint point3 = new GeoPoint(1, 1);
    GeoPoint point4 = new GeoPoint(1, 1);

    GeoPolygon polygon =
        new GeoPolygon(points: [point1, point2, point3, point4]);

    expect(
      polygon.geoJSON,
      equals({
        'type': 'Polygon',
        'coordinates': [
          [
            [1, 1],
            [1, 1],
            [1, 1],
            [1, 1]
          ]
        ]
      }),
    );
  });

  test('Falsy arguments', () {
    try {
      new GeoPolygon();
    } catch (e) {
      expect(e, isInstanceOf<HError>());
    }

    try {
      GeoPoint point1 = new GeoPoint(1, 1);
      GeoPoint point2 = new GeoPoint(1, 1);
      new GeoPolygon(points: [point1, point2]);
    } catch (e) {
      expect(e, isInstanceOf<HError>());
    }
  });

  test('Multiple set', () {
    TableObject tableObject = new TableObject('test');
    TableRecord record = tableObject.create();
    GeoPolygon polygon = new GeoPolygon(coordinates: [
      [10, 10],
      [20, 10],
      [30, 20],
      [10, 10]
    ]);

    record.set('geo', polygon);
    record.set('geo', polygon);

    expect(
        polygon.geoJSON['coordinates'],
        equals([
          [
            [10, 10],
            [20, 10],
            [30, 20],
            [10, 10]
          ]
        ]));
  });
}
