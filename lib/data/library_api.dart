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

  Future<void> leaveLibrary({required int libraryId}) async {
    final response = await deleteRequest(
      uri: buildUri('library/leave/$libraryId'),
      headers: await buildHeaderWithAuth()
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
        'collectionID': collectionId
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
  
  Future<List<CollectionMembership>> getCollectionsOfBook(int bookId) async {
    final response = await getRequest(
      uri: buildUri('collection/book/list/$bookId'),
      headers: await buildHeaderWithAuth()
    );
    if(response.statusCode == 200){
      final List<dynamic> json = jsonDecode(response.body);
      List<CollectionMembership> collectionList = List<CollectionMembership>.from(json.map((i) => CollectionMembership.fromJson(i)));
      return collectionList;
    }else{
      throw Exception();
    }
  }
  
  Future<void> modifyCollectionsOfBook(int bookId, List<int> collectionIds) async {
    final response = await postRequest(
      uri: buildUri('collection/book'),
      headers: await buildHeaderWithAuth(),
      body: jsonEncode({
        'bookID': bookId,
        'collectionIds': collectionIds
      })
    );
    if(response.statusCode == 200){
      return;
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
        'datePublished': datePublished.toIso8601String(),
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
        'datePublished': datePublished.toIso8601String(),
        'authors': authors.map((i) => i.toJson()).toList()
      })
    );
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception();
    }
  }

  Future<void> deleteBook({
    required int bookId
  }) async {
    final response = await postRequest(
      uri: buildUri('book/delete'),
      headers: await buildHeaderWithAuth(),
      body: jsonEncode({
        'bookID': bookId
      })
    );
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception();
    }
  }
  
  Future<List<Author>> searchAuthors({required String searchTerm}) async {
    final response = await getRequest(
      uri: buildUriWithQueryParams('author/search', {
        'searchTerm': searchTerm
      }),
      headers: await buildHeaderWithAuth(),
    );
    if(response.statusCode == 200){
      final List<dynamic> json = jsonDecode(response.body);
      List<Author> authors = List<Author>.from(json.map((i) => Author.fromJson(i)));
      return authors;
    }else{
      throw Exception();
    }
  }

  Future<Author> createAuthor({
    required String firstName,
    required String lastName
  }) async {
    final response = await postRequest(
      uri: buildUri('author/create'),
      headers: await buildHeaderWithAuth(),
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName
      })
    );
    if(response.statusCode == 200){
      final json = jsonDecode(response.body);
      Author author = Author.fromJson(json);
      return author;
    }else{
      throw Exception();
    }
  }
  
  Future<FullLibraryPermission> getLibraryPermissions({required int libraryId}) async {
     final response = await getRequest(
       uri: buildUri('permission/library/$libraryId'),
       headers: await buildHeaderWithAuth()
     );
     if(response.statusCode == 200){
       final json = jsonDecode(response.body);
       List<LibraryPermission> permissions = List<LibraryPermission>.from(json['permissions'].map((i) => LibraryPermission.fromJson(i)));
       List<Invite> invites = List<Invite>.from(json['invites'].map((i) => Invite.fromJson(i)));
       return FullLibraryPermission(permissions: permissions, invites: invites);
     }else {
       throw Exception();
     }
  }

  Future<void> deletePermission({required String userId, required int libraryId}) async {
    final response = await postRequest(
      uri: buildUri('permission/remove'),
      headers: await buildHeaderWithAuth(),
      body: jsonEncode({
        'libraryId': libraryId,
        'userId': userId
      })
    );
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception();
    }
  }

  Future<List<User>> searchUsers({required String searchTerm}) async {
    final response = await getRequest(
      uri: buildUriWithQueryParams('permission/user/search', {
        'searchTerm': searchTerm
      }),
      headers: await buildHeaderWithAuth()
    );
    if(response.statusCode == 200){
      final List<dynamic> json = jsonDecode(response.body);
      List<User> users = List<User>.from(json.map((i) => User.fromJson(i)));
      return users;
    }else{
      throw Exception();
    }
  }
  
  Future<void> createInvite({
    required int libraryId,
    required String recipientId,
    required int permissionLevel
  }) async {
    final response = await postRequest(
      uri: buildUri('permission/invite/create'),
      headers: await buildHeaderWithAuth(),
      body: jsonEncode({
        'libraryId': libraryId,
        'recipientId': recipientId,
        'permissionType': permissionLevel
      })
    );
    if(response.statusCode == 200){
      return;
    }else if(response.statusCode == 400){
      throw CreateInviteException(response.body);
    }else{
      throw Exception();
    }
  }

  Future<void> deleteInvite({
    required int inviteId
  }) async {
    final response = await deleteRequest(
      uri: buildUri('permission/invite/$inviteId'),
      headers: await buildHeaderWithAuth()
    );
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception();
    }
  }

  Future<List<Invite>> getInvites() async {
    final response = await getRequest(
      uri: buildUri('permission/invites'),
      headers: await buildHeaderWithAuth()
    );
    if(response.statusCode == 200){
      final List<dynamic> json = jsonDecode(response.body);
      List<Invite> invites = List<Invite>.from(json.map((i) => Invite.fromJson(i)));
      return invites;
    }else{
      throw Exception();
    }
  }

  Future<void> acceptInvite({
    required int inviteId
  }) async {
    final response = await postRequest(
        uri: buildUri('permission/invite/$inviteId/accept'),
        headers: await buildHeaderWithAuth()
    );
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception();
    }
  }

  Future<void> rejectInvite({
    required int inviteId
  }) async {
    final response = await postRequest(
        uri: buildUri('permission/invite/$inviteId/reject'),
        headers: await buildHeaderWithAuth()
    );
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception();
    }
  }

  Future<AccountInfo> loadAccountInfo() async {
    final response = await getRequest(
      uri: buildUri('account/info'),
      headers: await buildHeaderWithAuth()
    );
    if(response.statusCode == 200){
      final json = jsonDecode(response.body);
      final accountInfo = AccountInfo.fromJson(json);
      return accountInfo;
    }else{
      throw Exception();
    }
  }
  
  Future<void> deleteAccount({
    required String password
  }) async {
    final response = await postRequest(
      uri: buildUri('account/delete'),
      headers: await buildHeaderWithAuth(),
      body: jsonEncode({
        'password': password
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

class CreateInviteException implements Exception {
  const CreateInviteException(this.msg);

  final String msg;
}

class InviteActionException implements Exception {
  const InviteActionException(this.msg);

  final String msg;
}