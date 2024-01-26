import 'package:flutter_andomie/core.dart';

import '../../data/repositories/local_data_repository.dart';
import '../../data/repositories/remote_data_repository.dart';
import '../repositories/data_repository.dart';
import '../sources/local_data_source.dart';
import '../sources/remote_data_source.dart';

class BaseDataUseCase<T extends Entity> {
  final DataRepository<T> repository;

  const BaseDataUseCase(this.repository);

  factory BaseDataUseCase.fromLocalSource({
    required LocalDataSource<T> source,
  }) {
    return BaseDataUseCase(LocalDataRepositoryImpl<T>(source: source));
  }

  factory BaseDataUseCase.fromRemoteSource({
    required RemoteDataSource<T> source,
    ConnectivityProvider? connectivity,
    LocalDataSource<T>? backup,
    bool isCacheMode = false,
  }) {
    return BaseDataUseCase(RemoteDataRepositoryImpl<T>(
      source: source,
      backup: backup,
      connectivity: connectivity,
      isCacheMode: isCacheMode,
    ));
  }
}
