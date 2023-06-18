import 'package:data_management/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'remote_data_test.dart';
import 'local_data_test.dart';

GetIt locator = GetIt.instance;

Future<void> diInit() async {
  final local = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => local);
  _carts();
  _products();
  await locator.allReady();
}

void _carts() {
  locator.registerLazySingleton<LocalDataSource<Cart>>(() {
    return CartDataSource();
  });

  locator.registerLazySingleton<LocalDataRepository<Cart>>(() {
    return CartRepository(
      local: locator(),
    );
  });

  locator.registerLazySingleton<LocalDataHandler<Cart>>(() {
    return CartHandler(repository: locator());
  });

  locator.registerFactory<CartController>(() {
    return CartController(
      handler: locator(),
    );
  });
}

void _products() {
  locator.registerLazySingleton<LocalDataSource<User>>(() {
    return LocalUserDataSource(preferences: locator());
  });
  locator.registerLazySingleton<RemoteDataSource<User>>(() {
    return RemoteUserDataSource();
  });

  locator.registerLazySingleton<RemoteDataRepository<User>>(() {
    return UserRepository(
      remote: locator(),
    );
  });

  locator.registerLazySingleton<RemoteDataHandler<User>>(() {
    return UserHandler(repository: locator());
  });

  locator.registerFactory<UserController>(() {
    return UserController(
      handler: locator(),
    );
  });
}
