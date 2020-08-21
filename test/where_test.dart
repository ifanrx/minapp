import 'package:flutter_test/flutter_test.dart';
import 'package:minapp/minapp.dart';
import 'package:faker/faker.dart';

void main() {
  List<num> randomNumbers;
  num randomNum1;
  num randomNum2;
  List<num> randomNumArray;
  String randomString;

  setUpAll(() {
    randomNumbers = genRandomNumbers(100, 3);
    randomNumArray = genRandomNumbers(200, 10);
    randomNum1 = randomNumbers[0];
    randomNum2 = randomNumbers[1];
    randomString = faker.lorem.word();
  });

  test('Compare', () {
    Where where = Where.compare('price', '<', randomNum1);

    expect(
      where.condition,
      equals({
        '\$and': [
          {
            'price': {'\$lt': randomNum1}
          }
        ]
      }),
    );
  });

  test('Contains', () {
    Where where = Where.contains('name', randomString);

    expect(
      where.condition,
      equals({
        '\$and': [
          {
            'name': {'\$contains': randomString}
          }
        ]
      }),
    );
  });
  test('Matches', () {
    Where where = Where.matches('name', new RegExp(r'^[a-zA-Z]+[0-9]*\\W?_$'));

    expect(
      where.condition,
      equals({
        '\$and': [
          {
            'name': {'\$regex': r'^[a-zA-Z]+[0-9]*\\W?_$'}
          }
        ]
      }),
    );
  });
  test('Matches', () {
    Where where =
        Where.matches('name', new RegExp(r'/^[a-zA-Z]+[0-9]*\\W?_$/gi'));

    expect(
      where.condition,
      equals({
        '\$and': [
          {
            'name': {'\$regex': r'^[a-zA-Z]+[0-9]*\\W?_$', '\$options': 'gi'}
          }
        ]
      }),
    );
  });

  test('In', () {
    Where where = Where.inList('price', randomNumArray);

    expect(
      where.condition,
      equals({
        '\$and': [
          {
            'price': {'\$in': randomNumArray}
          }
        ]
      }),
    );
  });

  test('Not in', () {
    Where where = Where.notInList('price', randomNumArray);

    expect(
      where.condition,
      equals({
        '\$and': [
          {
            'price': {'\$nin': randomNumArray}
          }
        ]
      }),
    );
  });
  test('arrayContains', () {
    Where where = Where.arrayContains('desc', randomNumArray);

    expect(
      where.condition,
      equals({
        '\$and': [
          {
            'desc': {'\$all': randomNumArray}
          }
        ]
      }),
    );
  });
  test('isNull', () {
    Where where = Where.isNull('price');

    expect(
      where.condition,
      equals({
        '\$and': [
          {
            'price': {'\$isnull': true}
          }
        ]
      }),
    );
  });
  test('isNull array', () {
    Where where = Where.isNull(['price', 'amount']);

    expect(
      where.condition,
      equals({
        '\$and': [
          {
            'price': {'\$isnull': true},
          },
          {
            'amount': {'\$isnull': true}
          }
        ]
      }),
    );
  });
  test('isNotNull', () {
    Where where = Where.isNotNull('price');

    expect(
      where.condition,
      equals({
        '\$and': [
          {
            'price': {'\$isnull': false},
          },
        ]
      }),
    );
  });

  test('isNotNull array', () {
    Where where = Where.isNotNull(['price', 'amount']);

    expect(
      where.condition,
      equals({
        '\$and': [
          {
            'price': {'\$isnull': false},
          },
          {
            'amount': {'\$isnull': false}
          }
        ]
      }),
    );
  });

  test('exists', () {
    Where where = Where.exists('price');

    expect(
      where.condition,
      equals({
        '\$and': [
          {
            'price': {'\$exists': true},
          },
        ]
      }),
    );
  });

  test('exists array', () {
    Where where = Where.exists(['price', 'amount']);

    expect(
      where.condition,
      equals({
        '\$and': [
          {
            'price': {'\$exists': true},
          },
          {
            'amount': {'\$exists': true}
          }
        ]
      }),
    );
  });

  test('not exists', () {
    Where where = Where.notExists('price');

    expect(
      where.condition,
      equals({
        '\$and': [
          {
            'price': {'\$exists': false},
          },
        ]
      }),
    );
  });

  test('not exists array', () {
    Where where = Where.notExists(['price', 'amount']);

    expect(
      where.condition,
      equals({
        '\$and': [
          {
            'price': {'\$exists': false},
          },
          {
            'amount': {'\$exists': false}
          }
        ]
      }),
    );
  });

  test('include', () {
    GeoPoint point = new GeoPoint(randomNum1, randomNum2);

    Where where = Where.include('geoField', point);

    expect(
      where.condition,
      equals(
        {
          '\$and': [
            {
              'geoField': {
                '\$intersects': {
                  'type': 'Point',
                  'coordinates': [randomNum1, randomNum2],
                }
              }
            }
          ]
        },
      ),
    );
  });

  test('within', () {
    List<List<num>> random2DArray = [];
    for (var i = 0; i < 5; i++) {
      random2DArray.add(genRandomNumbers(100, 2));
    }
    GeoPolygon polygon = new GeoPolygon(coordinates: random2DArray);
    Where where = Where.within('geoField', polygon);

    expect(
      where.condition,
      equals(
        {
          '\$and': [
            {
              'geoField': {
                '\$within': {
                  'type': 'Polygon',
                  'coordinates': [random2DArray],
                }
              }
            }
          ]
        },
      ),
    );
  });

  test('withinCircle', () {
    GeoPoint point = new GeoPoint(randomNum1, randomNum2);

    Where where = Where.withinCircle('geoField', point, randomNum1);

    expect(
      where.condition,
      equals(
        {
          '\$and': [
            {
              'geoField': {
                '\$center': {
                  'radius': randomNum1,
                  'coordinates': [randomNum1, randomNum2],
                }
              }
            }
          ]
        },
      ),
    );
  });

  test('withinRegion', () {
    GeoPoint point = new GeoPoint(randomNum1, randomNum2);

    Where where = Where.withinRegion('geoField', point);

    expect(
      where.condition,
      equals(
        {
          '\$and': [
            {
              'geoField': {
                '\$nearsphere': {
                  'geometry': {
                    'type': 'Point',
                    'coordinates': [randomNum1, randomNum2]
                  },
                  'min_distance': 0
                }
              }
            }
          ]
        },
      ),
    );
  });

  test('static and', () {
    Where where1 = Where.contains('name', randomString);
    Where where2 = Where.isNull('price');
    Where andWhere = Where.and([where1, where2]);
    expect(
      andWhere.condition,
      equals({
        '\$and': [
          {
            '\$and': [
              {
                'name': {'\$contains': randomString}
              }
            ]
          },
          {
            '\$and': [
              {
                'price': {'\$isnull': true}
              }
            ]
          }
        ]
      }),
    );
  });

  test('static or', () {
    Where where1 = Where.contains('name', randomString);
    Where where2 = Where.isNull('price');
    Where orWhere = Where.or([where1, where2]);

    expect(
      orWhere.condition,
      equals({
        '\$or': [
          {
            '\$and': [
              {
                'name': {'\$contains': randomString}
              }
            ]
          },
          {
            '\$and': [
              {
                'price': {'\$isnull': true}
              }
            ]
          }
        ]
      }),
    );
  });

  test('static and && or', () {
    Where where1 = Where.contains('name', randomString);
    Where where2 = Where.isNull('price');

    Where orWhere = Where.or([where1, where2]);

    Where where3 = Where.isNotNull('name');
    Where andWhere = Where.and([orWhere, where3]);

    expect(andWhere.condition, {
      '\$and': [
        {
          '\$or': [
            {
              '\$and': [
                {
                  'name': {'\$contains': randomString}
                }
              ]
            },
            {
              '\$and': [
                {
                  'price': {'\$isnull': true}
                }
              ]
            }
          ]
        },
        {
          '\$and': [
            {
              'name': {'\$isnull': false}
            }
          ]
        }
      ]
    });
  });

  test('object - hasKey', () {
    Where where = Where.hasKey('objectField', 'key1');

    expect(
      where.condition,
      equals({
        '\$and': [
          {
            'objectField': {'\$has_key': 'key1'}
          }
        ]
      }),
    );
  });

  test('object - eq', () {
    Where where = Where.compare(
        'objectField', '=', {'a': randomNumArray, 'b': randomNum1});

    expect(
      where.condition,
      equals({
        '\$and': [
          {
            'objectField': {
              '\$eq': {'a': randomNumArray, 'b': randomNum1}
            }
          }
        ]
      }),
    );
  });

  test('object - isnull', () {
    Where where = Where.isNull('objectField');

    expect(
      where.condition,
      equals({
        '\$and': [
          {
            'objectField': {'\$isnull': true}
          }
        ]
      }),
    );
  });
}

List<num> genRandomNumbers(int max, int times) {
  return faker.randomGenerator.numbers(max, times);
}
