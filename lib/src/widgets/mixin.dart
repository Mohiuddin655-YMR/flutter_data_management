import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_entity/entity.dart';

import '../repositories/base.dart';
import '../repositories/local.dart';
import '../repositories/remote.dart';
import 'provider.dart';

mixin DataManagementMixin<T extends Entity, S extends StatefulWidget>
    on State<S> {
  String get repositoryId;

  DataRepository<T>? _instance;

  DataRepository<T> get repository {
    return _instance ??= DataManagementProvider.repositoryOf(
      context,
      repositoryId,
    );
  }

  StreamSubscription? _subscription;

  void _init() {
    _subscription?.cancel();
    _subscription = DataManagementProvider.of(context)
        .connectivityChanges
        .listen((connected) {
      if (!connected) return;
      final repo = repository;
      if (repo is RemoteDataRepository<T>) {
        repo.push();
      } else if (repo is LocalDataRepository<T>) {
        repo.pull();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
