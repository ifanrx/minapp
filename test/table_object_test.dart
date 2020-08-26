import 'package:flutter_test/flutter_test.dart';
import 'package:minapp/minapp.dart';
import 'package:faker/faker.dart';
import 'package:minapp/src/request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login_info.dart' as loginInfo;

void main() {
  SharedPreferences.setMockInitialValues({});

  TableObject product;
  List<num> randomNumArray;
  String tableName = 'jiajun_test';
  String recordId = '5f3631bb6526327bfa037ae8';

  setUpAll(() async {
    init('a4d2d62965ddb57fa4d6');

    await Auth.login(
      email: loginInfo.email,
      password: loginInfo.password,
    );

    randomNumArray = genRandomNumbers(100, 3);
  });

  setUp(() {
    product = new TableObject(tableName);
  });

  test('createMany', () async {
    List<Map<String, dynamic>> data = [
      {'num': 123}
    ];

    await product.createMany(data);
    expect(
      requestConfig['params'],
      equals(
        {'tableID': tableName, 'enable_trigger': 1},
      ),
    );

    expect(requestConfig['data'], equals(data));
  });

  test('delete one', () async {
    TableRecord record = product.create();
    record.set('num', 999);
    TableRecord itemAdded = await record.save();
    String recordId = itemAdded.recordInfo['id'];
    await product.delete(recordId: recordId);
    expect(requestConfig['params'], {
      'tableID': tableName,
      'recordID': recordId,
    });
  });

  test('delete multiple without enable_trigger', () async {
    Query query = new Query();
    Where where = Where.inList('price', randomNumArray);
    query
      ..where(where)
      ..offset(0);

    await product.delete(query: query);
    expect(
      requestConfig['params'],
      equals({
        'tableID': tableName,
        'where': '{"\$and":[{"price":{"\$in":[${randomNumArray.join(',')}]}}]}',
        'offset': 0,
        'limit': 20,
        'enable_trigger': 1,
        'return_total_count': 0,
      }),
    );
  });

  test('delete more with enable_trigger=false', () async {
    Query query = new Query();
    Where where = Where.inList('price', randomNumArray);
    query
      ..where(where)
      ..offset(0);

    await product.delete(query: query, enableTrigger: false);
    expect(
      requestConfig['params'],
      equals({
        'tableID': tableName,
        'where': '{"\$and":[{"price":{"\$in":[${randomNumArray.join(',')}]}}]}',
        'offset': 0,
        'limit': null,
        'enable_trigger': 0,
        'return_total_count': 0,
      }),
    );
  });

  test('delete more with enable_trigger=false', () async {
    Query query = new Query();
    Where where = Where.inList('price', randomNumArray);
    query
      ..where(where)
      ..offset(0);

    await product.delete(query: query, enableTrigger: true);
    expect(
      requestConfig['params'],
      equals({
        'tableID': tableName,
        'where': '{"\$and":[{"price":{"\$in":[${randomNumArray.join(',')}]}}]}',
        'offset': 0,
        'limit': 20,
        'enable_trigger': 1,
        'return_total_count': 0,
      }),
    );
  });

  test('delete more with withCount=true', () async {
    Query query = new Query();
    Where where = Where.inList('price', randomNumArray);
    query
      ..where(where)
      ..offset(0);

    await product.delete(query: query, withCount: true);
    expect(
      requestConfig['params'],
      equals({
        'tableID': tableName,
        'where': '{"\$and":[{"price":{"\$in":[${randomNumArray.join(',')}]}}]}',
        'offset': 0,
        'limit': 20,
        'enable_trigger': 1,
        'return_total_count': 1,
      }),
    );
  });

  test('delete more with withCount=false', () async {
    Query query = new Query();
    Where where = Where.inList('price', randomNumArray);
    query
      ..where(where)
      ..offset(0);

    await product.delete(query: query, withCount: false);
    expect(
      requestConfig['params'],
      equals({
        'tableID': tableName,
        'where': '{"\$and":[{"price":{"\$in":[${randomNumArray.join(',')}]}}]}',
        'offset': 0,
        'limit': 20,
        'enable_trigger': 1,
        'return_total_count': 0,
      }),
    );
  });

  test('delete more without withCount', () async {
    Query query = new Query();
    Where where = Where.inList('price', randomNumArray);
    query
      ..where(where)
      ..offset(0);

    await product.delete(query: query);
    expect(
      requestConfig['params'],
      equals({
        'tableID': tableName,
        'where': '{"\$and":[{"price":{"\$in":[${randomNumArray.join(',')}]}}]}',
        'offset': 0,
        'limit': 20,
        'enable_trigger': 1,
        'return_total_count': 0,
      }),
    );
  });

  test('get', () async {
    await product.get(recordId);
    expect(
      requestConfig['params'],
      equals({
        'tableID': tableName,
        'recordID': recordId,
      }),
    );
  });

  test('get expand created_by', () async {
    await product.get(recordId, expand: 'created_by');
    expect(
      requestConfig['data'],
      equals({'expand': 'created_by'}),
    );
  });

  test('get select keys', () async {
    await product.get(recordId, select: 'created_by');
    expect(
      requestConfig['data'],
      equals({'keys': 'created_by'}),
    );
  });

  test('get select more keys', () async {
    await product.get(recordId, select: ['-created_by', '-created_at']);
    expect(
      requestConfig['data'],
      equals({'keys': '-created_by,-created_at'}),
    );
  });

  test('findwithout withCount', () async {
    Query query = new Query();
    Where where = Where.inList('price', randomNumArray);
    query
      ..where(where)
      ..offset(0);

    await product.find(query);
    expect(
      requestConfig['data'],
      equals({
        'where': '{"\$and":[{"price":{"\$in":[${randomNumArray.join(',')}]}}]}',
        'offset': 0,
        'return_total_count': 0,
      }),
    );
  });

  test('findwithout with withCount=true', () async {
    Query query = new Query();
    Where where = Where.inList('price', randomNumArray);
    query
      ..where(where)
      ..offset(0);

    await product.find(query, withCount: true);
    expect(
      requestConfig['data'],
      equals({
        'where': '{"\$and":[{"price":{"\$in":[${randomNumArray.join(',')}]}}]}',
        'offset': 0,
        'return_total_count': 1,
      }),
    );
  });

  test('findwithout with withCount=false', () async {
    Query query = new Query();
    Where where = Where.inList('price', randomNumArray);
    query
      ..where(where)
      ..offset(0);

    await product.find(query, withCount: false);
    expect(
      requestConfig['data'],
      equals({
        'where': '{"\$and":[{"price":{"\$in":[${randomNumArray.join(',')}]}}]}',
        'offset': 0,
        'return_total_count': 0,
      }),
    );
  });
}

List<num> genRandomNumbers(int max, int times) {
  return faker.randomGenerator.numbers(max, times);
}
