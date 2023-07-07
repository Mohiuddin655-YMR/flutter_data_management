library sources;

import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_andomie/core.dart';

import '../../../core.dart';

part 'api_data_source.dart';

part 'fire_store_data_source.dart';

part 'local_data_source.dart';

part 'realtime_data_source.dart';

extension _LocalMapExtension on Map<String, dynamic> {
  String? get id => this[EntityKeys.id];

  Map<String, dynamic> withId(String id) => attach({EntityKeys.id: id});
}
