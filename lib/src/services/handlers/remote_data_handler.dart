part of 'handlers.dart';

/// # Won't Use Directly
/// You can use:
/// * <b>[RemoteDataHandlerImpl]</b> : Use for all remote database related data.
///
abstract class RemoteDataHandler<T extends Entity> extends DataHandler<T> {
  final RemoteDataRepository<T> repository;

  RemoteDataHandler({
    required this.repository,
  });
}
