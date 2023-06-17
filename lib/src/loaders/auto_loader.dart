import 'dart:async';

import '../../core.dart';

typedef OnAutoLoaderRequest<T> = Future<T> Function();

class AutoLoader<T extends Entity> {
  final int interval;
  final OnAutoLoaderRequest<T> request;
  final _controller = StreamController<T>();
  Timer? _timer;
  T? _data;

  Stream<T> get stream => _controller.stream;

  AutoLoader(
    this.interval,
    this.request,
  ) {
    start();
  }

  void start() {
    if (!(_timer?.isActive ?? true)) {
      final duration = Duration(milliseconds: interval);
      _timer = Timer.periodic(duration, (_) async {
        final current = await request();
        if (current.source != _data?.source) {
          _controller.add(current);
        }
      });
    }
  }

  void stop() => _timer?.cancel();

  void dispose() {
    _controller.close();
    stop();
  }
}
