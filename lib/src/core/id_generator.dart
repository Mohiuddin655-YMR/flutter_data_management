part of 'configs.dart';

class DataIdGenerator {
  final DataByteType type;

  DataIdGenerator._(this.type);

  static DataIdGenerator get I => DataIdGenerator._(DataByteType.x16);

  factory DataIdGenerator.generate(DataByteType type) =>
      DataIdGenerator._(type);

  int get length => type.value;

  Uint8List get bytes {
    final secure = Random.secure();
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = secure.nextInt(256);
    }
    return bytes;
  }

  String get key => DateTime.now().millisecondsSinceEpoch.toString();

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

enum DataByteType {
  x2(2),
  x4(4),
  x8(8),
  x16(16),
  x32(32),
  x64(64),
  x128(128);

  final int value;

  const DataByteType(this.value);
}
