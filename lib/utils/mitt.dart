// mitt flutter 版

typedef EventHandler = void Function(dynamic event);
typedef WildCardEventHandler = void Function(String type, dynamic event);

class Mitt {
  Map<String, List> _all;

  Mitt([Map<String, List> all]) {
    _all = all ?? {};
  }

  void on(String type, EventHandler handler) {
    (_all[type] ??= []).add(handler);
  }

  void off(String type, EventHandler handler) {
    if (_all.containsKey(type)) {
      _all[type].remove(handler);
    }
  }

  void emit(String type, [dynamic evt]) {
    (_all[type] ?? []).forEach((handler) { handler(evt); });
    (_all['*'] ?? []).forEach((handler) { handler(type, evt); });
  }
}