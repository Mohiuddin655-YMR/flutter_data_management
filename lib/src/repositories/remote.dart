import 'dart:async';

import 'package:flutter_entity/entity.dart';

import '../core/configs.dart';
import '../models/checker.dart';
import '../models/updating_info.dart';
import '../sources/local.dart';
import '../sources/remote.dart';
import 'base.dart';

typedef ConnectivityCallback = Future<bool> Function();

///
/// You can use [Data] without [Entity]
///
class RemoteDataRepository<T extends Entity> extends DataRepository<T> {
  /// Flag indicating whether the repository is operating in cache mode.
  /// When in cache mode, the repository may use a local backup data source.
  final bool cacheMode;
  final bool localMode;

  /// The primary remote data source responsible for fetching data.
  final RemoteDataSource<T> source;

  /// An optional local data source used as a backup or cache when in cache mode.
  final LocalDataSource<T>? backup;

  /// Connectivity provider for checking internet connectivity.
  final ConnectivityCallback? connectivity;

  /// Getter for checking if the device is connected to the internet.
  Future<bool> get isConnected async {
    if (connectivity != null) return await connectivity!();
    return true;
  }

  /// Getter for checking if the device is disconnected from the internet.
  Future<bool> get isDisconnected async => !(await isConnected);

  /// Method to check if the repository is using a local backup data source.
  ///
  /// Example:
  /// ```dart
  /// if (userRepository.isLocalMode) {
  ///   // Handle local backup logic
  /// }
  /// ```
  bool get isBackupMode => backup != null;

  bool get isCacheMode => cacheMode && isBackupMode;

  bool get isLocalMode => localMode && isBackupMode;

  /// Constructor for creating a [RemoteDataRepository] implement.
  ///
  /// Parameters:
  /// - [source]: The primary remote data source. Ex: [ApiDataSource], [FirestoreDataSource], and [RealtimeDataSource].
  /// - [backup]: An optional local backup or cache data source. Ex: [LocalDataSourceImpl].
  /// - [isCacheMode]: Flag indicating whether the repository should operate in cache mode.
  ///
  RemoteDataRepository({
    required this.source,
    this.backup,
    this.cacheMode = true,
    this.localMode = false,
    this.connectivity,
  });

  /// Method to check data by ID with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.checkById(
  ///   'userId123',
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> checkById(
    String id, {
    DataFieldParams? params,
  }) {
    if (isLocalMode) {
      return backup!.checkById(id, params: params);
    } else {
      return isConnected.then((connected) {
        if (!connected && isCacheMode) {
          return backup!.checkById(id, params: params);
        } else {
          return source.checkById(id, isConnected: connected, params: params);
        }
      });
    }
  }

  /// Method to clear data with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.clear(
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> clear({
    DataFieldParams? params,
  }) {
    if (isLocalMode) {
      return backup!.clear(params: params);
    } else {
      return isConnected.then((connected) {
        if (!connected && isCacheMode) {
          return backup!.clear(params: params);
        } else {
          return source
              .clear(isConnected: connected, params: params)
              .then((value) {
            if (value.isSuccessful && isCacheMode) {
              return backup!.clear(params: params).then((_) => value);
            } else {
              return value;
            }
          });
        }
      });
    }
  }

  /// Method to count data with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.count(
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<int>> count({
    DataFieldParams? params,
  }) {
    if (isLocalMode) {
      return backup!.count(params: params);
    } else {
      return isConnected.then((connected) {
        if (!connected && isCacheMode) {
          return backup!.count(params: params);
        } else {
          return source
              .count(isConnected: connected, params: params)
              .then((value) {
            if (value.isSuccessful && isCacheMode) {
              return backup!.count(params: params).then((_) => value);
            } else {
              return value;
            }
          });
        }
      });
    }
  }

  /// Method to create data with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// T newData = //...;
  /// repository.create(
  ///   newData,
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> create(
    T data, {
    DataFieldParams? params,
  }) {
    if (isLocalMode) {
      return backup!.create(data, params: params);
    } else {
      return isConnected.then((connected) {
        if (!connected && isCacheMode) {
          return backup!.create(data, params: params);
        } else {
          return source
              .create(data, isConnected: connected, params: params)
              .then((value) {
            if (value.isSuccessful && isCacheMode) {
              return backup!.create(data, params: params).then((_) => value);
            } else {
              return value;
            }
          });
        }
      });
    }
  }

  /// Method to create multiple data entries with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<T> newDataList = //...;
  /// repository.creates(
  ///   newDataList,
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> creates(
    List<T> data, {
    DataFieldParams? params,
  }) {
    if (isLocalMode) {
      return backup!.creates(data, params: params);
    } else {
      return isConnected.then((connected) {
        if (!connected && isCacheMode) {
          return backup!.creates(data, params: params);
        } else {
          return source
              .creates(data, isConnected: connected, params: params)
              .then((value) {
            if (value.isSuccessful && data.isNotEmpty && isCacheMode) {
              return backup!.creates(data, params: params).then((_) => value);
            } else {
              return value;
            }
          });
        }
      });
    }
  }

  /// Method to delete data by ID with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.deleteById(
  ///   'userId123',
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> deleteById(
    String id, {
    DataFieldParams? params,
  }) {
    if (isLocalMode) {
      return backup!.deleteById(id, params: params);
    } else {
      return isConnected.then((connected) {
        if (!connected && isCacheMode) {
          return backup!.deleteById(id, params: params);
        } else {
          return source
              .deleteById(id, isConnected: connected, params: params)
              .then((value) {
            if (value.isSuccessful && isCacheMode) {
              return backup!.deleteById(id, params: params).then((_) => value);
            } else {
              return value;
            }
          });
        }
      });
    }
  }

  /// Method to delete data by multiple IDs with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<String> idsToDelete = ['userId1', 'userId2'];
  /// repository.deleteByIds(
  ///   idsToDelete,
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> deleteByIds(
    List<String> ids, {
    DataFieldParams? params,
  }) {
    if (isLocalMode) {
      return backup!.deleteByIds(ids, params: params);
    } else {
      return isConnected.then((connected) {
        if (!connected && isCacheMode) {
          return backup!.deleteByIds(ids, params: params);
        } else {
          return source
              .deleteByIds(ids, isConnected: connected, params: params)
              .then((value) {
            if (value.isSuccessful && isCacheMode) {
              return backup!
                  .deleteByIds(ids, params: params)
                  .then((_) => value);
            } else {
              return value;
            }
          });
        }
      });
    }
  }

  /// Method to get data with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.get(
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> get({
    DataFieldParams? params,
  }) async {
    if (isLocalMode) return backup!.get(params: params);
    final connected = await isConnected;
    if (!connected && isCacheMode) return backup!.get(params: params);
    final value = await source.get(isConnected: connected, params: params);
    if (!value.isValid || !isCacheMode) return value;
    return backup!.keep(value.result, params: params);
  }

  /// Method to get data by ID with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.getById(
  ///   'userId123',
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> getById(
    String id, {
    bool singleton = false,
    DataFieldParams? params,
  }) {
    return DataSingletonCallback.i.call(
      "getById",
      singleton: singleton,
      callback: () async {
        if (isLocalMode) return backup!.getById(id, params: params);
        final connected = await isConnected;
        if (!connected && isCacheMode) {
          return backup!.getById(id, params: params);
        }
        final value = await source.getById(
          id,
          params: params,
          isConnected: connected,
        );
        if (!value.isValid || !isCacheMode) return value;
        return backup!.keep([value.data!], params: params);
      },
    );
  }

  /// Method to get data by multiple IDs with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<String> idsToRetrieve = ['userId1', 'userId2'];
  /// repository.getByIds(
  ///   idsToRetrieve,
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> getByIds(
    List<String> ids, {
    DataFieldParams? params,
  }) {
    if (isLocalMode) {
      return backup!.getByIds(ids, params: params);
    } else {
      return isConnected.then((connected) {
        if (!connected && isCacheMode) {
          return backup!.getByIds(ids, params: params);
        } else {
          return source
              .getByIds(ids, isConnected: connected, params: params)
              .then((value) {
            if (value.isSuccessful && value.result.isNotEmpty && isCacheMode) {
              return backup!
                  .keep(value.result, params: params)
                  .then((_) => value);
            } else {
              return value;
            }
          });
        }
      });
    }
  }

  /// Method to get data by query with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<Query> queries = [Query.field('name', 'John')];
  /// repository.getByQuery(
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  ///   queries: queries,
  /// );
  /// ```
  @override
  Future<Response<T>> getByQuery({
    DataFieldParams? params,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) {
    if (isLocalMode) {
      return backup!.getByQuery(
        params: params,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
      );
    } else {
      return isConnected.then((connected) {
        if (!connected && isCacheMode) {
          return backup!.getByQuery(
            params: params,
            queries: queries,
            selections: selections,
            sorts: sorts,
            options: options,
          );
        } else {
          return source
              .getByQuery(
            params: params,
            queries: queries,
            selections: selections,
            sorts: sorts,
            options: options,
            isConnected: connected,
          )
              .then((value) {
            if (value.isSuccessful && value.result.isNotEmpty && isCacheMode) {
              return backup!
                  .keep(value.result, params: params)
                  .then((_) => value);
            } else {
              return value;
            }
          });
        }
      });
    }
  }

  /// Stream method to listen for data changes with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.listen(
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Stream<Response<T>> listen({
    DataFieldParams? params,
  }) {
    final controller = StreamController<Response<T>>();
    if (isLocalMode) {
      backup!.listen(params: params).listen(controller.add);
    } else {
      isConnected.then((connected) {
        if (!connected && isCacheMode) {
          backup!.listen(params: params).listen(controller.add);
        } else {
          source.listen(isConnected: connected, params: params).listen((value) {
            if (value.isSuccessful && value.result.isNotEmpty && isCacheMode) {
              backup!
                  .keep(value.result, params: params)
                  .then((_) => value)
                  .then(controller.add);
            } else {
              controller.add(value);
            }
          });
        }
      });
    }
    return controller.stream;
  }

  /// Method to listenCount data with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.listenCount(
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Stream<Response<int>> listenCount({
    DataFieldParams? params,
  }) {
    final controller = StreamController<Response<int>>();
    if (isLocalMode) {
      backup!.listenCount(params: params).listen(controller.add);
    } else {
      isConnected.then((connected) {
        if (!connected && isCacheMode) {
          backup!.listenCount(params: params).listen(controller.add);
        } else {
          source
              .listenCount(isConnected: connected, params: params)
              .listen((value) {
            if (value.isSuccessful && value.result.isNotEmpty && isCacheMode) {
              // backup!
              //     .keep(value.result, params: params)
              //     .then((_) => value)
              //     .then(controller.add);
            } else {
              controller.add(value);
            }
          });
        }
      });
    }
    return controller.stream;
  }

  /// Stream method to listen for data changes by ID with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.listenById(
  ///   'userId123',
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Stream<Response<T>> listenById(
    String id, {
    DataFieldParams? params,
  }) {
    final controller = StreamController<Response<T>>();
    if (isLocalMode) {
      backup!.listenById(id, params: params).listen(controller.add);
    } else {
      isConnected.then((connected) {
        if (!connected && isCacheMode) {
          backup!.listenById(id, params: params).listen(controller.add);
        } else {
          source
              .listenById(id, isConnected: connected, params: params)
              .listen((value) {
            if (value.isSuccessful && value.data != null && isCacheMode) {
              backup!
                  .keep([value.data!], params: params)
                  .then((_) => value)
                  .then(controller.add);
            } else {
              controller.add(value);
            }
          });
        }
      });
    }
    return controller.stream;
  }

  /// Stream method to listen for data changes by multiple IDs with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<String> idsToListen = ['userId1', 'userId2'];
  /// repository.listenByIds(
  ///   idsToListen,
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Stream<Response<T>> listenByIds(
    List<String> ids, {
    DataFieldParams? params,
  }) {
    final controller = StreamController<Response<T>>();
    if (isLocalMode) {
      backup!.listenByIds(ids, params: params).listen(controller.add);
    } else {
      isConnected.then((connected) {
        if (!connected && isCacheMode) {
          backup!.listenByIds(ids, params: params).listen(controller.add);
        } else {
          source
              .listenByIds(ids, isConnected: connected, params: params)
              .listen((value) {
            if (value.isSuccessful && value.result.isNotEmpty && isCacheMode) {
              backup!
                  .keep(value.result, params: params)
                  .then((_) => value)
                  .then(controller.add);
            } else {
              controller.add(value);
            }
          });
        }
      });
    }
    return controller.stream;
  }

  /// Stream method to listen for data changes by query with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<Query> queries = [Query.field('name', 'John')];
  /// repository.listenByQuery(
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  ///   queries: queries,
  /// );
  /// ```
  @override
  Stream<Response<T>> listenByQuery({
    DataFieldParams? params,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) {
    final controller = StreamController<Response<T>>();
    if (isLocalMode) {
      backup!
          .listenByQuery(
            params: params,
            queries: queries,
            selections: selections,
            sorts: sorts,
            options: options,
          )
          .listen(controller.add);
    } else {
      isConnected.then((connected) {
        if (!connected && isCacheMode) {
          backup!
              .listenByQuery(
                params: params,
                queries: queries,
                selections: selections,
                sorts: sorts,
                options: options,
              )
              .listen(controller.add);
        } else {
          source
              .listenByQuery(
            params: params,
            queries: queries,
            selections: selections,
            sorts: sorts,
            options: options,
            isConnected: connected,
          )
              .listen((value) {
            if (value.isSuccessful && value.result.isNotEmpty && isCacheMode) {
              backup!
                  .keep(value.result, params: params)
                  .then((_) => value)
                  .then(controller.add);
            } else {
              controller.add(value);
            }
          });
        }
      });
    }
    return controller.stream;
  }

  /// Method to check data by query with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// Checker checker = Checker(field: 'status', value: 'active');
  /// repository.search(
  ///   checker,
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> search(
    Checker checker, {
    DataFieldParams? params,
  }) {
    if (isLocalMode) {
      return backup!.search(checker, params: params);
    } else {
      return isConnected.then((connected) {
        if (!connected && isCacheMode) {
          return backup!.search(checker, params: params);
        } else {
          return source
              .search(checker, isConnected: connected, params: params)
              .then((value) {
            if (value.isSuccessful && value.result.isNotEmpty && isCacheMode) {
              return backup!
                  .keep(value.result, params: params)
                  .then((_) => value);
            } else {
              return value;
            }
          });
        }
      });
    }
  }

  /// Method to update data by ID with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.updateById(
  ///   'userId123',
  ///   {'status': 'inactive'},
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> updateById(
    String id,
    Map<String, dynamic> data, {
    DataFieldParams? params,
  }) {
    if (isLocalMode) {
      return backup!.updateById(id, data, params: params);
    } else {
      return isConnected.then((connected) {
        if (!connected && isCacheMode) {
          return backup!.updateById(id, data, params: params);
        } else {
          return source
              .updateById(id, data, isConnected: connected, params: params)
              .then((value) {
            if (value.isSuccessful && isCacheMode) {
              return backup!
                  .updateById(id, data, params: params)
                  .then((_) => value);
            } else {
              return value;
            }
          });
        }
      });
    }
  }

  /// Method to update data by multiple IDs with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<UpdatingInfo> updates = [
  ///   UpdatingInfo('userId1', {'status': 'inactive'}),
  ///   UpdatingInfo('userId2', {'status': 'active'}),
  /// ];
  /// repository.updateByIds(
  ///   updates,
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> updateByIds(
    List<UpdatingInfo> updates, {
    DataFieldParams? params,
  }) {
    if (isLocalMode) {
      return backup!.updateByIds(updates, params: params);
    } else {
      return isConnected.then((connected) {
        if (!connected && isCacheMode) {
          return backup!.updateByIds(updates, params: params);
        } else {
          return source
              .updateByIds(updates, isConnected: connected, params: params)
              .then((value) {
            if (value.isSuccessful && isCacheMode) {
              return backup!
                  .updateByIds(updates, params: params)
                  .then((_) => value);
            } else {
              return value;
            }
          });
        }
      });
    }
  }
}
