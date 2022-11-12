import 'dart:async';
import 'dart:convert';

import 'package:library_app/data/web_api.dart';
import 'package:library_app/repositories/auth_repository.dart';
import 'package:library_app/repositories/models/models.dart';

enum AuthenticationStatus{ unknown, authenticated, unauthenticated }

class AuthenticationApi extends WebApi {
  AuthenticationApi({required String host, int? port, required AuthRepository authRepository}) : super(host: host, port: port, authRepository: authRepository);

  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    final response = await postRequest(
      uri: buildUri('identity/login'),
      headers: buildHeaderNoAuth(),
      refresh: false,
      body: jsonEncode({
        'Username': username,
        'Password': password
      })
    );

    if(response.statusCode == 200){
      final json = jsonDecode(response.body);
      final userId = json["id"];
      final accessToken = json['token'];
      final refreshToken = json['refreshToken'];
      final username = json['username'];
      saveAuth(Auth(userId, username, accessToken, refreshToken));

      _controller.add(AuthenticationStatus.authenticated);
    }else if(response.statusCode == 400){
      throw LoginException(response.body);
    }else{
      throw InvalidCredentialsException();
    }
  }
  
  Future<void> register({
    required String username,
    required String email,
    required String password
  }) async {
    final response = await postRequest(
      uri: buildUri('identity/register'),
      headers: await buildHeaderNoAuth(),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password
      })
    );

    if(response.statusCode == 200){
      return;
    }else if(response.statusCode == 400){
      throw RegisterException(response.body);
    }else{
      throw Exception();
    }
  }

  Future<void> requestPasswordReset({required String email}) async {
    final response = await postRequest(
      uri: buildUri('identity/requestreset'),
      headers: await buildHeaderNoAuth(),
      body: jsonEncode({
        'email': email
      })
    );

    if(response.statusCode == 200){
      return;
    }else{
      throw Exception();
    }
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword
  }) async {
    final response = await postRequest(
      uri: buildUri('identity/reset'),
      headers: await buildHeaderNoAuth(),
      body: jsonEncode({
        'email': email,
        'password': newPassword,
        'resetCode': code
      })
    );

    if(response.statusCode == 200){
      return;
    }else{
      throw Exception();
    }
  }

  void logOut(){
    clearAuth();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}

class InvalidCredentialsException implements Exception {}

class RegisterException implements Exception {
  const RegisterException(this.error);

  final String error;
}

class LoginException implements Exception {
  const LoginException(this.msg);

  final String msg;
}