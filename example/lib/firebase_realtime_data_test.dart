import 'package:data_management/core.dart';
import 'package:flutter/material.dart';

class FirebaseRealtimeDataTest extends StatefulWidget {
  const FirebaseRealtimeDataTest({Key? key}) : super(key: key);

  @override
  State<FirebaseRealtimeDataTest> createState() =>
      _FirebaseRealtimeDataTestState();
}

class _FirebaseRealtimeDataTestState extends State<FirebaseRealtimeDataTest> {
  late DataController<User> controller = DataController.of(context);

  @override
  Widget build(BuildContext context) {
    var p1 = User(
      id: "1",
      timeMills: Data.generateTimeMills,
      name: "Mr. X",
    );
    var p2 = User(
      id: "2",
      timeMills: Data.generateTimeMills,
      name: "Mr. Y",
    );
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Wrap(
              runSpacing: 12,
              spacing: 12,
              runAlignment: WrapAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text("Availability"),
                  onPressed: () => controller.isAvailable("1"),
                ),
                ElevatedButton(
                  child: const Text("Insert"),
                  onPressed: () => controller.create(p1),
                ),
                ElevatedButton(
                  child: const Text("Inserts"),
                  onPressed: () => controller.creates([p1, p2]),
                ),
                ElevatedButton(
                  child: const Text("Update"),
                  onPressed: () {
                    controller.update(
                      id: p1.id,
                      data: p1.copyWith(name: "Mr. X (Updated)").source,
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () => controller.delete("1"),
                  child: const Text("Delete"),
                ),
                ElevatedButton(
                  onPressed: () => controller.clear(),
                  child: const Text("Clear"),
                ),
                ElevatedButton(
                  onPressed: () => controller.get("1"),
                  child: const Text("Get"),
                ),
                ElevatedButton(
                  onPressed: () => controller.gets(),
                  child: const Text("Gets"),
                ),
              ],
            ),
            DataBuilder<User>(
              builder: (context, state) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.center,
                  color: Colors.grey.withAlpha(50),
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    state.toString(),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              color: Colors.grey.withAlpha(50),
              margin: const EdgeInsets.symmetric(vertical: 24),
              child: StreamBuilder(
                  stream: controller.live("1"),
                  builder: (context, snapshot) {
                    var value = snapshot.data ?? DataResponse();
                    return Text(
                      value.data.toString(),
                      textAlign: TextAlign.center,
                    );
                  }),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              color: Colors.grey.withAlpha(50),
              margin: const EdgeInsets.symmetric(vertical: 24),
              child: StreamBuilder(
                stream: controller.lives(),
                builder: (context, snapshot) {
                  var value = snapshot.data ?? DataResponse();
                  return Text(
                    value.result.toString(),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Step - 2
/// When you use remote database (ex. Firebase Firestore, Firebase Realtime, Api, Encrypted Api data)
/// Use for remote data => insert, update, delete, get, gets, live, lives, clear
class RemoteUserDataSource extends RealtimeDataSource<User> {
  RemoteUserDataSource({
    super.path = "users",
    super.encryptor = const DataEncryptor(),
  });

  @override
  User build(source) {
    return User.from(source);
  }
}

/// Step - 2
/// When you use local database (ex. SharedPreference)
/// Use for local data => insert, update, delete, get, gets, live, lives, clear
class LocalUserDataSource extends LocalDataSourceImpl<User> {
  LocalUserDataSource({
    super.database,
    super.path = "users",
  });

  @override
  User build(source) {
    return User.from(source);
  }
}

/// Step - 1
/// Use for local or remote data model
class User extends Data {
  final String? name;

  User({
    super.id,
    super.timeMills,
    this.name,
  });

  factory User.from(dynamic source) {
    return User(
      id: Data.value<String>("id", source),
      timeMills: Data.value<int>("time_mills", source),
      name: Data.value<String>("name", source),
    );
  }

  User copyWith({
    String? id,
    int? timeMills,
    String? name,
  }) {
    return User(
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, dynamic> get source {
    return super.source.attach({
      "name": name ?? "Name",
    });
  }
}
