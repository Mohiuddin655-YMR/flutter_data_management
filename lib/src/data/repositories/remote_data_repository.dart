part of 'repositories.dart';

class RemoteDataRepositoryImpl<T extends Entity> extends RemoteDataRepository<T> {
  RemoteDataRepositoryImpl({
    required super.remote,
    super.connectivity,
    super.local,
    super.isCacheMode,
  });

  @override
  Future<Response<T>> clear<R>({
    OnDataSourceBuilder<R>? source,
  }) async {
    if (isCacheMode && isLocal) {
      return local!.clear(source: source);
    } else {
      var connected = await isConnected;
      var response = await remote.clear(
        isConnected: connected,
        source: source,
      );
      if (response.isSuccessful && isLocal) {
        await local!.clear(source: source);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) async {
    if (isCacheMode && isLocal) {
      return local!.delete(id, source: source);
    } else {
      var connected = await isConnected;
      var response = await remote.delete(
        id,
        isConnected: connected,
        source: source,
      );
      if (response.isSuccessful && isLocal) {
        await local!.delete(id, source: source);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) async {
    if (isCacheMode && isLocal) {
      return local!.get(id, source: source);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return local!.get(id, source: source);
      } else {
        return remote.get(
          id,
          isConnected: connected,
          source: source,
        );
      }
    }
  }

  @override
  Future<Response<T>> getUpdates<R>({
    OnDataSourceBuilder<R>? source,
  }) async {
    if (isCacheMode && isLocal) {
      return local!.getUpdates(source: source);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return local!.getUpdates(
          source: source,
        );
      } else {
        return remote.getUpdates(
          isConnected: connected,
          source: source,
        );
      }
    }
  }

  @override
  Future<Response<T>> gets<R>({
    OnDataSourceBuilder<R>? source,
  }) async {
    if (isCacheMode && isLocal) {
      return local!.gets(
        source: source,
      );
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return local!.gets(
          source: source,
        );
      } else {
        return remote.gets(
          isConnected: connected,
          source: source,
        );
      }
    }
  }

  @override
  Future<Response<T>> insert<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
  }) async {
    if (isCacheMode && isLocal) {
      return local!.insert(data, source: source);
    } else {
      var connected = await isConnected;
      var response = await remote.insert(
        data,
        isConnected: connected,
        source: source,
      );
      if (response.isSuccessful && isLocal) {
        await local!.insert(data, source: source);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? source,
  }) async {
    if (isCacheMode && isLocal) {
      return local!.inserts(data, source: source);
    } else {
      var connected = await isConnected;
      var response = await remote.inserts(
        data,
        isConnected: connected,
        source: source,
      );
      if (response.isSuccessful && isLocal) {
        await local!.inserts(data, source: source);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) async {
    if (isCacheMode && isLocal) {
      return local!.isAvailable(id, source: source);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return local!.isAvailable(
          id,
          source: source,
        );
      } else {
        return remote.isAvailable(
          id,
          isConnected: connected,
          source: source,
        );
      }
    }
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) async* {
    if (isCacheMode && isLocal) {
      yield* local!.live(id, source: source);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        yield* local!.live(
          id,
          source: source,
        );
      } else {
        yield* remote.live(
          id,
          isConnected: connected,
          source: source,
        );
      }
    }
  }

  @override
  Stream<Response<T>> lives<R>({
    OnDataSourceBuilder<R>? source,
  }) async* {
    if (isCacheMode && isLocal) {
      yield* local!.lives(source: source);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        yield* local!.lives(
          source: source,
        );
      } else {
        yield* remote.lives(
          isConnected: connected,
          source: source,
        );
      }
    }
  }

  @override
  Future<Response<T>> update<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
  }) async {
    if (isCacheMode && isLocal) {
      return local!.update(data, source: source);
    } else {
      var connected = await isConnected;
      var response = await remote.update(
        data,
        isConnected: connected,
        source: source,
      );
      if (response.isSuccessful && isLocal) {
        await local!.update(data, source: source);
      }
      return response;
    }
  }
}
