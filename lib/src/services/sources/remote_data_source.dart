part of 'sources.dart';

/// # Won't Use Directly
/// You can use:
/// * <b>[ApiDataSource]</b> : Use for Api related data.
/// * <b>[FireStoreDataSource]</b> : Use for Firebase Cloud firestore related data.
/// * <b>[RealtimeDataSource]</b> : Use for Firebase realtime database related data.
///
abstract class RemoteDataSource<T extends Entity> extends DataSource<T> {
  final Encryptor? encryptor;

  bool get isEncryptor => encryptor.isValid;

  const RemoteDataSource({
    this.encryptor,
  });

  /// Use for check current data
  @override
  Future<DataResponse<T>> isAvailable<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for create single data
  @override
  Future<DataResponse<T>> insert<R>(
    T data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for create multiple data
  @override
  Future<DataResponse<T>> inserts<R>(
    List<T> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for update single data
  @override
  Future<DataResponse<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for delete single data
  @override
  Future<DataResponse<T>> delete<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for delete all data
  @override
  Future<DataResponse<T>> clear<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for fetch single data
  @override
  Future<DataResponse<T>> get<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for fetch all data
  @override
  Future<DataResponse<T>> gets<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for fetch all recent updated data
  @override
  Future<DataResponse<T>> getUpdates<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for fetch single observable data when data update
  @override
  Stream<DataResponse<T>> live<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  /// Use for fetch all observable data when data update
  @override
  Stream<DataResponse<T>> lives<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  Future<Map<String, dynamic>> input(dynamic data) => encryptor.input(data);

  Future<Map<String, dynamic>> output(dynamic data) => encryptor.output(data);
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
