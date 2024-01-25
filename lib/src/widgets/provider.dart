import 'package:flutter/material.dart';

import '../services/controllers/controller.dart';
import '../utils/errors.dart';

class DataControllers extends InheritedWidget {
  final List<DataController> controllers;

  const DataControllers({
    super.key,
    required this.controllers,
    required Widget child,
  }) : super(child: child);

  static DataControllers _of(BuildContext context) {
    final x = context.dependOnInheritedWidgetOfExactType<DataControllers>();
    if (x != null) {
      return x;
    } else {
      throw const DataException();
    }
  }

  static T of<T extends DataController>(BuildContext context) {
    try {
      final x = _of(context).controllers.firstWhere((e) => e is T);
      if (x is T) {
        return x;
      } else {
        throw const DataException();
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  bool updateShouldNotify(covariant DataControllers oldWidget) {
    return controllers != oldWidget.controllers;
  }
}
