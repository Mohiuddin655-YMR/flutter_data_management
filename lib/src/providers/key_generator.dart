import 'dart:math';
import 'dart:typed_data';

import 'package:data_management/core.dart';

class KeyGenerator {
  final ByteType type;

  KeyGenerator._(this.type);

  static KeyGenerator get I => KeyGenerator._(ByteType.x16);

  factory KeyGenerator.generate(ByteType type) => KeyGenerator._(type);

  int get length => type.value;

  Uint8List get bytes {
    final secure = Random.secure();
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = secure.nextInt(256);
    }
    return bytes;
  }

  String get key => Entity.key;

  String get secretKey => bytesToHex(bytes);

  String get secretIV => bytesToHex(bytes);

  String bytesToHex(Uint8List bytes) {
    var buffer = StringBuffer();
    var hexChars = "0123456789ABCDEF";
    for (var byte in bytes) {
      buffer.write(hexChars[(byte & 0xF0) >> 4]);
      buffer.write(hexChars[byte & 0x0F]);
    }
    return "$buffer";
  }
}

enum ByteType {
  x2(2),
  x4(4),
  x8(8),
  x16(16),
  x32(32),
  x64(64),
  x128(128);

  final int value;

  const ByteType(this.value);
}
