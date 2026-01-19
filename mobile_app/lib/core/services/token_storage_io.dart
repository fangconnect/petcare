import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
);

/// Native (iOS/Android/Windows) implementation using FlutterSecureStorage
Future<void> write(String key, String value) async {
  await _storage.write(key: key, value: value);
}

Future<String?> read(String key) async {
  return await _storage.read(key: key);
}

Future<void> delete(String key) async {
  await _storage.delete(key: key);
}

Future<void> deleteAll() async {
  await _storage.deleteAll();
}
