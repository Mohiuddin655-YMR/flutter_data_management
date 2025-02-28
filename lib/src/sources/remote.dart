import 'package:flutter_entity/entity.dart';

import 'base.dart';

/// ## Abstract class representing a data source for handling operations related to entities of type [T].
///
/// ### A data source for handling api based data operations.
///
/// Example:
/// ```dart
/// class ApiUserDataSource extends ApiDataSource {
///   // Implement api based data source operations for User entities.
/// }
/// ```
///
/// ### A data source for handling Firestore database operations.
///
/// Example:
/// ```dart
/// class FirestoreUserDataSource extends FirestoreDataSource {
///   // Implement Firestore data source operations for User entities.
/// }
/// ```
///
/// ### A data source for handling Realtime database operations.
///
/// Example:
/// ```dart
/// class RealtimeUserDataSource extends RealtimeDataSource {
///   // Implement real-time data source operations for User entities.
/// }
/// ```
///
/// ## Abstract class representing a generic data repository with methods for CRUD operations.
///
/// This abstract class defines the structure of a generic data repository.
/// It is not intended to be used directly. Instead, use its implementations:
/// * <b>[ApiDataSource]</b> : Use for Api related data.
/// * <b>[FireStoreDataSource]</b> : Use for Firebase Cloud firestore related data.
/// * <b>[RealtimeDataSource]</b> : Use for Firebase realtime database related data.
///
/// Example:
/// ```dart
/// final RemoteDataSource remoteUserDataSource = RemoteUserDataSource();
/// final LocalDataSource localUserDataSource = LocalUserDataSource();
/// ```
///
abstract class RemoteDataSource<T extends Entity> extends DataSource<T> {
  const RemoteDataSource({
    super.encryptor,
  });
}
