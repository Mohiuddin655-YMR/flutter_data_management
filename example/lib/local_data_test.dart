import 'package:data_management/core.dart';
import 'package:example/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalDataTest extends StatefulWidget {
  const LocalDataTest({Key? key}) : super(key: key);

  @override
  State<LocalDataTest> createState() => _LocalDataTestState();
}

class _LocalDataTestState extends State<LocalDataTest> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<CartController>(),
      child: BlocBuilder<CartController, Response<Cart>>(
        builder: (context, state) {
          CartController controller = context.read<CartController>();
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
                            Cart(
                              id: "1",
                              price: 29860,
                              quantity: 3,
                              name: "Oppo F17 Pro",
                            ),
                          );
                        },
                        child: const Text("Insert"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.inserts(
                            [
                              Cart(
                                id: "2",
                                price: 35,
                                quantity: 1,
                              ),
                              Cart(
                                id: "3",
                                price: 50,
                                quantity: 2,
                              ),
                            ],
                          );
                        },
                        child: const Text("Inserts"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.inserts(
                            [
                              Cart(
                                id: "2",
                                price: 35,
                                quantity: 1,
                              ),
                              Cart(
                                id: "4",
                                price: 50,
                                quantity: 2,
                              ),
                            ],
                          );
                        },
                        child: const Text("Inserts with Duplicate"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.update(
                            Cart(
                              id: "1",
                              price: 24897,
                              quantity: 1,
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
                        var value = snapshot.data ?? Response<Cart>();
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
      ),
    );
  }
}

/// Step-5
/// Create a data controller for access all place
class CartController extends LocalDataController<Cart> {
  CartController({
    required super.handler,
  });
}

/// Step-4
/// When you complete the repository to use User model for locally or remotely
class CartHandler extends LocalDataHandlerImpl<Cart> {
  CartHandler({
    required super.repository,
  });
}

/// Step-3
/// When you use to auto detected to use remote or local data
class CartRepository extends LocalDataRepositoryImpl<Cart> {
  CartRepository({
    required super.local,
  });
}

/// Step - 2
/// When you use local database (ex. SharedPreference)
/// Use for local data => insert, update, delete, get, gets, live, lives, clear
class CartDataSource extends LocalDataSourceImpl<Cart> {
  CartDataSource({
    super.preferences,
    super.path = "carts",
  });

  @override
  Cart build(source) {
    return Cart.from(source);
  }
}

/// Step - 1
/// Use for local or remote data model
class Cart extends Entity {
  final String? name;
  final double? price;
  final int? quantity;

  Cart({
    super.id,
    super.timeMills,
    this.name,
    this.price,
    this.quantity,
  });

  factory Cart.from(dynamic source) {
    return Cart(
      id: Entity.value<String>("id", source),
      timeMills: Entity.value<int>("time_mills", source),
      name: Entity.value<String>("name", source),
      price: Entity.value<double>("price", source),
      quantity: Entity.value<int>("quantity", source),
    );
  }

  @override
  Map<String, dynamic> get source {
    return super.source.attach({
      "name": name ?? "Name",
      "price": price,
      "quantity": quantity,
    });
  }
}
