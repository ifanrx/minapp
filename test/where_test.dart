import 'package:flutter_test/flutter_test.dart';
import 'package:minapp/minapp.dart';
import 'package:faker/faker.dart';

void main() {
  List<num> randomNumbers;
  num randomNum1;
  num randomNum2;
  List<num> randomNumArray;
  String randomString;
  BaseRecord product;

  setUpAll(() {
    randomNumbers = genRandomNumbers(100, 3);
    randomNumArray = genRandomNumbers(200, 10);
    randomNum1 = randomNumbers[0];
    randomNum2 = randomNumbers[1];
    randomString = faker.lorem.word();
  });

  setUp(() {
    Map<String, dynamic> recordInfo = {'id': randomNum1.toString()};
    product = new BaseRecord.withInfo(recordInfo);
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
}

List<num> genRandomNumbers(int max, int times) {
  return faker.randomGenerator.numbers(max, times);
}
