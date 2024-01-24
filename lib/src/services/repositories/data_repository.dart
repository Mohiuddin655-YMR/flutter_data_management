part of 'repositories.dart';

/// # Won't Use Directly
/// You can use:
/// * <b>[RemoteDataRepositoryImpl]</b> : Use for all remote database related data.
/// * <b>[LocalDataRepositoryImpl]</b> : Use for all local database related data.
///
abstract class DataRepository<T extends Entity> {
  final ConnectivityProvider connectivity;

  DataRepository({
    ConnectivityProvider? connectivity,
  }) : connectivity = connectivity ?? ConnectivityProvider.I;

  Future<bool> get isConnected async => await connectivity.isConnected;

  Future<bool> get isDisconnected async => !(await isConnected);

  /// Use for check current data
  Future<DataResponse<T>> isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for create single data
  Future<DataResponse<T>> insert<R>(
    T data, {
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for create multiple data
  Future<DataResponse<T>> inserts<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for update single data
  Future<DataResponse<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for delete single data
  Future<DataResponse<T>> delete<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for delete all data
  Future<DataResponse<T>> clear<R>({
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for fetch single data
  Future<DataResponse<T>> get<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for fetch all data
  Future<DataResponse<T>> gets<R>({
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for fetch all recent updated data
  Future<DataResponse<T>> getUpdates<R>({
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for fetch single observable data when data update
  Stream<DataResponse<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for fetch all observable data when data update
  Stream<DataResponse<T>> lives<R>({
    OnDataSourceBuilder<R>? builder,
  });
}
