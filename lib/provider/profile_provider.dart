import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgo_todo/model/user_model.dart';
import 'package:tgo_todo/services/firebase_services.dart';
import 'package:tgo_todo/services/secure_storage.dart';
import 'package:tgo_todo/utills/constants/assets_path.dart';
import 'package:tgo_todo/utills/loader.dart';
import 'package:tgo_todo/view/auth/onboarding_page.dart';

class ProfileProvider extends ChangeNotifier {
  UserModel _userModel = UserModel();

  UserModel get userModel => _userModel;

  final List<ProfileTileModel> pages = [
    ProfileTileModel(
      icon: AppIcons.editIcon,
      title: "Edit Profile",
    ),
    ProfileTileModel(
      icon: AppIcons.passwordIcon,
      title: "Change Password",
    ),
    ProfileTileModel(
      icon: AppIcons.logoutIcon,
      title: "Logout",
    ),
  ];

  getUserInfo(BuildContext context) async {
    showLoader();
    var storage = context.read<SecureStorage>();
    var firebase = context.read<FirebaseServices>();
    String userId = await storage.getUserId();
    var response = await firebase.getUserInfo(userId);
    if (response != null) {
      _userModel = response;
    }
    notifyListeners();
    hideLoader();
  }

  logout(BuildContext context) async {
    var storage = context.read<SecureStorage>();
    var firebase = context.read<FirebaseServices>();
    await storage.clearUserInfo();
    await firebase.signOutAll();
    if (context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
  }
}

class ProfileTileModel {
  final String icon;
  final String title;

  ProfileTileModel({
    required this.title,
    required this.icon,
  });
}
