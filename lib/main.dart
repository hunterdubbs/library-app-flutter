import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:library_app/data/authentication_api.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/repositories/auth_repository.dart';
import 'package:library_app/repositories/prefs_repository.dart';

import 'app.dart';

void main() {
  const FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
  final AuthRepository authRepository = AuthRepository(flutterSecureStorage);
  final PrefsRepository prefsRepository = PrefsRepository(flutterSecureStorage);
  //const String host = 'localhost';
  //const int port = 44361;

  const String host = 'library.basedpenguin.com';
  const int port = 443;

  runApp(App(
    authRepository: authRepository,
    authenticationApi: AuthenticationApi(host: host, port: port, authRepository: authRepository),
    libraryApi: LibraryApi(host: host, port: port, authRepository: authRepository),
    prefsRepository: prefsRepository,
  ));
}
