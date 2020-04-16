// mitt flutter 版

typedef EventHandler = void Function(dynamic event);
typedef WildCardEventHandler = void Function(String type, dynamic event);

class Mitt {
  Map<String, List> _all;

  Mitt([Map<String, List> all]) {
    _all = all ?? {};
  }


  /// 订阅
  void on(String type, EventHandler handler) {
    (_all[type] ??= []).add(handler);
  }

  /// 取消订阅
  void off(String type, EventHandler handler) {
    if (_all.containsKey(type)) {
      _all[type].remove(handler);
    }
  }

  /// 发布
  void emit(String type, [dynamic evt]) {
    (_all[type] ?? []).forEach((handler) { handler(evt); });
    (_all['*'] ?? []).forEach((handler) { handler(type, evt); });
  }
}