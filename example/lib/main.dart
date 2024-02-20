import 'package:data_management/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'api_data_test.dart';
import 'firebase_firestore_data_test.dart';
import 'firebase_realtime_data_test.dart';
import 'local_data_test.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    DataControllers(
      controllers: [
        DataController<Cart>.fromLocalSource(
          source: CartDataSource(),
        ),
        DataController<Product>.fromRemoteSource(
          source: RemoteProductDataSource(),
          // (Optional) if you need to backup your data when network unavailable
          backup: LocalProductDataSource(),
        ),
        DataController<Post>.fromRemoteSource(
          source: RemotePostDataSource(),
          // (Optional) if you need to backup your data when network unavailable
          backup: LocalPostDataSource(),
        ),
        DataController<User>.fromRemoteSource(
          source: RemoteUserDataSource(),
          // (Optional) if you need to backup your data when network unavailable
          backup: LocalUserDataSource(),
        ),
      ],
      child: const Application(),
    ),
  );
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 4, vsync: this);

  final tabs = [
    "Api",
    "Firestore",
    "Realtime",
    "Local",
  ];

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
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: tabs.map((e) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(e),
                    );
                  }).toList(),
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
    );
  }
}
