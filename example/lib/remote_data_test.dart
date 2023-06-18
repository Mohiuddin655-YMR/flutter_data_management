import 'package:data_management/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemoteDataTest extends StatefulWidget {
  const RemoteDataTest({Key? key}) : super(key: key);

  @override
  State<RemoteDataTest> createState() => _RemoteDataTestState();
}

class _RemoteDataTestState extends State<RemoteDataTest> {
  late ProductController controller = context.read<ProductController>();

  @override
  Widget build(BuildContext context) {
    var p1 = Product(
      id: "1",
      timeMills: Entity.ms,
      name: "Oppo F17 Pro",
      price: 23500,
    );
    var p2 = Product(
      id: "2",
      timeMills: Entity.ms,
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
                      data: p1.copyWith(price: 20500).source,
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
            BlocConsumer<ProductController, Response<Product>>(
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
class ProductController extends RemoteDataController<Product> {
  ProductController({
    required super.handler,
  });
}

/// Step-4
/// When you complete the repository to use User model for locally or remotely
class ProductHandler extends RemoteDataHandlerImpl<Product> {
  ProductHandler({
    required super.repository,
  });
}

/// Step-3
/// When you use to auto detected to use remote or local data
class ProductRepository extends RemoteDataRepositoryImpl<Product> {
  ProductRepository({
    super.local,
    super.isCacheMode = true,
    required super.remote,
  });
}

/// Step - 2
/// When you use remote database (ex. Firebase Firestore, Firebase Realtime, Api, Encrypted Api data)
/// Use for remote data => insert, update, delete, get, gets, live, lives, clear
class RemoteProductDataSource extends RealtimeDataSourceImpl<Product> {
  RemoteProductDataSource({
    super.path = "products",
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
    required super.preferences,
    super.path = "products",
  });

  @override
  Product build(source) {
    return Product.from(source);
  }
}

/// Step - 1
/// Use for local or remote data model
class Product extends Entity {
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
      id: Entity.value<String>("id", source),
      timeMills: Entity.value<int>("time_mills", source),
      name: Entity.value<String>("name", source),
      price: Entity.value<double>("price", source),
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
    return super.source.attach({
      "name": name ?? "Name",
      "price": price,
    });
  }

  static List<Product> get carts {
    return List.generate(5, (index) {
      return Product(
        id: "ID${index + 1}",
        timeMills: Entity.ms,
        name: "Product - ${index + 1}",
        price: 45 + (index * 5),
      );
    });
  }
}
