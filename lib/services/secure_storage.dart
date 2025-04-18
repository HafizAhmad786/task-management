import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage{
  final storage = FlutterSecureStorage();

  Future<void> saveUserId(String id)async{
    await storage.write(key: "userId", value: id);
  }

  Future<String> getUserId() async{
    return await storage.read(key: "userId") ?? "";
  }

  Future<void> clearUserInfo() async{
    await storage.deleteAll();
  }
}