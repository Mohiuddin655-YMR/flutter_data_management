part of 'handlers.dart';

/// # Won't Use Directly
/// You can use:
/// * <b>[LocalDataHandlerImpl]</b> : Use for all local database related data.
///
abstract class LocalDataHandler<T extends Entity> extends DataHandler<T> {
  final LocalDataRepository<T> repository;

  LocalDataHandler({
    required this.repository,
  });
}
