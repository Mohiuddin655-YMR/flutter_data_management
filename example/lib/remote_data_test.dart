import 'package:data_management/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemoteDataTest extends StatefulWidget {
  const RemoteDataTest({Key? key}) : super(key: key);

  @override
  State<RemoteDataTest> createState() => _RemoteDataTestState();
}

class _RemoteDataTestState extends State<RemoteDataTest> {
  late UserController controller = context.read<UserController>();

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {
                    controller.insert(
                      User(
                        id: "1",
                        email: "example@gmail.com",
                      ),
                    );
                  },
                  child: const Text("Insert"),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.inserts(
                      [
                        User(
                          id: "2",
                          email: "example2@gmail.com",
                        ),
                        User(
                          id: "3",
                          email: "example3@gmail.com",
                        ),
                      ],
                    );
                  },
                  child: const Text("Inserts"),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.update(
                      User(
                        id: "1",
                        email: "example.updated@gmail.com",
                      ),
                    );
                  },
                  child: const Text("Update"),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.delete("1");
                  },
                  child: const Text("Delete"),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.clear();
                  },
                  child: const Text("Clear"),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.get("1");
                  },
                  child: const Text("Get"),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.gets();
                  },
                  child: const Text("Gets"),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.isAvailable("1");
                  },
                  child: const Text("Available"),
                ),
              ],
            ),
            BlocConsumer<UserController, Response<User>>(
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
              listener: (context, state) {
                if (state.isLoading) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Loading..."),
                  ));
                } else if (state.isError ||
                    state.isFailed ||
                    state.isInternetError ||
                    state.isNullable ||
                    state.isTimeout) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.exception),
                  ));
                } else if (state.isAvailable) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Available"),
                  ));
                } else if (state.isValid) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Valid Data"),
                  ));
                } else if (state.isSuccessful) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Successful"),
                  ));
                } else if (state.isCancel) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Cancel"),
                  ));
                }
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
                    var value = snapshot.data ?? Response();
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
                  var value = snapshot.data ?? Response();
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

/// Step-5
/// Create a data controller for access all place
class UserController extends RemoteDataController<User> {
  UserController({
    required super.handler,
  });
}

/// Step-4
/// When you complete the repository to use User model for locally or remotely
class UserHandler extends RemoteDataHandlerImpl<User> {
  UserHandler({
    required super.repository,
  });
}

/// Step-3
/// When you use to auto detected to use remote or local data
class UserRepository extends RemoteDataRepositoryImpl<User> {
  UserRepository({
    super.local,
    super.isCacheMode = true,
    required super.remote,
  });
}

/// Step - 2
/// When you use remote database (ex. Firebase Firestore, Firebase Realtime, Api, Encrypted Api data)
/// Use for remote data => insert, update, delete, get, gets, live, lives, clear
class RemoteUserDataSource extends RealtimeDataSourceImpl<User> {
  RemoteUserDataSource({
    super.path = "users",
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
    required super.preferences,
    super.path = "users",
  });

  @override
  User build(source) {
    return User.from(source);
  }
}

/// Step - 1
/// Use for local or remote data model
class User extends Entity {
  final String? email;
  final String? name;
  final String? phone;
  final Address? address;

  User({
    super.id,
    super.timeMills,
    this.email,
    this.name,
    this.phone,
    this.address,
  });

  factory User.from(dynamic source) {
    return User(
      id: Entity.value("id", source),
      timeMills: Entity.value("time_mills", source),
      email: Entity.value("email", source),
      name: Entity.value("name", source),
      phone: Entity.value("phone", source),
      address: Entity.object("address", source, (value) {
        return Address.from(value);
      }),
    );
  }

  @override
  Map<String, dynamic> get source {
    return super.source.attach({
      "email": email,
      "name": name,
      "phone": phone,
      "address": address?.source,
    });
  }
}

/// Optional
/// Use for user sub entity
class Address extends Entity {
  final String? city;
  final String? country;
  final int? zipCode;

  Address({
    this.city,
    this.country,
    this.zipCode,
  });

  factory Address.from(dynamic source) {
    return Address(
      city: Entity.value<String>("city", source),
      country: Entity.value<String>('country', source),
      zipCode: Entity.value<int>("zip_code", source),
    );
  }

  @override
  Map<String, dynamic> get source {
    return super.source.attach({
      "city": city,
      "country": country,
      "zip_code": zipCode,
    });
  }
}
