import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_andomie/core.dart';

import '../../core/typedefs.dart';
import '../../models/updating_info.dart';
import '../../utils/response.dart';
import 'base.dart';

class UpdateByIdDataUseCase<T extends Entity> extends BaseDataUseCase<T> {
  const UpdateByIdDataUseCase(super.repository);

  Future<DataResponse<T>> call<R>(
    List<UpdatingInfo> updates, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.updateByIds(
      updates,
      builder: (source) {
        if (source is Map<String, dynamic>) {
          // For Local database
          return source["sub_collection_id"]["sub_collection_name"];
        } else if (source is CollectionReference) {
          // For Firestore database
          return source
              .doc("sub_collection_id")
              .collection("sub_collection_name");
        } else if (source is DatabaseReference) {
          // For Realtime database
          return source.child("sub_collection_id").child("sub_collection_name");
        } else if (source is String) {
          // For Api endpoint
          return "$source/{sub_collection_id}/sub_collection_name";
        } else {
          // Back to default source from use case
          return null;
        }
      },
    );
  }
}
