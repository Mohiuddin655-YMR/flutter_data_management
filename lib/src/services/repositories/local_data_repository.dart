part of 'repositories.dart';

/// # Won't Use Directly
/// You can use:
/// * <b>[LocalDataRepositoryImpl]</b> : Use for all local database related data.
///
abstract class LocalDataRepository<T extends Entity> extends DataRepository<T> {
  final LocalDataSource<T> source;

  LocalDataRepository({
    super.connectivity,
    required this.source,
  });
}
