import 'package:provider/provider.dart';
import 'package:tgo_todo/utills/file_indexes.dart';
import 'package:tgo_todo/view/auth/onboarding_page.dart';
import 'package:tgo_todo/view/bottom_bar/bottom_nav.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding(context);
  }




  Future<void> _navigateToOnboarding(BuildContext cnotext) async {

    var secureStorage = context.read<SecureStorage>();
    String userId = await secureStorage.getUserId();
    await Future.delayed(const Duration(seconds: 3));
    if (userId.isNotEmpty) {
     if(mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CustomBottomBar()));
    } else {
      if(mounted) Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFFFA64D),
            Color(0xFFFF8C1A),
            Color(0xFFFF6A00),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Center(
        child: Image.asset(
          AppImages.logoImg,
          width: 150, // adjust size if needed
          height: 150,
        ),
      ),
    );
  }
}
