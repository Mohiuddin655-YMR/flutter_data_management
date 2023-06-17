part of 'handlers.dart';

abstract class LocalDataHandler<T extends Entity> extends DataHandler<T> {
  final LocalDataRepository<T> repository;

  LocalDataHandler({
    required this.repository,
  });
}
