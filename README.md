# data_management
Collection of service with advanced style and controlling system.

#### Use cases
```dart
// Example: Check data by ID
final checkResponse = userRepository.checkById('userId123');
// Output: DataResponse<User> ...

// Example: Clear data
final clearResponse = userRepository.clear();
// Output: DataResponse<User> ...

// Example: Create data
final newUser = User(name: 'John', age: 25);
final createResponse = userRepository.create(newUser);
// Output: DataResponse<User> ...

// Example: Create multiple data entries
final newUserList = [User(name: 'John', age: 25), User(name: 'Alice', age: 30)];
final createsResponse = userRepository.creates(newUserList);
// Output: DataResponse<User> ...

// Example: Delete data by ID
final deleteResponse = userRepository.deleteById('userId123');
// Output: DataResponse<User> ...

// Example: Delete data by multiple IDs
final deleteIdsResponse = userRepository.deleteByIds(['userId1', 'userId2']);
// Output: DataResponse<User> ...

// Example: Get all data
final getResponse = userRepository.get();
// Output: DataResponse<User> ...

// Example: Get data by ID
final getByIdResponse = userRepository.getById('userId123');
// Output: DataResponse<User> ...

// Example: Get data by multiple IDs
final getByIdsResponse = userRepository.getByIds(['userId1', 'userId2']);
// Output: DataResponse<User> ...

// Example: Get data by query
final query = Query.field('name', 'John');
final getByQueryResponse = userRepository.getByQuery(queries: [query]);
// Output: DataResponse<User> ...

// Example: Listen for data changes
final listenResponse = userRepository.listen();
// Output: Stream<DataResponse<User>> ...

// Example: Listen for data changes by ID
final listenByIdResponse = userRepository.listenById('userId123');
// Output: Stream<DataResponse<User>> ...

// Example: Listen for data changes by multiple IDs
final listenByIdsResponse = userRepository.listenByIds(['userId1', 'userId2']);
// Output: Stream<DataResponse<User>> ...

// Example: Listen for data changes by query
final listenByQueryResponse = userRepository.listenByQuery(queries: [query]);
// Output: Stream<DataResponse<User>> ...

// Example: Check data by query
final checker = Checker(field: 'status', value: 'active');
final searchResponse = userRepository.search(checker);
// Output: DataResponse<User> ...

// Example: Update data by ID
final updateData = {'status': 'inactive'};
final updateByIdResponse = userRepository.updateById('userId123', updateData);
// Output: DataResponse<User> ...

// Example: Update data by multiple IDs
final updates = [
  UpdatingInfo('userId1', {'status': 'inactive'}),
  UpdatingInfo('userId2', {'status': 'active'}),
];
final updateByIdsResponse = userRepository.updateByIds(updates);
// Output: DataResponse<User> ...
```

#### Api data example:
```dart
import 'package:data_management/core.dart';
import 'package:flutter/material.dart';

class ApiDataTest extends StatefulWidget {
  const ApiDataTest({Key? key}) : super(key: key);

  @override
  State<ApiDataTest> createState() => _ApiDataTestState();
}

class _ApiDataTestState extends State<ApiDataTest> {
  late DataController<Post> controller = DataController.of(context);

  @override
  Widget build(BuildContext context) {
    var p1 = Post(
      id: "1",
      title: "This is a title 1",
      body: "This is a body 1",
    );
    var p2 = Post(
      id: "2000",
      userId: 1,
      title: "This is a title 2",
      body: "This is a body 2",
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
                  onPressed: () => controller.checkById("1"),
                ),
                ElevatedButton(
                  child: const Text("Insert"),
                  onPressed: () => controller.create(p2),
                ),
                ElevatedButton(
                  child: const Text("Inserts"),
                  onPressed: () => controller.creates([p1, p2]),
                ),
                ElevatedButton(
                  child: const Text("Update"),
                  onPressed: () {
                    controller.updateById(
                      id: "1",
                      data: p1
                          .copyWith(
                            title: "Title updated!",
                            body: "Body updated!",
                          )
                          .source,
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () => controller.deleteById("1"),
                  child: const Text("Delete"),
                ),
                ElevatedButton(
                  onPressed: () => controller.clear(),
                  child: const Text("Clear"),
                ),
                ElevatedButton(
                  onPressed: () => controller.getById("1"),
                  child: const Text("Get"),
                ),
                ElevatedButton(
                  onPressed: () => controller.get(),
                  child: const Text("Gets"),
                ),
              ],
            ),
            DataBuilder<Post>(
              builder: (context, response) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.center,
                  color: Colors.grey.withAlpha(50),
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    response.toString(),
                    textAlign: TextAlign.center,
                  ),
                );
              },
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
class RemotePostDataSource extends ApiDataSource<Post> {
  RemotePostDataSource({
    super.path = "posts",
    //super.encryptor = const Encryptor(),
    super.api = const Api(
      baseUrl: "https://jsonplaceholder.typicode.com",
      status: ApiStatus(ok: 200),
      timer: ApiTimer(streamReloadTime: 500),
      autoGenerateId: true,
    ),
  });

  @override
  Post build(source) {
    return Post.from(source);
  }
}

/// Step - 2
/// When you use local database (ex. SharedPreference)
/// Use for local data => insert, update, delete, get, gets, live, lives, clear
class LocalPostDataSource extends LocalDataSourceImpl<Post> {
  LocalPostDataSource({
    super.database,
    super.path = "products",
  });

  @override
  Post build(source) {
    return Post.from(source);
  }
}

/// Step - 1
/// Use for local or remote data model
class Post extends Data {
  final int? userId;
  final String? title;
  final String? body;

  Post({
    super.id,
    super.timeMills,
    this.userId,
    this.title,
    this.body,
  });

  factory Post.from(Object? source) {
    return Post(
      id: Data.autoId(source),
      timeMills: Data.autoTimeMills(source),
      userId: Data.value<int>("userId", source),
      title: Data.value<String>("title", source),
      body: Data.value<String>("body", source),
    );
  }

  Post copyWith({
    String? id,
    int? userId,
    String? title,
    String? body,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  @override
  Map<String, dynamic> get source {
    return super.source
      ..addAll({
        "id": idInt,
        "userId": idInt,
        "title": title ?? "Title",
        "body": body,
      });
  }
}
```

#### Firebase firestore example
```dart
import 'package:data_management/core.dart';
import 'package:flutter/material.dart';

class FirebaseFireStoreDataTest extends StatefulWidget {
  const FirebaseFireStoreDataTest({Key? key}) : super(key: key);

  @override
  State<FirebaseFireStoreDataTest> createState() =>
      _FirebaseFireStoreDataTestState();
}

class _FirebaseFireStoreDataTestState extends State<FirebaseFireStoreDataTest> {
  late DataController<Product> controller = DataController.of(context);

  @override
  Widget build(BuildContext context) {
    var p1 = Product(
      id: "1",
      timeMills: Data.generateTimeMills,
      name: "Oppo F17 Pro",
      price: 23500,
    );
    var p2 = Product(
      id: "2",
      timeMills: Data.generateTimeMills,
      name: "Oppo A5s",
      price: 14000,
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
                  onPressed: () => controller.checkById("1"),
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
                    controller.updateById(
                      id: p1.id,
                      data: p1
                          .copyWith(
                            price: 20500,
                            name: "Oppo F17 Pro (Updated)",
                          )
                          .source,
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () => controller.deleteById("1"),
                  child: const Text("Delete"),
                ),
                ElevatedButton(
                  onPressed: () => controller.clear(),
                  child: const Text("Clear"),
                ),
                ElevatedButton(
                  onPressed: () => controller.getById("1"),
                  child: const Text("Get"),
                ),
                ElevatedButton(
                  onPressed: () => controller.get(),
                  child: const Text("Gets"),
                ),
              ],
            ),
            DataBuilder<Product>(
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
                  stream: controller.listenById("1"),
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
                stream: controller.listen(),
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
class RemoteProductDataSource extends FirestoreDataSource<Product> {
  RemoteProductDataSource({
    super.path = "products",
    super.encryptor = const DataEncryptor(),
  });

  @override
  Product build(source) {
    return Product.from(source);
  }
}

/// Step - 2
/// When you use local database (ex. SharedPreference)
/// Use for local data => insert, update, delete, get, gets, live, lives, clear
class LocalProductDataSource extends LocalDataSourceImpl<Product> {
  LocalProductDataSource({
    super.database,
    super.path = "products",
  });

  @override
  Product build(source) {
    return Product.from(source);
  }
}

/// Step - 1
/// Use for local or remote data model
class Product extends Data {
  final String? name;
  final double? price;

  Product({
    super.id,
    super.timeMills,
    this.name,
    this.price,
  });

  factory Product.from(dynamic source) {
    return Product(
      id: Data.value<String>("id", source),
      timeMills: Data.value<int>("time_mills", source),
      name: Data.value<String>("name", source),
      price: Data.value<double>("price", source),
    );
  }

  Product copyWith({
    String? id,
    int? timeMills,
    String? name,
    double? price,
  }) {
    return Product(
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  @override
  Map<String, dynamic> get source {
    return super.source
      ..addAll({
        "name": name ?? "Name",
        "price": price,
      });
  }
}
```

#### Firebase realtime example
```dart
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
                  onPressed: () => controller.checkById("1"),
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
                    controller.updateById(
                      id: p1.id,
                      data: p1.copyWith(name: "Mr. X (Updated)").source,
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () => controller.deleteById("1"),
                  child: const Text("Delete"),
                ),
                ElevatedButton(
                  onPressed: () => controller.clear(),
                  child: const Text("Clear"),
                ),
                ElevatedButton(
                  onPressed: () => controller.getById("1"),
                  child: const Text("Get"),
                ),
                ElevatedButton(
                  onPressed: () => controller.get(),
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
                  stream: controller.listenById("1"),
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
                stream: controller.listen(),
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
    return super.source
      ..addAll({
        "name": name ?? "Name",
      });
  }
}
```

#### Local data examples:
```dart
import 'package:data_management/core.dart';
import 'package:flutter/material.dart';

import 'firebase_firestore_data_test.dart';

class LocalDataTest extends StatefulWidget {
  const LocalDataTest({Key? key}) : super(key: key);

  @override
  State<LocalDataTest> createState() => _LocalDataTestState();
}

class _LocalDataTestState extends State<LocalDataTest> {
  late Product p1 = Product(
    id: "1",
    timeMills: Data.generateTimeMills,
    name: "Oppo F17 Pro",
    price: 23500,
  );
  late Product p2 = Product(
    id: "2",
    timeMills: Data.generateTimeMills,
    name: "Oppo A5s",
    price: 14000,
  );
  late Cart c1 = Cart(
    id: "1",
    timeMills: Data.generateTimeMills,
    quantity: 3,
    product: p1,
  );
  late Cart c2 = Cart(
    id: "2",
    timeMills: Data.generateTimeMills,
    quantity: 2,
    product: p2,
  );

  @override
  Widget build(BuildContext context) {
    final controller = DataController<Cart>.of(context);
    return DataBuilder<Cart>(
      builder: (context, state) {
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
                      onPressed: () => controller.checkById("1"),
                    ),
                    ElevatedButton(
                      child: const Text("Insert"),
                      onPressed: () => controller.create(c1),
                    ),
                    ElevatedButton(
                      child: const Text("Inserts"),
                      onPressed: () => controller.creates([c1, c2]),
                    ),
                    ElevatedButton(
                      child: const Text("Update"),
                      onPressed: () => controller.updateById(
                        id: c1.id,
                        data: c1.copyWith(quantity: 1).source,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.deleteById("1");
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
                        controller.getById("1");
                      },
                      child: const Text("Get"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.get();
                      },
                      child: const Text("Gets"),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.center,
                  color: Colors.grey.withAlpha(50),
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    state.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.center,
                  color: Colors.grey.withAlpha(50),
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  child: StreamBuilder(
                      stream: controller.listenById("1"),
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
                    stream: controller.listen(),
                    builder: (context, snapshot) {
                      var value = snapshot.data ?? DataResponse<Cart>();
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
      },
    );
  }
}

/// Step - 2
/// When you use local database (ex. SharedPreference)
/// Use for local data => insert, update, delete, get, gets, live, lives, clear
class CartDataSource extends LocalDataSourceImpl<Cart> {
  CartDataSource({
    super.database,
    super.path = "carts",
  });

  @override
  Cart build(source) {
    return Cart.from(source);
  }
}

/// Step - 1
/// Use for local or remote data model
class Cart extends Data {
  final int? quantity;
  final Product? product;

  Cart({
    super.id,
    super.timeMills,
    this.quantity,
    this.product,
  });

  factory Cart.from(dynamic source) {
    return Cart(
      id: Data.value<String>("id", source),
      timeMills: Data.value<int>("time_mills", source),
      quantity: Data.value<int>("quantity", source),
      product: Data.object("product", source, (value) => Product.from(value)),
    );
  }

  @override
  Map<String, dynamic> get source {
    return super.source
      ..addAll({
        "quantity": quantity,
        "product": product?.source,
      });
  }

  Cart copyWith({
    String? id,
    int? timeMills,
    int? quantity,
    Product? product,
  }) {
    return Cart(
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
    );
  }
}
```

#### Bloc provider example:
```dart
import 'package:data_management/core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          /// Step - 3
          /// Create a data management controller with bloc
          child: DataControllers(
            controllers: [
              /// Create data controller by data source
              RemoteDataController<Post>(RemoteDataRepositoryImpl(
                source: PostDataSource(),

                /// (Optional) if you need to backup your data when network unavailable
                backup: PostBackupSource(),
              )),
            ],
            child: const ApiDataTest(),
          ),
        ),
      ),
    );
  }
}

/// Step - 5
/// Use data management logic with data management remote data controller
class ApiDataTest extends StatefulWidget {
  const ApiDataTest({Key? key}) : super(key: key);

  @override
  State<ApiDataTest> createState() => _ApiDataTestState();
}

class _ApiDataTestState extends State<ApiDataTest> {
  late DataController<Post> controller = DataController.of(context);

  @override
  Widget build(BuildContext context) {
    var p1 = Post(
      id: "1",
      title: "This is a title 1",
      body: "This is a body 1",
    );
    var p2 = Post(
      id: "2000",
      userId: 1,
      title: "This is a title 2",
      body: "This is a body 2",
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
                  onPressed: () => controller.checkById("1"),
                ),
                ElevatedButton(
                  child: const Text("Insert"),
                  onPressed: () => controller.create(p2),
                ),
                ElevatedButton(
                  child: const Text("Inserts"),
                  onPressed: () => controller.creates([p1, p2]),
                ),
                ElevatedButton(
                  child: const Text("Update"),
                  onPressed: () {
                    controller.updateById(
                      id: "1",
                      data: p1
                          .copyWith(
                            title: "Title updated!",
                            body: "Body updated!",
                          )
                          .source,
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () => controller.deleteById("1"),
                  child: const Text("Delete"),
                ),
                ElevatedButton(
                  onPressed: () => controller.clear(),
                  child: const Text("Clear"),
                ),
                ElevatedButton(
                  onPressed: () => controller.getById("1"),
                  child: const Text("Get"),
                ),
                ElevatedButton(
                  onPressed: () => controller.get(),
                  child: const Text("Gets"),
                ),
              ],
            ),
            DataBuilder<Post>(
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
                  stream: controller.listenById("1"),
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
                stream: controller.listen(),
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

/// Step - 3 (Optional)
/// If you need to use any custom data managing system then you can create the custom repository
/// or use directly "RemoteDataRepositoryImpl<Post>"
class PostRepository extends RemoteDataRepositoryImpl<Post> {
  PostRepository({
    required super.source,
  });

  /// OPTIONAL FUNCTION
  Future<DataResponse<Post>> fetchInnerData() async {
    /// Build custom path with builder function
    FieldParams params = const Params({
      "post_id": "1234",
    });

    if (isCacheMode && isLocal) {
      return backup!.get(params: params);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.get(params: params);
      } else {
        return source.get(
          isConnected: connected,
          params: params,
        );
      }
    }
  }
}

/// Step - 2
/// When you use remote database (ex. Firebase Firestore, Firebase Realtime, Api, or Encrypted Api data)
/// Use for remote data => insert, update, delete, get, gets, live, lives, clear
class PostDataSource extends ApiDataSource<Post> {
  PostDataSource({
    super.path = "posts/{post_id}/inner_post",
    super.api = const Api(
      baseUrl: "https://jsonplaceholder.typicode.com",
      status: ApiStatus(ok: 200),
      timer: ApiTimer(streamReloadTime: 500),
      autoGenerateId: true,
    ),
  }) : super(

        /// If you want to your data secure then setup encryptor mode for encryption layer
        /// This is only use for encrypted api data

        // encryptor: Encryptor(
        //   key: "APPLICATION_SECRET_KEY",
        //   passcode: "APPLICATION_SECRET_PASSWORD",
        //   iv: "APPLICATION_SECRET_IV_NUMBER",
        //   request: (passcode, value) {
        //     /// REQUEST BODY DATA CUSTOMIZATION
        //     return {"data": value};
        //   },
        //   response: (value) {
        //     /// RESPONSE DATA MODIFICATION
        //     return value["data"];
        //   },
        // ),
        );

  @override
  Post build(source) {
    /// Convert response data as Model data
    return Post.from(source);
  }
}

/// Step - 2 (Optional)
/// When you use local database (ex. SharedPreference)
/// Use for local data => insert, update, delete, get, gets, live, lives, clear
class PostBackupSource extends LocalDataSourceImpl<Post> {
  PostBackupSource({
    super.database,
    super.path = "products",
  });

  @override
  Post build(source) {
    return Post.from(source);
  }
}

/// Step - 1
/// Use for local or remote data model
class Post extends Data {
  final int? userId;
  final String? title;
  final String? body;

  Post({
    super.id,
    super.timeMills,
    this.userId,
    this.title,
    this.body,
  });

  factory Post.from(Object? source) {
    return Post(
      id: Data.autoId(source),
      timeMills: Data.autoTimeMills(source),
      userId: Data.value<int>("userId", source),
      title: Data.value<String>("title", source),
      body: Data.value<String>("body", source),
    );
  }

  Post copyWith({
    String? id,
    int? userId,
    String? title,
    String? body,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  @override
  Map<String, dynamic> get source {
    return super.source
      ..addAll({
        "id": idInt,
        "userId": idInt,
        "title": title ?? "Title",
        "body": body,
      });
  }
}
```