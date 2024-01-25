import 'package:flutter/material.dart';

import '../models/data.dart';
import '../services/controllers/controller.dart';
import '../utils/errors.dart';
import '../widgets/provider.dart';
import 'typedefs.dart';

extension DataContextHelper on BuildContext {
  T findController<T extends DataController>() {
    try {
      return DataControllers.of<T>(this);
    } catch (_) {
      throw const DataException();
    }
  }
}

extension DataHelper on Object? {
  bool get isEntity => this is Map<String, dynamic>;

  String? get entityId => isEntity ? Data.autoId(this) : null;

  int? get entityTimeMills => isEntity ? Data.autoTimeMills(this) : null;

  String get generateID => Data.generateID;

  int get generateTimeMills => Data.generateTimeMills;

  T? entityObject<T>(String key, OnValueBuilder<T> builder) {
    return isEntity ? Data.object(key, this, builder) : null;
  }

  List<T>? entityObjects<T>(String key, OnValueBuilder<T> builder) {
    return isEntity ? Data.objects(key, this, builder) : null;
  }

  T? entityType<T>(String key, OnValueBuilder<T> builder) {
    return isEntity ? Data.type(key, this, builder) : null;
  }

  T? entityValue<T>(String key) {
    return isEntity ? Data.value(key, this) : null;
  }

  List<T>? entityValues<T>(String key) {
    return isEntity ? Data.values(key, this) : null;
  }
}

extension DataMapHelper on Map<String, dynamic>? {
  Map<String, dynamic> attach(Map<String, dynamic> current) {
    final data = this ?? {};
    data.addAll(current);
    return data;
  }

  Map<String, dynamic> adjust(Map<String, dynamic> current) => attach(current);
}
