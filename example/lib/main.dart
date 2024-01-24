import 'package:data_management/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'api_data_test.dart';
import 'di.dart';
import 'firebase_firestore_data_test.dart';
import 'firebase_realtime_data_test.dart';
import 'local_data_test.dart';

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

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 4, vsync: this);

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
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Text("Api"),
                      Text("Firestore"),
                      Text("Realtime"),
                      Text("Local"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        ApiDataTest(),
                        FirebaseFireStoreDataTest(),
                        FirebaseRealtimeDataTest(),
                        LocalDataTest(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
