import 'package:mobx/mobx.dart';

part 'habit_detail_store.g.dart';

class HabitDetailStore = _HabitDetailStore with _$HabitDetailStore;

/// habit 详细数据，主要用于 habit_detail 页面
abstract class _HabitDetailStore with Store {
  @observable
  bool isLoaded = false;
}
