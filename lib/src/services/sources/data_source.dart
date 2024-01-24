part of 'sources.dart';

typedef OnDataBuilder<T extends Entity> = T Function(dynamic);
typedef OnDataSourceBuilder<R> = R? Function(R parent);

/// # Won't Use Directly
/// You can use:
/// * <b>[ApiDataSource]</b> : Use for Api related data.
/// * <b>[FireStoreDataSource]</b> : Use for Firebase Cloud firestore related data.
/// * <b>[RealtimeDataSource]</b> : Use for Firebase realtime database related data.
/// * <b>[LocalDataSourceImpl]</b> : Use for local or save instance related data.
///
abstract class DataSource<T extends Entity> {
  const DataSource();

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

  T build(dynamic source);
}
