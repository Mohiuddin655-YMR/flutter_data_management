import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

import '../../core/configs.dart';
import '../../core/typedefs.dart';
import '../../data/repositories/local_data_repository.dart';
import '../../data/repositories/remote_data_repository.dart';
import '../../models/checker.dart';
import '../../models/updating_info.dart';
import '../../utils/errors.dart';
import '../../utils/response.dart';
import '../../widgets/provider.dart';
import '../repositories/local_data_repository.dart';
import '../repositories/remote_data_repository.dart';
import '../sources/local_data_source.dart';
import '../sources/remote_data_source.dart';

part '../../../src/data/controllers/local_data_controller.dart';
part '../../../src/data/controllers/remote_data_controller.dart';

/// A generic data controller that extends [ValueNotifier<DataResponse<T>>].
/// This controller is designed to manage and notify the state of data responses for entities of type [T].
///
/// Example:
///
/// ### A data source for handling cached data operations.
///
/// - Make a local data source class for handle cart json data
///
/// ```dart
/// class LocalCartDataSource extends LocalDataSourceImpl<Cart> {
///   // Implement local data source operations for add to cart entities.
/// }
///
/// ```dart
/// DataController<Cart> cartController = DataController.fromLocalRepository(
///   repository: LocalDataRepository<Cart>.create(source: LocalCartDataSource()),
/// );
/// ```
///
/// ### A data source for handling remote database operations.
///
/// Example:
///
/// - Make a remote data source class for handle user json data
///
/// ```dart
/// class RemoteUserDataSource extends FirestoreDataSource {
///   // Implement Firestore data source operations for User entities.
/// }
/// ```
/// ```dart
/// DataController userController = DataController.fromRemoteRepository(
///   repository: RemoteDataRepository.create(source: RemoteUserDataSource()),
/// );
/// ```
abstract class DataController<T extends Entity>
    extends ValueNotifier<DataResponse<T>> {
  /// Protected constructor for creating a [DataController] with an initial [DataResponse].
  DataController._() : super(DataResponse<T>());

  /// Factory method to obtain a [DataController] from a [BuildContext].
  ///
  /// Parameters:
  /// - [context]: The BuildContext from which to retrieve the DataController.
  ///
  /// Example:
  /// ```dart
  /// DataController userController = DataController.of(context);
  /// ```
  factory DataController.of(BuildContext context) {
    return DataControllers.of<DataController<T>>(context);
  }

  /// Factory method to create a [DataController] associated with a local data repository.
  ///
  /// Parameters:
  /// - [repository]: The local data repository.
  ///
  /// Example:
  /// ```dart
  /// DataController userController = DataController.fromLocalRepository(
  ///   repository: LocalDataRepository(source: LocalDatabaseDataSource()),
  /// );
  /// ```
  factory DataController.fromLocalRepository({
    required LocalDataRepository<T> repository,
  }) {
    return DataController._local(repository: repository);
  }

  /// Factory method to create a [DataController] associated with a local data source.
  ///
  /// Parameters:
  /// - [source]: The local data source.
  ///
  /// Example:
  /// ```dart
  /// DataController userController = DataController.fromLocalSource(
  ///   source: LocalDatabaseDataSource(),
  /// );
  /// ```
  factory DataController.fromLocalSource({
    required LocalDataSource<T> source,
  }) {
    return DataController._local(source: source);
  }

  /// Factory method to create a [DataController] associated with a remote data repository.
  ///
  /// Parameters:
  /// - [repository]: The remote data repository.
  ///
  /// Example:
  /// ```dart
  /// DataController userController = DataController.fromRemoteRepository(
  ///   repository: RemoteDataRepository(source: RemoteApiDataSource()),
  /// );
  /// ```
  factory DataController.fromRemoteRepository({
    required RemoteDataRepository<T> repository,
  }) {
    return DataController._remote(repository: repository);
  }

  /// Factory method to create a [DataController] associated with a remote data source.
  ///
  /// Parameters:
  /// - [source]: The remote data source.
  /// - [connectivity]: An optional connectivity provider for checking network connectivity.
  /// - [backup]: An optional local backup data source.
  /// - [isCacheMode]: Flag indicating whether the controller should operate in cache mode.
  ///
  /// Example:
  /// ```dart
  /// DataController userController = DataController.fromRemoteSource(
  ///   source: RemoteApiDataSource(),
  ///   backup: LocalDatabaseDataSource(),
  ///   connectivity: ConnectivityProvider(),
  ///   isCacheMode: true,
  /// );
  /// ```
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
    LocalDataRepository<T>? repository,
    LocalDataSource<T>? source,
  }) {
    if (repository != null) {
      return LocalDataController(repository);
    } else if (source != null) {
      return LocalDataController(LocalDataRepositoryImpl<T>(source: source));
    } else {
      throw const DataException("Data controller not initialized!");
    }
  }

  factory DataController._remote({
    RemoteDataRepository<T>? repository,
    RemoteDataSource<T>? source,
    LocalDataSource<T>? backup,
    ConnectivityProvider? connectivity,
    bool isCacheMode = false,
  }) {
    if (repository != null) {
      return RemoteDataController(repository);
    } else if (source != null) {
      return RemoteDataController(RemoteDataRepositoryImpl<T>(
        source: source,
        backup: backup,
        connectivity: connectivity,
        isCacheMode: isCacheMode,
      ));
    } else {
      throw const DataException("Data controller not initialized!");
    }
  }

  DataResponse<T> emit(
    DataResponse<T> value, [
    bool forceNotify = false,
  ]) {
    this.value = value;
    if (forceNotify) notifyListeners();
    return value;
  }

  Future<DataResponse<T>> notifier(
    Future<DataResponse<T>> Function() callback,
  ) async {
    emit(value.copy(loading: true, status: Status.loading));
    try {
      var result = await callback();
      return emit(value.from(result));
    } catch (_) {
      return emit(value.copy(
        exception: _.toString(),
        status: Status.failure,
      ));
    }
  }

  /// Method to check data by ID with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.checkById(
  ///   'userId123',
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> checkById(
    String id, {
    OnDataSourceBuilder? builder,
  }) {
    throw const DataException('checkById method is not implemented');
  }

  /// Method to clear data with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.clear(
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> clear({
    OnDataSourceBuilder? builder,
  }) {
    throw const DataException('clear method is not implemented');
  }

  /// Method to create data with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// T newData = //...;
  /// repository.create(
  ///   newData,
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> create(
    T data, {
    OnDataSourceBuilder? builder,
  }) {
    throw const DataException('create method is not implemented');
  }

  /// Method to create multiple data entries with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<T> newDataList = //...;
  /// repository.creates(
  ///   newDataList,
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> creates(
    List<T> data, {
    OnDataSourceBuilder? builder,
  }) {
    throw const DataException('creates method is not implemented');
  }

  /// Method to delete data by ID with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.deleteById(
  ///   'userId123',
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> deleteById(
    String id, {
    OnDataSourceBuilder? builder,
  }) {
    throw const DataException('deleteById method is not implemented');
  }

  /// Method to delete data by multiple IDs with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<String> idsToDelete = ['userId1', 'userId2'];
  /// repository.deleteByIds(
  ///   idsToDelete,
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> deleteByIds(
    List<String> ids, {
    OnDataSourceBuilder? builder,
  }) {
    throw const DataException('deleteByIds method is not implemented');
  }

  /// Method to get data with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.get(
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> get({
    bool forUpdates = false,
    OnDataSourceBuilder? builder,
  }) {
    throw const DataException('get method is not implemented');
  }

  /// Method to get data by ID with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.getById(
  ///   'userId123',
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> getById(
    String id, {
    OnDataSourceBuilder? builder,
  }) {
    throw const DataException('getById method is not implemented');
  }

  /// Method to get data by multiple IDs with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<String> idsToRetrieve = ['userId1', 'userId2'];
  /// repository.getByIds(
  ///   idsToRetrieve,
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> getByIds(
    List<String> ids, {
    bool forUpdates = false,
    OnDataSourceBuilder? builder,
  }) {
    throw const DataException('getByIds method is not implemented');
  }

  /// Method to get data by query with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<Query> queries = [Query.field('name', 'John')];
  /// repository.getByQuery(
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///   },
  ///   queries: queries,
  /// );
  /// ```
  Future<DataResponse<T>> getByQuery({
    OnDataSourceBuilder? builder,
    bool forUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) {
    throw const DataException('getByQuery method is not implemented');
  }

  /// Stream method to listen for data changes with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.listen(
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///   },
  /// );
  /// ```
  Stream<DataResponse<T>> listen({
    OnDataSourceBuilder? builder,
  }) {
    throw const DataException('listen method is not implemented');
  }

  /// Stream method to listen for data changes by ID with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.listenById(
  ///   'userId123',
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///   },
  /// );
  /// ```
  Stream<DataResponse<T>> listenById(
    String id, {
    OnDataSourceBuilder? builder,
  }) {
    throw const DataException('listenById method is not implemented');
  }

  /// Stream method to listen for data changes by multiple IDs with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<String> idsToListen = ['userId1', 'userId2'];
  /// repository.listenByIds(
  ///   idsToListen,
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///   },
  /// );
  /// ```
  Stream<DataResponse<T>> listenByIds(
    List<String> ids, {
    bool forUpdates = false,
    OnDataSourceBuilder? builder,
  }) {
    throw const DataException('listenByIds method is not implemented');
  }

  /// Stream method to listen for data changes by query with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<Query> queries = [Query.field('name', 'John')];
  /// repository.listenByQuery(
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///   },
  ///   queries: queries,
  /// );
  /// ```
  Stream<DataResponse<T>> listenByQuery({
    OnDataSourceBuilder? builder,
    bool forUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) {
    throw const DataException('listenByQuery method is not implemented');
  }

  /// Method to check data by query with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// Checker checker = Checker(field: 'status', value: 'active');
  /// repository.search(
  ///   checker,
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> search(
    Checker checker, {
    OnDataSourceBuilder? builder,
  }) {
    throw const DataException('checkByQuery method is not implemented');
  }

  /// Method to update data by ID with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.updateById(
  ///   'userId123',
  ///   {'status': 'inactive'},
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> updateById({
    required String id,
    required Map<String, dynamic> data,
    OnDataSourceBuilder? builder,
  }) {
    throw const DataException('updateById method is not implemented');
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
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> updateByIds(
    List<UpdatingInfo> updates, {
    OnDataSourceBuilder? builder,
  }) {
    throw const DataException('updateByIds method is not implemented');
  }
}
