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
    return super.source..addAll({
      "id": idInt,
      "userId": idInt,
      "title": title ?? "Title",
      "body": body,
    });
  }
}
