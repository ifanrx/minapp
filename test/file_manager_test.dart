import 'package:test/test.dart';

import 'package:minapp/minapp.dart';

void main() {
  test('delete file throw 605', () {
    String errorMsg = HError(605).message;

    expect(() => FileManager.delete(1), throwsA(predicate((e) => e is HError && e.message == errorMsg)));
    expect(() => FileManager.delete([1, 2, 3]), throwsA(predicate((e) => e is HError && e.message == errorMsg)));
    expect(() => FileManager.delete({'a', 'b'}), throwsA(predicate((e) => e is HError && e.message == errorMsg)));
    expect(() => FileManager.delete({'a': 1}), throwsA(predicate((e) => e is HError && e.message == errorMsg)));
    expect(() => FileManager.delete(true), throwsA(predicate((e) => e is HError && e.message == errorMsg)));
  });
}
