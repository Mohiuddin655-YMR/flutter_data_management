import 'package:data_manager/core.dart';
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
                              quantity: "example@gmail.com",
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
                                quantity: "example2@gmail.com",
                              ),
                              Cart(
                                id: "3",
                                quantity: "example3@gmail.com",
                              ),
                            ],
                          );
                        },
                        child: const Text("Inserts"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.update(
                            Cart(
                              id: "1",
                              quantity: "example.updated@gmail.com",
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
                          controller.isAvailable("5");
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
    this.name,
    this.price,
    this.quantity,
  });

  factory Cart.from(dynamic source) {
    return Cart(
      id: Entity.value("id", source),
      timeMills: Entity.value("time_mills", source),
      quantity: Entity.value("email", source),
      name: Entity.value("name", source),
      price: Entity.value("phone", source),
      address: Entity.object("address", source, (value) {
        return Address.from(value);
      }),
    );
  }

  @override
  Map<String, dynamic> get source {
    return super.source.attach({
      "email": quantity,
      "name": name,
      "phone": price,
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
