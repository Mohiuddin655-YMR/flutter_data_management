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
