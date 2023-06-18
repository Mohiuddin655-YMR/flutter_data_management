import 'package:example/di.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_data_test.dart';
import 'remote_data_test.dart';

late SharedPreferences preferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: !kIsWeb
        ? null
        : const FirebaseOptions(
            apiKey: "AIzaSyAnDJmmToo0dPGEeAV9J-7bsghSaiByFjU",
            authDomain: "flutter-ui-kits.firebaseapp.com",
            databaseURL: "https://flutter-ui-kits-default-rtdb.firebaseio.com",
            projectId: "flutter-ui-kits",
            storageBucket: "flutter-ui-kits.appspot.com",
            messagingSenderId: "807732577100",
            appId: "1:807732577100:web:c6e2766be76043102945e9",
            measurementId: "G-SW8PH1RQ0B",
          ),
  );
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
                  create: (context) => locator<ProductController>(),
                ),
                BlocProvider(
                  create: (context) => locator<CartController>(),
                ),
              ],
              child: const RemoteDataTest(),
            ),
          ),
        ),
      ),
    );
  }
}
