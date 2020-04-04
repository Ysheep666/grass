
import 'package:flutter_test/flutter_test.dart';
import 'package:grass/utils/diff.dart';
import 'package:mobx/mobx.dart';

List<String> _merge(List<String> a, List<ChangeNotification<String>> ots) {
  List<String> b = List.from(a);
  int index = 0;
  for (var i = 0; i < ots.length; i++) {
    final ot = ots[i];
    if (ot.type == OperationType.add) {
      b.insert(i, ot.newValue);
    } else if (ot.type == OperationType.remove) {
      b.removeAt(i + index);
      index -= 1;
    } else {
      b[i + index] = ot.newValue;
    }
  }
  return b;
}

void main() {
  test('List Diff 1', () {
    var diff = ListDiff<String>(''.split(''), 'abc123'.split(''));
    var ots = diff.getOt();
    expect(_merge(''.split(''), ots).join(''), 'abc123');
  });

 test('List Diff 2', () {
    var diff = ListDiff<String>('abc123'.split(''), ''.split(''));
    var ots = diff.getOt();
    expect(_merge('abc123'.split(''), ots).join(''), '');
  });

 test('List Diff 3', () {
    var diff = ListDiff<String>('abc123'.split(''), '123abc'.split(''));
    var ots = diff.getOt();
    expect(_merge('abc123'.split(''), ots).join(''), '123abc');
  });

 test('List Diff 4', () {
    var diff = ListDiff<String>('abc123'.split(''), 'efg123'.split(''));
    var ots = diff.getOt();
    expect(_merge('abc123'.split(''), ots).join(''), 'efg123');
  });
}
