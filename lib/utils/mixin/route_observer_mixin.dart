import 'package:flutter/widgets.dart';
import 'package:grass/stores/base_store.dart';
import 'package:provider/provider.dart';

mixin RouteObserverMixin<T extends StatefulWidget> on State<T>, RouteAware {
  RouteObserver<ModalRoute> _routeObserver;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_routeObserver != null) {
      return;
    }
    final store = Provider.of<BaseStore>(context, listen: false);
    _routeObserver = store.routeObserver..subscribe(
      this,
      ModalRoute.of(context),
    );
  }

  @override
  void dispose() {
    _routeObserver.unsubscribe(this);
    super.dispose();
  }
}
