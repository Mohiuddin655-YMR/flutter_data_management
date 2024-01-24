part of 'controllers.dart';

/// ```dart
/// // Step-1: REQUIRE
/// class Product extends Data {
///   final String? name;
///   final double? price;
///   final int? quantity;
///   final int? discount;
///
///   Product({
///     super.id,
///     super.timeMills,
///     this.name,
///     this.price,
///     this.quantity,
///     this.discount,
///   });
///
///   factory Product.from(Object? source) {
///     return Product(
///       id: source.entityValue("id"),
///       timeMills: source.entityValue("time_mills"),
///       name: source.entityValue("name"),
///       price: source.entityValue("price"),
///       quantity: source.entityValue("quantity"),
///       discount: source.entityValue("discount"),
///     );
///   }
///
///   @override
///   Map<String, dynamic> get source {
///     return super.source.attach({
///       "name": name,
///       "price": price,
///       "quantity": quantity,
///       "discount": discount,
///     });
///   }
/// }
///
/// // Step-2: REQUIRE
/// class RemoteProductDataSource extends RealtimeDataSource<Product> {
///   RemoteProductDataSource({
///     required super.path,
///   });
///
///   @override
///   Product build(source) => Product.from(source);
/// }
///
/// // Step-2: OPTIONAL
/// class LocalProductDataSource extends LocalDataSourceImpl<Product> {
///   LocalProductDataSource({
///     required super.path,
///   });
///
///   @override
///   Product build(source) => Product.from(source);
/// }
/// // REQUIRE
/// // When network connected then fetch data remotely
/// RemoteDataSource<Product> remoteDataSource = RemoteProductDataSource(
///   path: "products",
/// );
///
/// // OPTIONAL
/// // When network disconnected then fetch data locally
/// LocalDataSource<Product> localDataSource = LocalProductDataSource(
///   path: "products",
/// );
///
/// // REQUIRE
/// RemoteDataRepository<Product> repository = RemoteDataRepositoryImpl(
///   remote: remoteDataSource,
///   local: localDataSource,
/// );
///
/// // REQUIRE
/// RemoteDataHandler<Product> handler = RemoteDataHandlerImpl(
///   repository: repository,
/// );
///
/// // USER REQUIREMENT TO USE BUT NOT REQUIRE
/// //
/// DataController<Product> controller = RemoteDataController(
///   handler,
/// );
///
/// // HANDLE ALL OPERATION
///
/// /// check product
/// controller.isAvailable("product_id");
///
/// /// create single product
/// controller.create(Product(name: "name-1"));
///
/// /// create multiple products
/// controller.creates([
///   Product(name: "name-1"),
///   Product(name: "name-2"),
/// ]);
///
/// /// update single product
/// controller.update(id: "product_id", data: {"name": "updated_name"});
///
/// /// delete single product
/// controller.delete("product_id");
///
/// /// delete all products
/// controller.clear();
///
/// /// fetch single product
/// controller.get("product_id");
///
/// /// fetch all products
/// controller.gets();
///
/// /// fetch recent updated products
/// controller.getUpdates();
///
/// /// fetch single observable product
/// controller.live('product_id');
///
/// /// fetch all observable products
/// controller.lives();
/// ```

abstract class DataController<T extends Entity> extends Cubit<DataResponse<T>> {
  DataController() : super(DataResponse<T>());

  // Use for check current data
  void isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  });

  // Use for create single data
  void create<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
  });

  // Use for create multiple data
  void creates<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? source,
  });

  // Use for update single data
  void update<R>({
    required String id,
    required Map<String, dynamic> data,
    OnDataSourceBuilder<R>? source,
  });

  void delete<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  });

  void clear<R>({
    OnDataSourceBuilder<R>? source,
  });

  void get<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  });

  void gets<R>({
    OnDataSourceBuilder<R>? source,
  });

  void getUpdates<R>({
    OnDataSourceBuilder<R>? source,
  });

  Stream<Response<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  });

  Stream<Response<T>> lives<R>({
    OnDataSourceBuilder<R>? source,
  });

  void request<R>(
    Future<Response<T>> Function() callback,
  ) async {
    emit(state.copy(loading: true, status: Status.loading));
    try {
      var result = await callback();
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: _.toString(), status: Status.failure));
    }
  }
}
