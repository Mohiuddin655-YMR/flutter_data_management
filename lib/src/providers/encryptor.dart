part of 'providers.dart';

typedef EncryptorRequestBuilder = Map<String, dynamic> Function(
  String request,
  String passcode,
);

typedef EncryptorResponseBuilder = dynamic Function(Map<String, dynamic> data);

class Encryptor {
  final String key;
  final String iv;
  final String passcode;
  final EncryptorRequestBuilder? _request;
  final EncryptorResponseBuilder? _response;

  EncryptorResponseBuilder get response => _response ?? (a) => a["data"];

  EncryptorRequestBuilder get request => _request ?? (a, b) => {"data": a};

  const Encryptor({
    this.key = "A79842D8A13A10A6DD27759BD700E292",
    this.iv = "9777298A5D7A8AFA",
    this.passcode = "passcode",
    EncryptorRequestBuilder? request,
    EncryptorResponseBuilder? response,
  })  : _request = request,
        _response = response;

  crypto.Key get _key => crypto.Key.fromUtf8(key);

  crypto.IV get _iv => crypto.IV.fromUtf8(iv);

  crypto.Encrypter get _en {
    return crypto.Encrypter(
      crypto.AES(_key, mode: crypto.AESMode.cbc),
    );
  }

  Future<Map<String, dynamic>> input(dynamic data) => compute(_encoder, data);

  Future<Map<String, dynamic>> output(dynamic data) => compute(_decoder, data);

  Future<Map<String, dynamic>> _encoder(dynamic data) async {
    try {
      if (data is Map<String, dynamic>) {
        final encrypted = _en.encrypt(jsonEncode(data), iv: _iv);
        return request.call(encrypted.base64, passcode);
      } else {
        return {};
      }
    } catch (_) {
      return {};
    }
  }

  Future<Map<String, dynamic>> _decoder(dynamic source) async {
    try {
      if (source is Map<String, dynamic>) {
        final value = await response.call(source);
        if (value != null) {
          final encrypted = crypto.Encrypted.fromBase64(value);
          final data = _en.decrypt(encrypted, iv: _iv);
          return jsonDecode(data);
        } else {
          return {};
        }
      } else {
        return {};
      }
    } catch (_) {
      return {};
    }
  }

  static String generateKey([ByteType type = ByteType.x16]) {
    return KeyGenerator.generate(type).secretKey;
  }

  static String generateIV([ByteType type = ByteType.x8]) {
    return KeyGenerator.generate(type).secretIV;
  }
}
