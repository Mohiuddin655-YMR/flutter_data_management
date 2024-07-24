import 'package:flutter_entity/flutter_entity.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../core/configs.dart';
import '../../utils/encryptor.dart';
import 'base.dart';

/// ## Abstract class representing a data source for handling operations related to entities of type [T].
///
/// ### A data source for handling Local database operations.
///
/// Example:
/// ```dart
/// class LocalUserDataSource extends LocalDataSourceImpl<User> {
///   // Implement local data source operations for User entities.
/// }
/// ```
///
/// ## Abstract class representing a generic data repository with methods for CRUD operations.
///
/// This abstract class defines the structure of a generic data repository.
/// It is not intended to be used directly. Instead, use its implementations:
/// * <b>[LocalDataSourceImpl]</b> : Use for local or save instance related data.
///
/// Example:
/// ```dart
/// final LocalDataSource<User> localUserDataSource = LocalUserDataSource<User>();
/// ```
///
abstract class LocalDataSource<T extends Entity> extends DataSource<T> {
  final Duration reloadDuration;
  final String path;
  final Encryptor? encryptor;
  final InAppDatabase database;

  bool get isEncryptor => encryptor.isValid;

  const LocalDataSource({
    required this.path,
    this.reloadDuration = const Duration(seconds: 2),
    this.encryptor,
    required this.database,
  });

  Future<Response<T>> keep(
    List<T> data, {
    FieldParams? params,
  });
}
