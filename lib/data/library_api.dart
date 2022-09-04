import 'dart:convert';

import 'package:library_app/data/models/models.dart';
import 'package:library_app/data/web_api.dart';
import 'package:library_app/repositories/auth_repository.dart';

class LibraryApi extends WebApi{
  LibraryApi({required String host, int? port, required AuthRepository authRepository}) : super(host: host, port: port, authRepository: authRepository);

  Future<List<Library>> getLibraries() async {
    final response = await getRequest(
      uri: buildUri('library/all'),
      headers: await buildHeaderWithAuth()
    );
    if(response.statusCode == 200){
      final List<dynamic> json = jsonDecode(response.body);
      List<Library> libraryList = List<Library>.from(json.map((i) => Library.fromJson(i)));
      return libraryList;
    }else{
      throw Exception();
    }
  }

  Future<void> createLibrary({required String name}) async {
    final response = await postRequest(
      uri: buildUri('library/create'),
      headers: await buildHeaderWithAuth(),
      body: jsonEncode({
        'name': name
      })
    );
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception();
    }
  }
  
  Future<List<Collection>> getCollections(int libraryId) async {
    final response = await getRequest(
      uri: buildUri('collection/list/$libraryId'),
      headers: await buildHeaderWithAuth()
    );
    if(response.statusCode == 200){
      final List<dynamic> json = jsonDecode(response.body);
      List<Collection> collectionList = List<Collection>.from(json.map((i) => Collection.fromJson(i)));
      return collectionList;
    }else{
      throw Exception();
    }
  }
}

class LibraryNotFoundException implements Exception {}