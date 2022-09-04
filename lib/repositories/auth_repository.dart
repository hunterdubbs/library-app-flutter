import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models/models.dart';

class AuthRepository{
  AuthRepository(this.flutterSecureStorage);

  final FlutterSecureStorage flutterSecureStorage;

  Auth? current;

  Future<Auth?> get auth async {
    if(current != null) return current;
    return await _fromStorage();
  }

  set auth(value) {
    current = value;
    _toStorage(value);
  }

  clear(){
    current = null;
    flutterSecureStorage.delete(key: 'id');
    flutterSecureStorage.delete(key: 'username');
    flutterSecureStorage.delete(key: 'access-token');
    flutterSecureStorage.delete(key: 'refresh-token');
  }

  Future<Auth?> _fromStorage() async {
    final id = await flutterSecureStorage.read(key: 'id');
    final username = await flutterSecureStorage.read(key: 'username');
    final accessToken = await flutterSecureStorage.read(key: 'access-token');
    final refreshToken = await flutterSecureStorage.read(key: 'refresh-token');
    if (id != null && username != null && accessToken != null && refreshToken != null) return Auth(id, username, accessToken, refreshToken);
    return null;
  }

  _toStorage(Auth auth) {
    flutterSecureStorage.write(key: 'id', value: auth.id);
    flutterSecureStorage.write(key: 'username', value: auth.username);
    flutterSecureStorage.write(key: 'access-token', value: auth.accessToken);
    flutterSecureStorage.write(key: 'refresh-token', value: auth.refreshToken);
  }
}