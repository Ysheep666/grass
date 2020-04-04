import 'dart:math';

import 'package:mobx/mobx.dart';

class ListDiff<T> {
  final List<T> a;
  final List<T> b;
  ListDiff(this.a, this.b);

  /// get diff ot
  List<ChangeNotification<T>> getOt() {
    List<List<int>> matrix = List(a.length + 1);
    for (var i = 0; i < a.length + 1; i++) {
      matrix[i] =  List(b.length + 1);
      for (var j = 0; j < b.length + 1; j++) {
        if (i == 0) {
          matrix[i][j] = j;
        } else if (j == 0) {
          matrix[i][j] = i;
        } else {
          final cost = a[i - 1] == b[j - 1] ? 0 : 1;
          final p = min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1);
          matrix[i][j] = min(p, matrix[i - 1][j - 1] + cost);
        }
      }
    }

    int y = a.length;
    int x = b.length;
    List<ChangeNotification<T>> items = [];
    while (x != 0 || y != 0) {
      if (x == 0) {
        y -= 1;
        items.add(ChangeNotification(type: OperationType.remove));
      } else if (y == 0) {
        x -= 1;
        items.add(ChangeNotification(type: OperationType.add, newValue: b[x]));
      } else {
        final leftTopCost = matrix[y - 1][x - 1];
        final leftCost = matrix[y][x - 1];
        final topCost = matrix[y - 1][x];
        int type = 1; // 1 left top, 2 left, 3 right
        if (leftTopCost > leftCost) {
          type = 2;
        }
        if ((type == 1 ? leftTopCost : leftCost) > topCost) {
          type = 3;
        }
        
        if (type == 1) {
          y -= 1;
          x -= 1;
          items.add(ChangeNotification(type: OperationType.update, oldValue: a[y], newValue: b[x]));
        } else if (type == 2) {
          x -= 1;
          items.add(ChangeNotification(type: OperationType.add, newValue: b[x]));
        } else {
          y -= 1;
          items.add(ChangeNotification(type: OperationType.remove));
        }
      }
    }
    return items.reversed.toList();
  }
}
