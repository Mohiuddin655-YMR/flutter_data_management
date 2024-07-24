import 'package:flutter_entity/flutter_entity.dart';

import '../../data/repositories/local.dart';
import '../sources/local.dart';
import 'base.dart';

/// A repository for handling local data operations, extending the [DataRepository] interface.
/// This repository is designed for use with entities of type [T].
///
/// Example:
/// ```dart
/// LocalDataRepository<User> userRepository = LocalDataRepository.create(
///   source: LocalDataSourceImpl<User>(),
/// );
/// ```
abstract class LocalDataRepository<T extends Entity> extends DataRepository<T> {
  /// The primary local data source responsible for data operations.
  final LocalDataSource<T> source;

  /// Constructor for creating a [LocalDataRepository].
  ///
  /// Parameters:
  /// - [source]: The primary local data source. Ex [LocalDataSourceImpl].
  ///
  /// Example:
  /// ```dart
  /// LocalDataRepository<User> userRepository = LocalDataRepository.create(
  ///   source: LocalDataSourceImpl<User>(),
  /// );
  /// ```
  const LocalDataRepository({
    required this.source,
  });

  /// Factory method to create a [LocalDataRepository] instance.
  ///
  /// Parameters:
  /// - [source]: The primary local data source. Ex: [LocalDataSourceImpl].
  /// - [connectivity]: An optional connectivity provider for checking network connectivity.
  ///
  /// Example:
  /// ```dart
  /// LocalDataRepository<User> userRepository = LocalDataRepository.create(
  ///   source: LocalDataSourceImpl<User>(),
  /// );
  /// ```
  factory LocalDataRepository.create({
    required LocalDataSource<T> source,
  }) {
    return LocalDataRepositoryImpl(
      source: source,
    );
  }
}
