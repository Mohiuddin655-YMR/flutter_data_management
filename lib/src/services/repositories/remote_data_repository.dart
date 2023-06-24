part of 'repositories.dart';

abstract class RemoteDataRepository<T extends Entity> extends DataRepository<T> {
  final bool isCacheMode;
  final RemoteDataSource<T> source;
  final LocalDataSource<T>? backup;

  RemoteDataRepository({
    super.connectivity,
    required this.source,
    this.backup,
    this.isCacheMode = false,
  });

  bool get isLocal => backup != null;
}
