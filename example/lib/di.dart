import 'package:data_management/core.dart';
import 'package:get_it/get_it.dart';

import 'api_data_test.dart';
import 'firebase_firestore_data_test.dart';
import 'firebase_realtime_data_test.dart';
import 'local_data_test.dart';

GetIt locator = GetIt.instance;

Future<void> diInit() async {
  /// for Local database
  locator.registerFactory<LocalDataController<Cart>>(() {
    return LocalDataController<Cart>.fromSource(
      source: CartDataSource(),
    );
  });

  /// for Firebase FireStore
  locator.registerFactory<RemoteDataController<Product>>(() {
    return RemoteDataController<Product>.fromSource(
      source: RemoteProductDataSource(),

      /// (Optional) if you need to backup your data when network unavailable
      backup: LocalProductDataSource(),
    );
  });

  ///for Firebase Realtime
  locator.registerFactory<RemoteDataController<User>>(() {
    return RemoteDataController<User>.fromSource(
      source: RemoteUserDataSource(),

      /// (Optional) if you need to backup your data when network unavailable
      backup: LocalUserDataSource(),
    );
  });

  /// for Api database
  locator.registerFactory<RemoteDataController<Post>>(() {
    return RemoteDataController<Post>.fromSource(
      source: RemotePostDataSource(),

      /// (Optional) if you need to backup your data when network unavailable
      backup: LocalPostDataSource(),
    );
  });
  await locator.allReady();
}
