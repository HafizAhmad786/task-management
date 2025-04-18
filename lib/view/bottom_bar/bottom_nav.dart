import 'package:provider/provider.dart';
import 'package:tgo_todo/utills/file_indexes.dart';
import 'package:tgo_todo/view/bottom_bar/home_page.dart';
import 'package:tgo_todo/view/calender/calendar_page.dart';
import 'package:tgo_todo/view/notification/notification_page.dart';
import 'package:tgo_todo/view/profile/profile.dart';

class CustomBottomBar extends StatelessWidget {
  CustomBottomBar({super.key});

  final List<Widget> _pages = [
    HomePage(),
    NotificationPage(),
    CalendarPage(),
    ProfilePage(),
  ];

  final List listOfIcons = [
    AppIcons.homeIcon,
    AppIcons.bellIcon,
    AppIcons.calendarIcon,
    AppImages.profileIcon
  ];

  static const List<String> listOfTitles = [
    'Home',
    'Notification',
    'Calendar',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomBarProvider>(
      builder: (context, bottomBarProvider, _) {
        return Scaffold(
          body: _pages[bottomBarProvider.currentIndex],
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(top: 8),
            height: 80,
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColor.lightGreyColor,
                  spreadRadius: 0,
                  blurRadius: 13,
                  offset: Offset(0, -3),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(4, (index) {
                final isSelected = index == bottomBarProvider.currentIndex;
                return InkWell(
                  onTap: () => bottomBarProvider.updateIndex(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (index == listOfIcons.length - 1)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            listOfIcons[index],
                            height: 20,
                            width: 20,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                      // SVG icon
                        showSvgIconWidget(
                          onTap: () => bottomBarProvider.updateIndex(index),
                          height: 20,
                          width: 20,
                          iconPath: listOfIcons[index],
                          color: isSelected
                              ? AppColor.lightPrimary
                              : Colors.grey,
                          context: context,
                        ),
                      SizedBox(height: 5),
                      Text(
                        listOfTitles[index],
                        style: kTextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? AppColor.lightPrimary
                              : AppColor.greyColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        height: 3,
                        width: 35,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColor.lightPrimary : AppColor.lightGreyColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

class BottomBarProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}