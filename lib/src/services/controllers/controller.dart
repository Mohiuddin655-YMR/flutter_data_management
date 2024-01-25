import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

import '../../core/typedefs.dart';
import '../../data/handlers/local_data_handler.dart';
import '../../data/handlers/remote_data_handler.dart';
import '../../utils/errors.dart';
import '../../utils/response.dart';
import '../../widgets/provider.dart';
import '../handlers/local_data_handler.dart';
import '../handlers/remote_data_handler.dart';
import '../repositories/local_data_repository.dart';
import '../repositories/remote_data_repository.dart';
import '../sources/local_data_source.dart';
import '../sources/remote_data_source.dart';

part '../../../src/data/controllers/local_data_controller.dart';
part '../../../src/data/controllers/remote_data_controller.dart';

abstract class DataController<T extends Entity>
    extends ValueNotifier<DataResponse<T>> {
  DataController._() : super(DataResponse<T>());

  factory DataController.of(BuildContext context) {
    return DataControllers.of<DataController<T>>(context);
  }

  factory DataController.fromLocalHandler({
    required LocalDataHandler<T> handler,
  }) {
    return DataController._local(handler: handler);
  }

  factory DataController.fromLocalRepository({
    required LocalDataRepository<T> repository,
  }) {
    return DataController._local(repository: repository);
  }

  factory DataController.fromLocalSource({
    required LocalDataSource<T> source,
  }) {
    return DataController._local(source: source);
  }

  factory DataController.fromRemoteHandler({
    required RemoteDataHandler<T> handler,
  }) {
    return DataController._remote(handler: handler);
  }

  factory DataController.fromRemoteRepository({
    required RemoteDataRepository<T> repository,
  }) {
    return DataController._remote(repository: repository);
  }

  factory DataController.fromRemoteSource({
    required RemoteDataSource<T> source,
    ConnectivityProvider? connectivity,
    LocalDataSource<T>? backup,
    bool isCacheMode = false,
  }) {
    return DataController._remote(
      source: source,
      backup: backup,
      connectivity: connectivity,
      isCacheMode: isCacheMode,
    );
  }

  factory DataController._local({
    LocalDataHandler<T>? handler,
    LocalDataRepository<T>? repository,
    LocalDataSource<T>? source,
  }) {
    if (handler != null) {
      return LocalDataController(handler);
    } else if (repository != null) {
      return LocalDataController(
        LocalDataHandlerImpl<T>(repository: repository),
      );
    } else if (source != null) {
      return LocalDataController(
        LocalDataHandlerImpl<T>.fromSource(source),
      );
    } else {
      throw const DataException("Data controller not initialized!");
    }
  }

  factory DataController._remote({
    RemoteDataHandler<T>? handler,
    RemoteDataRepository<T>? repository,
    RemoteDataSource<T>? source,
    LocalDataSource<T>? backup,
    ConnectivityProvider? connectivity,
    bool isCacheMode = false,
  }) {
    if (handler != null) {
      return RemoteDataController(handler);
    } else if (repository != null) {
      return RemoteDataController(
        RemoteDataHandlerImpl<T>(repository: repository),
      );
    } else if (source != null) {
      return RemoteDataController(RemoteDataHandlerImpl<T>.fromSource(
        source: source,
        backup: backup,
        connectivity: connectivity,
        isCacheMode: isCacheMode,
      ));
    } else {
      throw const DataException("Data controller not initialized!");
    }
  }

  // Use for check current data
  void isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  });

  // Use for create single data
  void create<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
  });

  // Use for create multiple data
  void creates<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? source,
  });

  // Use for update single data
  void update<R>({
    required String id,
    required Map<String, dynamic> data,
    OnDataSourceBuilder<R>? source,
  });

  void delete<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  });

  void clear<R>({
    OnDataSourceBuilder<R>? source,
  });

  void get<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  });

  void gets<R>({
    OnDataSourceBuilder<R>? source,
  });

  void getUpdates<R>({
    OnDataSourceBuilder<R>? source,
  });

  Stream<Response<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  });

  Stream<Response<T>> lives<R>({
    OnDataSourceBuilder<R>? source,
  });

  void notify(
    DataResponse<T> value, [
    bool forceNotify = false,
  ]) {
    this.value = value;
    if (forceNotify) notifyListeners();
  }

  void _change<R>(Future<DataResponse<T>> Function() callback) async {
    notify(value.copy(loading: true, status: Status.loading));
    try {
      var result = await callback();
      notify(value.from(result));
    } catch (_) {
      notify(value.copy(exception: _.toString(), status: Status.failure));
    }
  }
}
