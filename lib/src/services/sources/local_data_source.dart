part of 'sources.dart';

abstract class LocalDataSource<T extends Entity> extends DataSource<T> {
  final String path;

  LocalDataSource({
    required this.path,
    LocalDatabase? preferences,
  }) : _proxy = preferences;

  LocalDatabase? _proxy;

  Future<LocalDatabase> get database async =>
      _proxy ??= await LocalDatabase.instance;
}
