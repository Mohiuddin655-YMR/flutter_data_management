import 'package:flutter_andomie/core.dart';

import '../repositories/data_repository.dart';

class BaseDataUseCase<T extends Entity> {
  final DataRepository<T> repository;

  const BaseDataUseCase(this.repository);
}
