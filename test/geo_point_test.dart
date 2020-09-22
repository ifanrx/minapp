import 'package:flutter_test/flutter_test.dart';
import 'package:minapp/minapp.dart';
import 'package:faker/faker.dart';

void main() {
  List<num> randomNum = [];

  setUpAll(() {
    randomNum = genRandomNumbers(100, 2);
  });

  test('Get point coordinates', () {
    GeoPoint point = new GeoPoint(randomNum[0], randomNum[1]);
    Map<String, dynamic> geoJSON = point.geoJSON;
    expect(geoJSON['coordinates'][0], equals(randomNum[0]));
    expect(geoJSON['coordinates'][1], equals(randomNum[1]));
  });

  test('Get point info', () {
    GeoPoint point = new GeoPoint(randomNum[0], randomNum[1]);
    expect(
      point.geoJSON,
      equals({
        'type': 'Point',
        'coordinates': [randomNum[0], randomNum[1]]
      }),
    );
  });
}

List<num> genRandomNumbers(int max, int times) {
  return faker.randomGenerator.numbers(max, times);
}
