import 'package:provider/provider.dart';
import 'package:tgo_todo/provider/onboarding_provider.dart';
import 'package:tgo_todo/utills/file_indexes.dart';
import 'package:tgo_todo/view/auth/login_page.dart';

class OnboardingScreen extends StatefulWidget {
   const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final OnboardingProvider provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider = OnboardingProvider();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    provider.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Builder(
        builder: (context){
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: provider.controller,
                    onPageChanged: provider.updateIndex,
                    itemCount: provider.pages.length,
                    itemBuilder: (_, index) {
                      final page = provider.pages[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(page.imgPath, height: 250),
                          SizedBox(height: 30),
                          Text(
                            page.title,
                            style: kTextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            page.subtitle,
                            style: kTextStyle(fontSize: 16, color: AppColor.greyText,fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));},
                        child: Text("Skip", style: kTextStyle(color: AppColor.greyText)),
                      ),
                      Consumer<OnboardingProvider>(
                        builder: (context,provider,child){
                          return Row(
                            children: List.generate(
                              provider.pages.length,
                                  (index) => AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                height: 10,
                                width: provider.currentIndex == index ? 24 : 10,
                                decoration: BoxDecoration(
                                  color: provider.currentIndex == index ? AppColor.lightPrimary : AppColor.lightGreyColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      InkWell(
                        onTap: () => provider.nextPage(context),
                        borderRadius: BorderRadius.circular(30),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColor.lightPrimary,
                          child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



