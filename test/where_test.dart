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
    Where where = new Where();
    where.compare('price', '<', randomNum1);

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
    Where where = new Where();
    where.contains('name', randomString);

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
    Where where = new Where();

    where.matches('name', new RegExp(r'^[a-zA-Z]+[0-9]*\\W?_$'));

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
    Where where = new Where();
    where.matches('name', new RegExp(r'/^[a-zA-Z]+[0-9]*\\W?_$/gi'));

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
    Where where = new Where();
    where.inList('price', randomNumArray);

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
    Where where = new Where();
    where.notInList('price', randomNumArray);

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
    Where where = new Where();
    where.arrayContains('desc', randomNumArray);

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
    Where where = new Where();
    where.isNull('price');

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
    Where where = new Where();
    where.isNull(['price', 'amount']);

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
    Where where = new Where();
    where.isNotNull('price');

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
    Where where = new Where();
    where.isNotNull(['price', 'amount']);

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
    Where where = new Where();
    where.exists('price');

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
    Where where = new Where();
    where.exists(['price', 'amount']);

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
    Where where = new Where();
    where.notExists('price');

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
    Where where = new Where();
    where.notExists(['price', 'amount']);

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
    Where where = new Where();
    GeoPoint point = new GeoPoint(randomNum1, randomNum2);

    where.include('geoField', point);

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
    Where where = new Where();
    List<List<num>> random2DArray = [];
    for (var i = 0; i < 5; i++) {
      random2DArray.add(genRandomNumbers(100, 2));
    }
    GeoPolygon polygon = new GeoPolygon(coordinates: random2DArray);
    where.within('geoField', polygon);

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
    Where where = new Where();
    GeoPoint point = new GeoPoint(randomNum1, randomNum2);

    where.withinCircle('geoField', point, randomNum1);

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
    Where where = new Where();
    GeoPoint point = new GeoPoint(randomNum1, randomNum2);

    where.withinRegion('geoField', point);

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
    Where where1 = new Where();
    Where where2 = new Where();
    where1.contains('name', randomString);
    where2.isNull('price');
    Where andWhere = new Where();
    andWhere.and([where1, where2]);
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
    Where where1 = new Where();
    Where where2 = new Where();
    where1.contains('name', randomString);
    where2.isNull('price');
    Where orWhere = new Where();
    orWhere.or([where1, where2]);
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
    Where where1 = new Where();
    Where where2 = new Where();
    where1.contains('name', randomString);
    where2.isNull('price');

    Where orWhere = new Where();
    orWhere.or([where1, where2]);

    Where andWhere = new Where();
    Where where3 = new Where();
    where3.isNotNull('name');
    andWhere.and([orWhere, where3]);

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
    Where where = new Where();
    where.hasKey('objectField', 'key1');

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
    Where where = new Where();
    where.compare('objectField', '=', {'a': randomNumArray, 'b': randomNum1});

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
    Where where = new Where();
    where.isNull('objectField');

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
