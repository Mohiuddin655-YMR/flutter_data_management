part of 'repositories.dart';

abstract class RemoteDataRepository<T extends Entity> extends DataRepository<T> {
  final bool isCacheMode;
  final RemoteDataSource<T> remote;
  final LocalDataSource<T>? local;

  RemoteDataRepository({
    super.connectivity,
    required this.remote,
    this.local,
    this.isCacheMode = false,
  });

  bool get isLocal => local != null;
}
