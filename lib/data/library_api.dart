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

  Future<void> deleteLibrary({required int libraryId}) async {
    final response = await postRequest(
        uri: buildUri('library/delete'),
        headers: await buildHeaderWithAuth(),
        body: jsonEncode({
          'libraryID': libraryId
        })
    );
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception();
    }
  }

  Future<void> modifyLibrary({required int libraryId, required String name}) async {
    final response = await postRequest(
      uri: buildUri('library/modify'),
      headers: await buildHeaderWithAuth(),
      body: jsonEncode({
        'libraryID': libraryId,
        'name':name
      })
    );
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception();
    }
  }

  Future<void> createCollection({
    required int libraryId,
    required int parentCollectionId,
    required String name,
    required String description
  }) async {
    final response = await postRequest(
      uri: buildUri('collection/create'),
      headers: await buildHeaderWithAuth(),
      body: jsonEncode({
        'libraryID': libraryId,
        'parentCollectionID': parentCollectionId,
        'name': name,
        'description': description
      })
    );
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception();
    }
  }

  Future<void> modifyCollection({
    required int collectionId,
    required String name,
    required String description
  }) async {
    final response = await postRequest(
      uri: buildUri('collection/modify'),
      headers: await buildHeaderWithAuth(),
      body: jsonEncode({
        'collectionId': collectionId,
        'name': name,
        'description': description
      })
    );
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception();
    }
  }

  Future<void> deleteCollection({required int collectionId}) async {
    final response = await postRequest(
      uri: buildUri('collection/delete'),
      headers: await buildHeaderWithAuth(),
      body: jsonEncode({
        'collectionID', collectionId
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

  Future<List<Book>> getBooksByCollection(int collectionId) async {
    final response = await getRequest(
      uri: buildUri('book/collection/$collectionId'),
      headers: await buildHeaderWithAuth()
    );
    if(response.statusCode == 200){
      final List<dynamic> json = jsonDecode(response.body);
      List<Book> bookList = List<Book>.from(json.map((i) => Book.fromJson(i)));
      return bookList;
    }else{
      throw Exception();
    }
  }

  Future<void> createBookInCollection({
    required int libraryId,
    required int collectionId,
    required String title,
    required String synopsis,
    required DateTime datePublished,
    required List<Author> authors
  }) async {
    final response = await postRequest(
      uri: buildUri('book/create'),
      headers: await buildHeaderWithAuth(),
      body: jsonEncode({
        'title': title,
        'synopsis': synopsis,
        'libraryID': libraryId,
        'datePublished': datePublished,
        'collectionID': collectionId,
        'authors': authors.map((i) => i.toJson()).toList()
      })
    );
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception();
    }
  }

  Future<void> modifyBook({
    required int libraryId,
    required int bookId,
    required String title,
    required String synopsis,
    required DateTime datePublished,
    required List<Author> authors
  }) async {
    final response = await postRequest(
      uri: buildUri('book/modify'),
      headers: await buildHeaderWithAuth(),
      body: jsonEncode({
        'bookId': bookId,
        'title': title,
        'synopsis': synopsis,
        'libraryID': libraryId,
        'datePublished': datePublished,
        'authors': authors.map((i) => i.toJson()).toList()
      })
    );
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception();
    }
  }
}

class LibraryNotFoundException implements Exception {}