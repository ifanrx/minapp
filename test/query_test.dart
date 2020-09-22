import 'package:flutter_test/flutter_test.dart';
import 'package:minapp/minapp.dart';
import 'package:faker/faker.dart';

void main() {
  List<num> randomNumbers;
  num randomNum;
  Query query;

  setUpAll(() {
    randomNumbers = genRandomNumbers(100, 1);
    randomNum = randomNumbers[0];
  });

  setUp(() {
    query = new Query();
  });

  test('Limit', () {
    query.limit(randomNum);
    Map<String, dynamic> queryParams = query.get();
    expect(queryParams['limit'], equals(randomNum));
  });

  test('select one', () {
    query.select('-amount');
    Map<String, dynamic> queryParams = query.get();
    expect(queryParams['keys'], equals('-amount'));
  });

  test('select multiple', () {
    query.select(['-amount', '-price']);
    Map<String, dynamic> queryParams = query.get();
    expect(queryParams['keys'], equals('-amount,-price'));
  });

  test('orderBy one', () {
    query.orderBy('-amount');
    Map<String, dynamic> queryParams = query.get();
    expect(queryParams['order_by'], equals('-amount'));
  });

  test('orderBy multiple', () {
    query.orderBy(['amount', '-price']);
    Map<String, dynamic> queryParams = query.get();
    expect(queryParams['order_by'], equals('amount,-price'));
  });

  test('expand one', () {
    query.expand('created_by');
    Map<String, dynamic> queryParams = query.get();
    expect(queryParams['expand'], equals('created_by'));
  });

  test('expand array args', () {
    query.expand(['created_by', 'test']);
    Map<String, dynamic> queryParams = query.get();
    expect(queryParams['expand'], equals('created_by,test'));
  });
}

List<num> genRandomNumbers(int max, int times) {
  return faker.randomGenerator.numbers(max, times);
}
