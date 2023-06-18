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
  locator.registerLazySingleton<LocalDataSource<Product>>(() {
    return LocalProductDataSource(preferences: locator());
  });
  locator.registerLazySingleton<RemoteDataSource<Product>>(() {
    return RemoteProductDataSource();
  });

  locator.registerLazySingleton<RemoteDataRepository<Product>>(() {
    return ProductRepository(
      remote: locator(),
    );
  });

  locator.registerLazySingleton<RemoteDataHandler<Product>>(() {
    return ProductHandler(repository: locator());
  });

  locator.registerFactory<ProductController>(() {
    return ProductController(
      handler: locator(),
    );
  });
}
