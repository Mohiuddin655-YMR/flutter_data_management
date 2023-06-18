part of 'controllers.dart';

abstract class DataController<T extends Entity> extends Cubit<Response<T>> {
  DataController() : super(Response<T>());

  void isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  });

  void create<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
  });

  void creates<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? source,
  });

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

  void request<R>(
    Future<Response<T>> Function() callback,
  ) async {
    emit(state.copy(loading: true));
    try {
      var result = await callback();
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: "Something went wrong!"));
    }
  }
}
