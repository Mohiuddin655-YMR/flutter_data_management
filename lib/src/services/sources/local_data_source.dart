part of 'sources.dart';

/// # Won't Use Directly
/// You can use:
/// * <b>[LocalDataSourceImpl]</b> : Use for local or save instance related data.
///
abstract class LocalDataSource<T extends Entity> extends DataSource<T> {
  final String path;

  LocalDataSource({
    required this.path,
    LocalDatabase? database,
  }) : _proxy = database;

  LocalDatabase? _proxy;

  Future<LocalDatabase> get database async =>
      _proxy ??= await LocalDatabaseImpl.I;
}
