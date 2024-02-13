import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models/models.dart';

class PrefsRepository{
  PrefsRepository(this.flutterSecureStorage);

  final FlutterSecureStorage flutterSecureStorage;

  Prefs? current;

  Future<Prefs> get prefs async {
    if(current != null) return current!;
    return await _fromStorage();
  }

  set prefs(value) {
    current = value;
    _toStorage(value);
  }

  Future<Prefs> _fromStorage() async {
    final groupSeries = await flutterSecureStorage.read(key: 'groupSeries');

    if(groupSeries != null) return Prefs(groupSeries.toLowerCase() == 'true');
    return Prefs(false);
  }
  
  _toStorage(Prefs prefs) {
    flutterSecureStorage.write(key: 'groupSeries', value: prefs.groupSeries.toString());
  }
}