import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_manager/core.dart';
import 'package:example/data_test.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt locator = GetIt.instance;

Future<void> diInit() async {
  final local = await SharedPreferences.getInstance();
  final database = FirebaseFirestore.instance;
  final realtime = FirebaseDatabase.instance;
  locator.registerLazySingleton<SharedPreferences>(() => local);
  locator.registerLazySingleton<FirebaseFirestore>(() => database);
  locator.registerLazySingleton<FirebaseDatabase>(() => realtime);
  _user();
  await locator.allReady();
}

void _user() {
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
