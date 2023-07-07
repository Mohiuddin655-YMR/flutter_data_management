part of 'sources.dart';

abstract class RemoteDataSource<T extends Entity> extends DataSource<T> {
  final Encryptor? encryptor;

  bool get isEncryptor => encryptor.isValid;

  const RemoteDataSource({
    this.encryptor,
  });

  Future<(bool, List<T>, String?, Status)> findBy<R>({
    OnDataSourceBuilder<R>? builder,
  }) {
    return Future.error("Not initialized!");
  }

  Future<(bool, T?, String?, Status)> findById<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return Future.error("Not initialized!");
  }

  @override
  Future<Response<T>> getUpdates<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  @override
  Future<Response<T>> isAvailable<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  @override
  Future<Response<T>> insert<R>(
    T data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  @override
  Future<Response<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  @override
  Future<Response<T>> delete<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  @override
  Future<Response<T>> clear<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  @override
  Future<Response<T>> get<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  @override
  Future<Response<T>> gets<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  @override
  Stream<Response<T>> live<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  });

  @override
  Stream<Response<T>> lives<R>({
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
