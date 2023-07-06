part of 'repositories.dart';

class RemoteDataRepositoryImpl<T extends Data> extends RemoteDataRepository<T> {
  RemoteDataRepositoryImpl({
    required super.source,
    super.connectivity,
    super.backup,
    super.isCacheMode,
  });

  @override
  Future<Response<T>> isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.isAvailable(id, builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.isAvailable(
          id,
          builder: builder,
        );
      } else {
        return source.isAvailable(
          id,
          isConnected: connected,
          builder: builder,
        );
      }
    }
  }

  @override
  Future<Response<T>> insert<R>(
    T data, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.insert(data, builder: builder);
    } else {
      var connected = await isConnected;
      var response = await source.insert(
        data,
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.insert(data, builder: builder);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.inserts(data, builder: builder);
    } else {
      var connected = await isConnected;
      var response = await source.inserts(
        data,
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.inserts(data, builder: builder);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.update(id, data, builder: builder);
    } else {
      var connected = await isConnected;
      var response = await source.update(
        id,
        data,
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.update(id, data, builder: builder);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.delete(id, builder: builder);
    } else {
      var connected = await isConnected;
      var response = await source.delete(
        id,
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.delete(id, builder: builder);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> clear<R>({
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.clear(builder: builder);
    } else {
      var connected = await isConnected;
      var response = await source.clear(
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.clear(builder: builder);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.get(id, builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.get(id, builder: builder);
      } else {
        return source.get(
          id,
          isConnected: connected,
          builder: builder,
        );
      }
    }
  }

  @override
  Future<Response<T>> gets<R>({
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.gets(
        builder: builder,
      );
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.gets(
          builder: builder,
        );
      } else {
        return source.gets(
          isConnected: connected,
          builder: builder,
        );
      }
    }
  }

  @override
  Future<Response<T>> getUpdates<R>({
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.getUpdates(builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.getUpdates(
          builder: builder,
        );
      } else {
        return source.getUpdates(
          isConnected: connected,
          builder: builder,
        );
      }
    }
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) async* {
    if (isCacheMode && isLocal) {
      yield* backup!.live(id, builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        yield* backup!.live(
          id,
          builder: builder,
        );
      } else {
        yield* source.live(
          id,
          isConnected: connected,
          builder: builder,
        );
      }
    }
  }

  @override
  Stream<Response<T>> lives<R>({
    OnDataSourceBuilder<R>? builder,
  }) async* {
    if (isCacheMode && isLocal) {
      yield* backup!.lives(builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        yield* backup!.lives(
          builder: builder,
        );
      } else {
        yield* source.lives(
          isConnected: connected,
          builder: builder,
        );
      }
    }
  }
}
