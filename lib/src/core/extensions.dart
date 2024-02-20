import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils.dart';

import '../services/controllers/controller.dart';
import '../utils/errors.dart';
import '../widgets/provider.dart';
import 'configs.dart';

extension DataContextHelper on BuildContext {
  T findDataController<T extends DataController>() {
    try {
      return DataControllers.of<T>(this);
    } catch (_) {
      throw const DataException();
    }
  }
}

extension FieldParamsHelper on FieldParams? {
  String generate(String root) {
    final params = this;
    if (params is Params) {
      return PathReplacer.replace(root, params.values);
    } else if (params is IterableParams) {
      return PathReplacer.replaceByIterable(root, params.values);
    } else {
      return root;
    }
  }
}
