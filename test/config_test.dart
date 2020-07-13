import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minapp/minapp.dart' as BaaS;


void main() {
  SharedPreferences.setMockInitialValues({});

  test('初始化后才有配置信息', () {
    expect(BaaS.config, isNull);

    BaaS.init('123');

    expect(BaaS.config, isNotNull);
    expect(BaaS.config.clientID, equals('123'));
  });
}
