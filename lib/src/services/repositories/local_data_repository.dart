part of 'repositories.dart';

abstract class LocalDataRepository<T extends Entity> extends DataRepository<T> {
  final LocalDataSource<T> source;

  LocalDataRepository({
    super.connectivity,
    required this.source,
  });
}
