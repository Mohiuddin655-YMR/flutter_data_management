import 'package:flutter_andomie/core.dart';

import '../repositories/local_data_repository.dart';
import 'data_handler.dart';

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
