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
