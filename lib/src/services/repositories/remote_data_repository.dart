import 'package:data_management/core.dart';
import 'package:flutter_andomie/core.dart';

/// A repository for handling remote data operations, extending the [DataRepository] interface.
/// This repository is designed for use with entities of type [T].
///
/// Example:
/// ```dart
/// RemoteDataRepository<User> userRepository = RemoteDataRepository<User>(
///   source: RemoteApiDataSource<User>(),
///   backup: LocalDatabaseDataSource<User>(),
///   isCacheMode: true,
/// );
/// ```
abstract class RemoteDataRepository<T extends Entity>
    extends DataRepository<T> {
  /// Flag indicating whether the repository is operating in cache mode.
  /// When in cache mode, the repository may use a local backup data source.
  final bool isCacheMode;

  /// The primary remote data source responsible for fetching data.
  final RemoteDataSource<T> source;

  /// An optional local data source used as a backup or cache when in cache mode.
  final LocalDataSource<T>? backup;

  /// Method to check if the repository is using a local backup data source.
  ///
  /// Example:
  /// ```dart
  /// if (userRepository.isLocal) {
  ///   // Handle local backup logic
  /// }
  /// ```
  bool get isLocal => backup != null;

  /// Constructor for creating a [RemoteDataRepository] implement.
  ///
  /// Parameters:
  /// - [source]: The primary remote data source. Ex: [ApiDataSource], [FirestoreDataSource], and [RealtimeDataSource].
  /// - [backup]: An optional local backup or cache data source. Ex: [LocalDataSourceImpl].
  /// - [isCacheMode]: Flag indicating whether the repository should operate in cache mode.
  ///
  RemoteDataRepository({
    super.connectivity,
    required this.source,
    this.backup,
    this.isCacheMode = false,
  });

  /// Factory method to create a [RemoteDataRepository] instance.
  ///
  /// Parameters:
  /// - [source]: The primary remote data source. Ex: [ApiDataSource], [FirestoreDataSource], and [RealtimeDataSource].
  /// - [backup]: An optional local backup or cache data source. Ex: [LocalDataSourceImpl].
  /// - [isCacheMode]: Flag indicating whether the repository should operate in cache mode.
  /// - [connectivity]: An optional connectivity provider for checking network connectivity.
  ///
  /// Example:
  /// ```dart
  /// RemoteDataRepository<User> userRepository = RemoteDataRepository<User>.create(
  ///   source: FirestoreDataSource<User>(),
  ///   backup: LocalDataSourceImpl<User>(),
  ///   isCacheMode: true,
  /// );
  /// ```
  factory RemoteDataRepository.create({
    required RemoteDataSource<T> source,
    LocalDataSource<T>? backup,
    bool isCacheMode = false,
    ConnectivityProvider? connectivity,
  }) {
    return RemoteDataRepositoryImpl(
      source: source,
      backup: backup,
      connectivity: connectivity,
      isCacheMode: isCacheMode,
    );
  }
}
