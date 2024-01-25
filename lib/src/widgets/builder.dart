import 'package:data_management/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

typedef OnDataControllerBuilder<T extends Entity> = Widget Function(
  BuildContext context,
  DataResponse<T> value,
);

class DataBuilder<T extends Entity> extends StatelessWidget {
  final OnDataControllerBuilder<T> builder;

  const DataBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return _Support<T>(
        controller: DataController.of(context),
        builder: builder,
      );
    } catch (_) {
      rethrow;
    }
  }
}

class _Support<T extends Entity> extends StatefulWidget {
  final DataController<T> controller;
  final OnDataControllerBuilder<T> builder;

  const _Support({
    super.key,
    required this.controller,
    required this.builder,
  });

  @override
  State<_Support<T>> createState() => _SupportState<T>();
}

class _SupportState<T extends Entity> extends State<_Support<T>> {
  DataResponse<T>? _data;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_change);
  }

  @override
  void didUpdateWidget(_Support<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_change);
      widget.controller.addListener(_change);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_change);
    super.dispose();
  }

  void _change() => setState(() => _data = widget.controller.value);

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _data ?? DataResponse<T>());
  }
}
