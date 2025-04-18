import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tgo_todo/model/task_model.dart';
import 'package:tgo_todo/model/user_model.dart';
import 'package:tgo_todo/services/database_services.dart';
import 'package:tgo_todo/services/secure_storage.dart';

class FirebaseServices {
  final _auth = FirebaseAuth.instance;
  final _db = DatabaseServices();
  final _secureStorage = SecureStorage();

  Future<Map<String, dynamic>> emailLogin(String email, String password) async {
    try {
      var response = await _auth.signInWithEmailAndPassword(email: email, password: password);
      var userData = await _db.user.doc(response.user!.uid).get();
      if (userData.exists) {
        return {"user": UserModel.fromJson(userData.data()!)};
      } else {
        return {};
      }
    } on FirebaseAuthException catch (e) {
      return {"error": e.message};
    }
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return {"status": false, "message": "Google Sign-In canceled"};
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        return {"status": false, "message": "Failed to sign in"};
      }
      var response = await _db.user.doc(user.uid).get();
      if (response.exists) {
        await _secureStorage.saveUserId(user.uid);
        return user.uid;
      } else {
        await _secureStorage.saveUserId(user.uid);
        await _db.user
            .doc(user.uid)
            .set({"displayName": googleUser.displayName, "email": googleUser.email, "userId": googleUser.id, "photoURL": googleUser.photoUrl});
        return user.uid;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> createNewUser(Map<String, dynamic> userData) async {
    try {
      var user = await _auth.createUserWithEmailAndPassword(email: userData['email'], password: userData['password']);
      userData.addAll({"userId": user.user!.uid});
      userData.remove("password");
     await _db.user.doc(user.user!.uid).set(userData);
    } on FirebaseAuthException catch (e) {
      return {"error": e.code};
    }
  }

  Future<dynamic> addNewTask(Map<String, dynamic> task) async {
    try{
     var doc = await _db.task.add(task);
     await _db.task.doc(doc.id).update({
       "taskId": doc.id
     });
      return doc.id;
    }on FirebaseException catch(e){
      debugPrint(e.code);
      return;
    }
  }

  Future<void> updateTask(Map<String, dynamic> task,String taskId) async {
    try{
      await _db.task.doc(taskId).update(task);
      return;
    }on FirebaseException catch(e){
      debugPrint(e.code);
      return;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try{
      await _db.task.doc(taskId).delete();
      return;
    }on FirebaseException catch(e){
      debugPrint(e.code);
      return;
    }
  }

  Future<List<TaskModel>> getAllTask(String userId) async {
    try{
      var result = await _db.task.where("userId",isEqualTo: userId).get();
      if(result.docs.isNotEmpty){
        return result.docs.map((task) => TaskModel.fromJson(task.data())).toList();
      }
      return [];
    }on FirebaseException catch(e){
      debugPrint(e.code);
      return [];
    }
  }

  Future<UserModel?> getUserInfo(String userId) async{
    try{
      var result = await _db.user.doc(userId).get();
      if(result.exists){
        return UserModel.fromJson(result.data()!);
      }else{
        return null;
      }
    }on FirebaseException catch(e){
      debugPrint(e.code);
      return null;
    }
  }

  Future<void> signOutAll() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}
