import 'package:data_management/core.dart';
import 'package:example/di.dart';
import 'package:example/firebase_realtime_data_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_data_test.dart';
import 'firebase_firestore_data_test.dart';
import 'local_data_test.dart';

late SharedPreferences preferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await diInit();
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => locator<LocalDataController<Cart>>(),
                ),
                BlocProvider(
                  create: (context) => locator<RemoteDataController<Post>>(),
                ),
                BlocProvider(
                  create: (context) => locator<RemoteDataController<Product>>(),
                ),
                BlocProvider(
                  create: (context) => locator<RemoteDataController<User>>(),
                ),
              ],
              child: const ApiDataTest(),
            ),
          ),
        ),
      ),
    );
  }
}
