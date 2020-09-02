import 'package:flutter_test/flutter_test.dart';
import 'package:minapp/minapp.dart';
import 'package:faker/faker.dart';

void main() {
  List<num> randomNumbers;
  num randomNum1;
  num randomNum2;
  List<num> randomNumArray;
  BaseRecord product;

  setUpAll(() {
    randomNumbers = genRandomNumbers(100, 3);
    randomNumArray = genRandomNumbers(200, 10);
    randomNum1 = randomNumbers[0];
    randomNum2 = randomNumbers[1];
  });

  setUp(() {
    Map<String, dynamic> recordInfo = {'id': randomNum1.toString()};
    product = new BaseRecord.withInfo(recordInfo);
  });

  test('Validate record id', () {
    expect(product.id, equals(randomNum1.toString()));
  });

  test('Init record value', () {
    product.set('price', randomNum1);
    product.set('amount', randomNum2);
    product.set('obj1', {'a': randomNum1, 'b': randomNumArray});
    product.recordValueInit();
    expect(
      product.record,
      equals({
        '\$set': new Map<String, dynamic>(),
        '\$unset': new Map<String, dynamic>(),
      }),
    );
  });

  test('Set keys and values', () {
    product.set('price', randomNum1);
    product.set('amount', randomNum2);
    product.set('obj1', {'a': randomNum1, 'b': randomNumArray});
    expect(
      product.record,
      equals({
        '\$set': {
          'price': randomNum1,
          "amount": randomNum2,
          'obj1': {'a': randomNum1, 'b': randomNumArray},
        },
        '\$unset': new Map<String, dynamic>(),
      }),
    );
  });

  test('Set objects', () {
    product.set('price', {"price": randomNum1});
    product.set('amount', {'amount': randomNum2});
    product.set('obj1', {'a': randomNum1, 'b': randomNumArray});
    expect(
      product.record,
      equals({
        '\$set': {
          'price': {'price': randomNum1},
          "amount": {'amount': randomNum2},
          'obj1': {'a': randomNum1, 'b': randomNumArray},
        },
        '\$unset': new Map<String, dynamic>(),
      }),
    );
  });

  test('Set geo point', () {
    GeoPoint point = new GeoPoint(randomNum1, randomNum2);
    product.set({'point': point});

    expect(
      product.record,
      equals({
        '\$set': {
          "point": {
            'type': 'Point',
            'coordinates': [randomNum1, randomNum2]
          }
        },
        '\$unset': new Map<String, dynamic>(),
      }),
    );
  });

  test('Set geo polygon', () {
    List<List<num>> random2DArray = [];
    for (var i = 0; i < 5; i++) {
      random2DArray.add(genRandomNumbers(100, 2));
    }

    GeoPolygon polygon = new GeoPolygon(coordinates: random2DArray);

    product.set('polygon', polygon);
    expect(
      product.record,
      equals({
        '\$set': {
          "polygon": {
            'type': 'Polygon',
            'coordinates': [random2DArray]
          }
        },
        '\$unset': new Map<String, dynamic>(),
      }),
    );
  });

  /// [TODO] 抛错写法有误，待研究
  test('set illegal', () {
    try {
      product.set('');
    } catch (e) {
      expect(e, isInstanceOf<HError>());
    }

    try {
      product.set('string', 'test');
      product.unset('string');
    } catch (e) {
      expect(e, isInstanceOf<HError>());
    }

    try {
      product.unset('string');
      product.set('string', 'test');
    } catch (e) {
      expect(e, isInstanceOf<HError>());
    }

    try {
      product.unset({
        'string': '',
        'int': '',
      });
      product.set('string', 'test');
    } catch (e) {
      expect(e, isInstanceOf<HError>());
    }

    try {
      product.set({
        'string': 'test',
        'int': 10,
      });
      product.unset('string');
    } catch (e) {
      expect(e, isInstanceOf<HError>());
    }

    try {
      product.set({
        'string': 'test',
        'int': 10,
      });
      product.unset({'string': ''});
    } catch (e) {
      expect(e, isInstanceOf<HError>());
    }
  });

  test('Increment by', () {
    product.incrementBy('price', randomNum1);

    expect(
      product.record,
      equals({
        '\$set': {
          "price": {'\$incr_by': randomNum1}
        },
        '\$unset': new Map<String, dynamic>(),
      }),
    );
  });

  test('Append', () {
    product.append('arr', randomNum1);
    expect(
      product.record,
      equals({
        '\$set': {
          "arr": {
            '\$append': [randomNum1]
          }
        },
        '\$unset': new Map<String, dynamic>(),
      }),
    );

    product.append('arr', randomNumArray);
    expect(
      product.record,
      equals({
        '\$set': {
          "arr": {'\$append': randomNumArray}
        },
        '\$unset': new Map<String, dynamic>(),
      }),
    );
  });

  test('uAppend', () {
    product.uAppend('arr', randomNum1);
    expect(
      product.record,
      equals({
        '\$set': {
          "arr": {
            '\$append_unique': [randomNum1]
          }
        },
        '\$unset': new Map<String, dynamic>(),
      }),
    );

    product.uAppend('arr', randomNumArray);
    expect(
      product.record,
      equals({
        '\$set': {
          "arr": {'\$append_unique': randomNumArray}
        },
        '\$unset': new Map<String, dynamic>(),
      }),
    );
  });

  test('Remove', () {
    product.remove('arr', randomNum1);
    expect(
      product.record,
      equals({
        '\$set': {
          "arr": {
            '\$remove': [randomNum1]
          }
        },
        '\$unset': new Map<String, dynamic>(),
      }),
    );

    product.remove('arr', randomNumArray);
    expect(
      product.record,
      equals({
        '\$set': {
          "arr": {'\$remove': randomNumArray}
        },
        '\$unset': new Map<String, dynamic>(),
      }),
    );
  });

  test('PatchObject', () {
    product.patchObject('obj1', {'a': randomNumArray, 'b': randomNum1});
    expect(
      product.record,
      equals({
        '\$set': {
          "obj1": {
            '\$update': {'a': randomNumArray, 'b': randomNum1}
          }
        },
        '\$unset': new Map<String, dynamic>(),
      }),
    );
  });

  test('Unset', () {
    product.unset({
      'string': '',
      'obj': 'test',
    });
    product.unset('int');
    expect(
      product.record,
      equals({
        '\$set': {},
        '\$unset': {
          'int': '',
          'string': '',
          'obj': '',
        },
      }),
    );
  });

  test('Set and unset', () {
    product.set({
      'int': 10,
      'bool': true,
    });
    product.unset({
      'string': '',
      'obj': 'test',
    });

    expect(
      product.record,
      equals({
        '\$set': {
          'int': 10,
          'bool': true,
        },
        '\$unset': {
          'string': '',
          'obj': '',
        },
      }),
    );
  });
}

List<num> genRandomNumbers(int max, int times) {
  return faker.randomGenerator.numbers(max, times);
}
