part of 'controllers.dart';

class RemoteDataController<T extends Entity> extends Cubit<Response<T>> {
  final RemoteDataHandler<T> handler;

  RemoteDataController({
    required this.handler,
  }) : super(Response<T>());

  void clear<R>({
    OnDataSourceBuilder<R>? source,
  }) async {
    emit(state.copy(loading: true));
    try {
      var result = await handler.clear(
        source: source,
      );
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(
        exception: "Something went wrong!",
      ));
    }
  }

  void delete<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) async {
    emit(state.copy(loading: true));
    try {
      var result = await handler.delete(
        id,
        source: source,
      );
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: "Something went wrong!"));
    }
  }

  void get<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) async {
    emit(state.copy(loading: true));
    try {
      var result = await handler.get(
        id,
        source: source,
      );
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: "Something went wrong!"));
    }
  }

  void getUpdates<R>({
    OnDataSourceBuilder<R>? source,
  }) async {
    emit(state.copy(loading: true));
    try {
      var result = await handler.getUpdates(
        source: source,
      );
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: "Something went wrong!"));
    }
  }

  void gets<R>({
    OnDataSourceBuilder<R>? source,
  }) async {
    emit(state.copy(loading: true));
    try {
      var result = await handler.gets(
        source: source,
      );
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: "Something went wrong!"));
    }
  }

  void insert<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
  }) async {
    emit(state.copy(loading: true));
    try {
      var result = await handler.insert(
        data,
        source: source,
      );
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: "Something went wrong!"));
    }
  }

  void inserts<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? source,
  }) async {
    emit(state.copy(loading: true));
    try {
      var result = await handler.inserts(
        data,
        source: source,
      );
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: "Something went wrong!"));
    }
  }

  void isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) async {
    emit(state.copy(loading: true));
    try {
      var result = await handler.isAvailable(
        id,
        source: source,
      );
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: "Something went wrong!"));
    }
  }

  void update<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
  }) async {
    emit(state.copy(loading: true));
    try {
      var result = await handler.update(
        data,
        source: source,
      );
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: "Something went wrong!"));
    }
  }

  Stream<Response<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    return handler.live(
      id,
      source: source,
    );
  }

  Stream<Response<T>> lives<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    return handler.lives(
      source: source,
    );
  }
}
