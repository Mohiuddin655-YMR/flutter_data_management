import 'package:data_management/core.dart';
import 'package:example/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocProvider(
      create: (context) => locator<LocalDataController<Cart>>(),
      child: BlocBuilder<LocalDataController<Cart>, DataResponse<Cart>>(
        builder: (context, state) {
          LocalDataController<Cart> controller = context.read();
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
                        onPressed: () => controller.create(c1),
                      ),
                      ElevatedButton(
                        child: const Text("Inserts"),
                        onPressed: () => controller.creates([c1, c2]),
                      ),
                      ElevatedButton(
                        child: const Text("Update"),
                        onPressed: () => controller.update(
                          id: c1.id,
                          data: c1.copyWith(quantity: 1).source,
                        ),
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
      ),
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
    return super.source.generate({
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
