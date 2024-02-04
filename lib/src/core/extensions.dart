import 'package:flutter/material.dart';

import '../services/controllers/controller.dart';
import '../utils/errors.dart';
import '../widgets/provider.dart';

extension DataContextHelper on BuildContext {
  T findDataController<T extends DataController>() {
    try {
      return DataControllers.of<T>(this);
    } catch (_) {
      throw const DataException();
    }
  }
}
