import 'dart:convert';

import 'package:library_app/repositories/auth_repository.dart';

import '../repositories/models/models.dart';
import 'package:http/http.dart';

class WebApi {
  WebApi({required String host, int? port, required AuthRepository authRepository})
      : _host = host,
      _port = port,
      _authRepository = authRepository;

  final String _host;
  final int? _port;
  final AuthRepository _authRepository;

  buildUri(String path) =>
      Uri(
        scheme: 'https',
        host: _host,
        port: _port,
        path: '/api/$path'
  );

  buildHeaderNoAuth() =>
      {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

  buildHeaderWithAuth() async {
    final auth = await _authRepository.auth;
    if(auth == null) throw AuthException();
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization' : 'Bearer ${auth.accessToken}'
    };
  }

  saveAuth(Auth auth){
    _authRepository.auth = auth;
  }

  clearAuth(){
    _authRepository.clear();
  }

  Future<Response> getRequest({
    required Uri uri,
    required Map<String, String> headers,
    bool refresh = true
  }) async {
    final response = await get(
      uri,
      headers: headers
    );
    
    if(response.statusCode == 401){
      if(!refresh) throw RefreshException();
      await refreshAuth();
      return await get(
        uri,
        headers: await buildHeaderWithAuth()
      );
    }
    return response;
  }

  Future<Response> postRequest({
    required Uri uri,
    required Map<String, String> headers,
    Object? body,
    bool refresh = true
  }) async {
    final response = await post(
        uri,
        headers: headers,
        body: body
    );

    if(response.statusCode == 401){
      if(!refresh) throw RefreshException();
      await refreshAuth();
      return await post(
          uri,
          headers: await buildHeaderWithAuth(),
          body: body
      );
    }
    return response;
  }

  Future<Response> putRequest({
    required Uri uri,
    required Map<String, String> headers,
    Object? body,
    bool refresh = true
  }) async {
    final response = await put(
        uri,
        headers: headers,
        body: body
    );

    if(response.statusCode == 401){
      if(!refresh) throw RefreshException();
      await refreshAuth();
      return await put(
          uri,
          headers: await buildHeaderWithAuth(),
          body: body
      );
    }
    return response;
  }

  Future<Response> deleteRequest({
    required Uri uri,
    required Map<String, String> headers,
    bool refresh = true
  }) async {
    final response = await delete(
        uri,
        headers: headers
    );

    if(response.statusCode == 401){
      if(!refresh) throw RefreshException();
      await refreshAuth();
      return await delete(
          uri,
          headers: await buildHeaderWithAuth()
      );
    }
    return response;
  }

  Future<void> refreshAuth() async {
    final auth = await _authRepository.auth;
    if(auth == null) throw AuthException();
    
    final response = await post(
      buildUri('identity/refresh'),
      headers: await buildHeaderNoAuth(),
      body: jsonEncode({
        'UserId': auth.id,
        'RefreshToken': auth.refreshToken
      })
    );

    if(response.statusCode == 200){
      final json = jsonDecode(response.body);

      final String accessToken = json['token'];
      final String refreshToken = json['refreshToken'];
      saveAuth(Auth(auth.id, auth.username, accessToken, refreshToken));
    }
  }
}

class AuthException implements Exception {}
class RefreshException implements Exception {}