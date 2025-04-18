import 'package:flutter/material.dart';
import 'package:tgo_todo/utills/constants/assets_path.dart';
import 'package:tgo_todo/view/auth/login_page.dart';

class OnboardingProvider extends ChangeNotifier {
   int _currentIndex = 0;
  final PageController _controller = PageController();

  int get currentIndex => _currentIndex;
  PageController get controller => _controller;

  void nextPage(BuildContext context) {
    if (_currentIndex < 2) {
      _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
   final List<OnboardingPageModel> pages = [
     OnboardingPageModel(
       imgPath: AppImages.onboarding1,
       title: "📌 Stay Organized & Focused",
       subtitle: "Easily create, manage, and prioritize your tasks.",
     ),
     OnboardingPageModel(
       imgPath: AppImages.onboarding2,
       title: "⏳ Never Miss a Deadline",
       subtitle: "Set reminders and track deadlines effortlessly.",
     ),
     OnboardingPageModel(
       imgPath: AppImages.onboarding3,
       title: "✅ Boost Productivity",
       subtitle: "Track progress and get more done with ease.",
     ),
   ];


}
class OnboardingPageModel {
  final String imgPath;
  final String title;
  final String subtitle;

  OnboardingPageModel({
    required this.title,
    required this.imgPath,
    required this.subtitle,
  });
}
