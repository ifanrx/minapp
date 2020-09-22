import 'package:flutter_test/flutter_test.dart';
import 'package:minapp/minapp.dart';
import 'package:faker/faker.dart';
import 'request.dart';

void main() {
  TableObject product;
  List<num> randomNumArray;
  String tableName = 'jiajun_test';
  String recordId = '5f3631bb6526327bfa037ae8';

  setUpAll(() async {
    init('a4d2d62965ddb57fa4d6', request: testRequest);

    randomNumArray = genRandomNumbers(100, 3);
  });

  setUp(() {
    product = new TableObject(tableName);
  });

  test('save', () async {
    TableRecord record = product.create();
    record.set('num', 123123);
    await record.save();
    expect(
      record.record,
      equals({
        '\$set': {},
        '\$unset': {},
      }),
    );
  });

  test('update one', () async {
    TableRecord record = product.getWithoutData(recordId: recordId);
    record.set('num', 12312344444);
    await record.update();
    expect(
      record.record,
      equals({
        '\$set': {},
        '\$unset': {},
      }),
    );
  });

  test('update more without enableTrigger', () async {
    Query query = new Query();
    Where where = Where.inList('price', randomNumArray);
    query.where(where);
    TableRecord record = product.getWithoutData(query: query);
    record.set('num', 123);
    await record.update();
    expect(
      requestConfig['params'],
      equals({
        'tableID': 'jiajun_test',
        'where': '{"\$and":[{"price":{"\$in":[${randomNumArray.join(',')}]}}]}',
        'offset': 0,
        'limit': 20,
        'enable_trigger': 1,
        'return_total_count': 0,
      }),
    );

    expect(
      requestConfig['data'],
      equals(
        {
          '\$set': {'num': 123},
          '\$unset': {}
        },
      ),
    );
  });

  test('update more without enableTrigger=false', () async {
    Query query = new Query();
    Where where = Where.inList('price', randomNumArray);
    query.where(where);
    TableRecord record = product.getWithoutData(query: query);
    record.set('num', 123);
    await record.update(enableTrigger: false);
    expect(
      requestConfig['params'],
      equals({
        'tableID': 'jiajun_test',
        'where': '{"\$and":[{"price":{"\$in":[${randomNumArray.join(',')}]}}]}',
        'offset': 0,
        'limit': null,
        'enable_trigger': 0,
        'return_total_count': 0,
      }),
    );

    expect(
      requestConfig['data'],
      equals(
        {
          '\$set': {'num': 123},
          '\$unset': {}
        },
      ),
    );
  });

  test('update more without enableTrigger=true', () async {
    Query query = new Query();
    Where where = Where.inList('price', randomNumArray);
    query.where(where);
    TableRecord record = product.getWithoutData(query: query);
    record.set('num', 123);
    await record.update(enableTrigger: true);
    expect(
      requestConfig['params'],
      equals({
        'tableID': 'jiajun_test',
        'where': '{"\$and":[{"price":{"\$in":[${randomNumArray.join(',')}]}}]}',
        'offset': 0,
        'limit': 20,
        'enable_trigger': 1,
        'return_total_count': 0,
      }),
    );

    expect(
      requestConfig['data'],
      equals(
        {
          '\$set': {'num': 123},
          '\$unset': {}
        },
      ),
    );
  });

  test('update more without withCount', () async {
    Query query = new Query();
    Where where = Where.inList('price', randomNumArray);
    query.where(where);
    TableRecord record = product.getWithoutData(query: query);
    record.set('num', 123);
    await record.update();
    expect(
      requestConfig['params'],
      equals({
        'tableID': 'jiajun_test',
        'where': '{"\$and":[{"price":{"\$in":[${randomNumArray.join(',')}]}}]}',
        'offset': 0,
        'limit': 20,
        'enable_trigger': 1,
        'return_total_count': 0,
      }),
    );

    expect(
      requestConfig['data'],
      equals(
        {
          '\$set': {'num': 123},
          '\$unset': {}
        },
      ),
    );
  });

  test('update more with withCount=true', () async {
    Query query = new Query();
    Where where = Where.inList('price', randomNumArray);
    query.where(where);
    TableRecord record = product.getWithoutData(query: query);
    record.set('num', 123);
    await record.update(withCount: true);
    expect(
      requestConfig['params'],
      equals({
        'tableID': 'jiajun_test',
        'where': '{"\$and":[{"price":{"\$in":[${randomNumArray.join(',')}]}}]}',
        'offset': 0,
        'limit': 20,
        'enable_trigger': 1,
        'return_total_count': 1,
      }),
    );

    expect(
      requestConfig['data'],
      equals(
        {
          '\$set': {'num': 123},
          '\$unset': {}
        },
      ),
    );
  });

  test('update more with withCount=false', () async {
    Query query = new Query();
    Where where = Where.inList('price', randomNumArray);
    query.where(where);
    TableRecord record = product.getWithoutData(query: query);
    record.set('num', 123);
    await record.update(withCount: false);
    expect(
      requestConfig['params'],
      equals({
        'tableID': 'jiajun_test',
        'where': '{"\$and":[{"price":{"\$in":[${randomNumArray.join(',')}]}}]}',
        'offset': 0,
        'limit': 20,
        'enable_trigger': 1,
        'return_total_count': 0,
      }),
    );

    expect(
      requestConfig['data'],
      equals(
        {
          '\$set': {'num': 123},
          '\$unset': {}
        },
      ),
    );
  });
}

List<num> genRandomNumbers(int max, int times) {
  return faker.randomGenerator.numbers(max, times);
}
