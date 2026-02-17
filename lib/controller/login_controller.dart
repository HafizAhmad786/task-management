import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tgo_todo/model/user_model.dart';
import 'package:tgo_todo/services/firebase_services.dart';
import 'package:tgo_todo/services/secure_storage.dart';
import 'package:tgo_todo/utills/loader.dart';
import 'package:tgo_todo/view/bottom_bar/bottom_nav.dart';

class LoginController extends ChangeNotifier {
  bool _isChecked = false;

  bool get checked => _isChecked;
  var email = TextEditingController();
  var password = TextEditingController();

  login(BuildContext context) async {
    var storage = context.read<SecureStorage>();
    final firebaseServices = context.read<FirebaseServices>();
    var data = await firebaseServices.emailLogin(email.text.trim(), password.text.trim());
    if (data.containsKey("error")) {
      Fluttertoast.showToast(msg: data['error']);
      return;
    } else if (data['user'] != null && data.isNotEmpty) {
      await storage.saveUserId(data["user"] ?? "");

      Fluttertoast.showToast(msg: 'Login successfully');
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CustomBottomBar()));
      }
      return;
    } else {
      Fluttertoast.showToast(msg: 'user not found');
      return;
    }
  }

  rememberMe(bool val) async {
    _isChecked = val;
    notifyListeners();
  }

  bool obscurePassword = true;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  signInWithGoogle(BuildContext context) async {
    var storage = context.read<SecureStorage>();
    showLoader();
    final firebaseController = context.read<FirebaseServices>();
    var response = await firebaseController.signInWithGoogle();
    if (response['status'] != false) {
      String userId = response;
      await storage.saveUserId(userId);
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CustomBottomBar()));
      }
    }
    hideLoader();
  }
}
