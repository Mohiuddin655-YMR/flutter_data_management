part of 'sources.dart';

abstract class LocalDataSource<T extends Entity> extends DataSource<T> {
  final String path;

  LocalDataSource({
    required this.path,
    SharedPreferences? preferences,
  }) : _db = preferences;

  SharedPreferences? _db;

  Future<SharedPreferences> get database async =>
      _db ??= await SharedPreferences.getInstance();
}
