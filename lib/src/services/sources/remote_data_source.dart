import 'package:flutter_andomie/core.dart';

import '../../core/configs.dart';
import '../../core/typedefs.dart';
import '../../models/checker.dart';
import '../../models/updating_info.dart';
import '../../utils/errors.dart';
import '../../utils/response.dart';
import 'data_source.dart';

/// ## Abstract class representing a data source for handling operations related to entities of type [T].
///
/// ### A data source for handling api based data operations.
///
/// Example:
/// ```dart
/// class ApiUserDataSource extends ApiDataSource {
///   // Implement api based data source operations for User entities.
/// }
/// ```
///
/// ### A data source for handling Firestore database operations.
///
/// Example:
/// ```dart
/// class FirestoreUserDataSource extends FirestoreDataSource {
///   // Implement Firestore data source operations for User entities.
/// }
/// ```
///
/// ### A data source for handling Realtime database operations.
///
/// Example:
/// ```dart
/// class RealtimeUserDataSource extends RealtimeDataSource {
///   // Implement real-time data source operations for User entities.
/// }
/// ```
///
/// ## Abstract class representing a generic data repository with methods for CRUD operations.
///
/// This abstract class defines the structure of a generic data repository.
/// It is not intended to be used directly. Instead, use its implementations:
/// * <b>[ApiDataSource]</b> : Use for Api related data.
/// * <b>[FireStoreDataSource]</b> : Use for Firebase Cloud firestore related data.
/// * <b>[RealtimeDataSource]</b> : Use for Firebase realtime database related data.
///
/// Example:
/// ```dart
/// final RemoteDataSource remoteUserDataSource = RemoteUserDataSource();
/// final LocalDataSource localUserDataSource = LocalUserDataSource();
/// ```
///
abstract class RemoteDataSource<T extends Entity> extends DataSource<T> {
  final Encryptor? encryptor;

  bool get isEncryptor => encryptor.isValid;

  const RemoteDataSource({
    this.encryptor,
  });

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
  @override
  Future<DataResponse<T>> checkById(
    String id, {
    bool isConnected = false,
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
  @override
  Future<DataResponse<T>> clear({
    bool isConnected = false,
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
  @override
  Future<DataResponse<T>> create(
    T data, {
    bool isConnected = false,
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
  @override
  Future<DataResponse<T>> creates(
    List<T> data, {
    bool isConnected = false,
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
  @override
  Future<DataResponse<T>> deleteById(
    String id, {
    bool isConnected = false,
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
  @override
  Future<DataResponse<T>> deleteByIds(
    List<String> ids, {
    bool isConnected = false,
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
  @override
  Future<DataResponse<T>> get({
    bool isConnected = false,
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
  @override
  Future<DataResponse<T>> getById(
    String id, {
    bool isConnected = false,
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
  @override
  Future<DataResponse<T>> getByIds(
    List<String> ids, {
    bool isConnected = false,
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
  @override
  Future<DataResponse<T>> getByQuery({
    bool isConnected = false,
    bool forUpdates = false,
    OnDataSourceBuilder? builder,
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
  @override
  Stream<DataResponse<T>> listen({
    bool isConnected = false,
    bool forUpdates = false,
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
  @override
  Stream<DataResponse<T>> listenById(
    String id, {
    bool isConnected = false,
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
  @override
  Stream<DataResponse<T>> listenByIds(
    List<String> ids, {
    bool isConnected = false,
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
  @override
  Stream<DataResponse<T>> listenByQuery({
    bool isConnected = false,
    bool forUpdates = false,
    OnDataSourceBuilder? builder,
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
  @override
  Future<DataResponse<T>> search(
    Checker checker, {
    bool isConnected = false,
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
  @override
  Future<DataResponse<T>> updateById(
    String id,
    Map<String, dynamic> data, {
    bool isConnected = false,
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
  @override
  Future<DataResponse<T>> updateByIds(
    List<UpdatingInfo> updates, {
    bool isConnected = false,
    OnDataSourceBuilder? builder,
  }) {
    throw const DataException('updateByIds method is not implemented');
  }
}

extension EncryptorExtension on Encryptor? {
  bool get isValid => this != null;

  Encryptor get use => this ?? const Encryptor();

  Future<Map<String, dynamic>> input(dynamic data) async {
    return isValid ? await use.input(data) : {};
  }

  Future<Map<String, dynamic>> output(dynamic data) async {
    return isValid ? await use.output(data) : {};
  }
}
