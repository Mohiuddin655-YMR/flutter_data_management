import 'package:data_management/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApiDataTest extends StatefulWidget {
  const ApiDataTest({Key? key}) : super(key: key);

  @override
  State<ApiDataTest> createState() => _ApiDataTestState();
}

class _ApiDataTestState extends State<ApiDataTest> {
  late PostController controller = context.read<PostController>();

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
                  onPressed: () => controller.isAvailable("1"),
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
                    controller.update(
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
            BlocConsumer<PostController, Response<Post>>(
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
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                  ));
                } else if (state.isMessage) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                  ));
                } else if (state.isException) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.exception),
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
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.all(24),
            //   alignment: Alignment.center,
            //   color: Colors.grey.withAlpha(50),
            //   margin: const EdgeInsets.symmetric(vertical: 24),
            //   child: StreamBuilder(
            //       stream: controller.live("1"),
            //       builder: (context, snapshot) {
            //         var value = snapshot.data ?? Response();
            //         return Text(
            //           value.data.toString(),
            //           textAlign: TextAlign.center,
            //         );
            //       }),
            // ),
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.all(24),
            //   alignment: Alignment.center,
            //   color: Colors.grey.withAlpha(50),
            //   margin: const EdgeInsets.symmetric(vertical: 24),
            //   child: StreamBuilder(
            //     stream: controller.lives(),
            //     builder: (context, snapshot) {
            //       var value = snapshot.data ?? Response();
            //       return Text(
            //         value.result.toString(),
            //         textAlign: TextAlign.center,
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

/// Step-5
/// Create a data controller for access all place
class PostController extends RemoteDataController<Post> {
  PostController({
    required super.handler,
  });
}

/// Step-4
/// When you complete the repository to use User model for locally or remotely
class PostHandler extends RemoteDataHandlerImpl<Post> {
  PostHandler({
    required super.repository,
  });
}

/// Step-3
/// When you use to auto detected to use remote or local data
class PostRepository extends RemoteDataRepositoryImpl<Post> {
  PostRepository({
    super.local,
    super.isCacheMode = true,
    required super.remote,
  });
}

/// Step - 2
/// When you use remote database (ex. Firebase Firestore, Firebase Realtime, Api, Encrypted Api data)
/// Use for remote data => insert, update, delete, get, gets, live, lives, clear
class RemotePostDataSource extends ApiDataSourceImpl<Post> {
  RemotePostDataSource({
    super.path = "posts",
    //super.encryptor = const Encryptor(),
    super.api = const Api(
      api: "https://jsonplaceholder.typicode.com",
      status: ApiStatus(ok: 200),
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
    required super.preferences,
    super.path = "products",
  });

  @override
  Post build(source) {
    return Post.from(source);
  }
}

/// Step - 1
/// Use for local or remote data model
class Post extends Entity {
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
      id: source.entityId,
      // Entity.autoId(source);
      timeMills: source.entityTimeMills,
      // Entity.autoTimeMills(source);
      userId: source.entityValue("userId"),
      // Entity.value<Type>(key, source)
      title: Entity.value<String>("title", source),
      body: Entity.value<String>("body", source),
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
    return super.source.attach({
      "id": idInt,
      "userId": idInt,
      "title": title ?? "Title",
      "body": body,
    });
  }
}
