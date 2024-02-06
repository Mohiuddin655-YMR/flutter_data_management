import 'package:flutter_andomie/core.dart';

import '../../core/configs.dart';
import '../../core/typedefs.dart';
import '../../models/checker.dart';
import '../../models/updating_info.dart';
import '../../utils/errors.dart';
import '../../utils/response.dart';

/// ## Abstract class representing a generic data repository with methods for CRUD operations.
///
/// This abstract class defines the structure of a generic data repository.
/// It is not intended to be used directly. Instead, use its implementations:
/// * <b>[RemoteDataRepositoryImpl]</b> : Use for all remote database related data.
/// * <b>[LocalDataRepositoryImpl]</b> : Use for all local database related data.
///
/// Example:
/// ```dart
/// final DataRepository userRepository = RemoteDataRepositoryImpl();
/// final DataRepository<Post> postRepository = LocalDataRepositoryImpl<Post>();
/// ```

abstract class DataRepository<T extends Entity> {
  /// Connectivity provider for checking internet connectivity.
  final ConnectivityProvider connectivity;

  /// Constructor with an optional parameter for the connectivity provider.
  DataRepository({
    ConnectivityProvider? connectivity,
  }) : connectivity = connectivity ?? ConnectivityProvider.I;

  /// Getter for checking if the device is connected to the internet.
  Future<bool> get isConnected async => await connectivity.isConnected;

  /// Getter for checking if the device is disconnected from the internet.
  Future<bool> get isDisconnected async => !(await isConnected);

  /// Method to check data by ID with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.checkById(
  ///   'userId123',
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> checkById<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
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
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> clear<R>({
    OnDataSourceBuilder<R>? builder,
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
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> create<R>(
    T data, {
    OnDataSourceBuilder<R>? builder,
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
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> creates<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? builder,
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
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> deleteById<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
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
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> deleteByIds<R>(
    List<String> ids, {
    OnDataSourceBuilder<R>? builder,
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
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> get<R>({
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
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
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> getById<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
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
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> getByIds<R>(
    List<String> ids, {
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
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
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  ///   queries: queries,
  /// );
  /// ```
  Future<DataResponse<T>> getByQuery<R>({
    OnDataSourceBuilder<R>? builder,
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
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  Stream<DataResponse<T>> listen<R>({
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
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
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  Stream<DataResponse<T>> listenById<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
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
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  Stream<DataResponse<T>> listenByIds<R>(
    List<String> ids, {
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
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
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  ///   queries: queries,
  /// );
  /// ```
  Stream<DataResponse<T>> listenByQuery<R>({
    OnDataSourceBuilder<R>? builder,
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
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> search<R>(
    Checker checker, {
    OnDataSourceBuilder<R>? builder,
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
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> updateById<R>(
    String id,
    Map<String, dynamic> data, {
    OnDataSourceBuilder<R>? builder,
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
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  Future<DataResponse<T>> updateByIds<R>(
    List<UpdatingInfo> updates, {
    OnDataSourceBuilder<R>? builder,
  }) {
    throw const DataException('updateByIds method is not implemented');
  }
}
