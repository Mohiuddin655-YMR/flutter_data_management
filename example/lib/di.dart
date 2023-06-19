import 'package:data_management/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_data_test.dart';
import 'firebase_firestore_data_test.dart';
import 'firebase_realtime_data_test.dart';
import 'local_data_test.dart';

GetIt locator = GetIt.instance;

Future<void> diInit() async {
  final local = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => local);
  _forLocal();
  _forApi();
  _forFirebaseFireStore();
  _forFirebaseRealtime();
  await locator.allReady();
}

void _forLocal() {
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

void _forApi() {
  locator.registerLazySingleton<LocalDataSource<Post>>(() {
    return LocalPostDataSource(preferences: locator());
  });
  locator.registerLazySingleton<RemoteDataSource<Post>>(() {
    return RemotePostDataSource();
  });

  locator.registerLazySingleton<RemoteDataRepository<Post>>(() {
    return PostRepository(
      remote: locator(),
    );
  });

  locator.registerLazySingleton<RemoteDataHandler<Post>>(() {
    return PostHandler(repository: locator());
  });

  locator.registerFactory<PostController>(() {
    return PostController(
      handler: locator(),
    );
  });
}

void _forFirebaseFireStore() {
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

void _forFirebaseRealtime() {
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
