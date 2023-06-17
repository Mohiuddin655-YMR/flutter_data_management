part of 'handlers.dart';

abstract class RemoteDataHandler<T extends Entity> extends DataHandler<T> {
  final RemoteDataRepository<T> repository;

  RemoteDataHandler({
    required this.repository,
  });
}
