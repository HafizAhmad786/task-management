import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:tgo_todo/provider/calendar_provider.dart';
import 'package:tgo_todo/provider/home_page_provider.dart';
import 'package:tgo_todo/provider/onboarding_provider.dart';
import 'package:tgo_todo/provider/profile_provider.dart';
import 'package:tgo_todo/services/firebase_services.dart';
import 'package:tgo_todo/services/notification_services.dart';
import 'package:tgo_todo/utills/file_indexes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tgo_todo/view/auth/splash.dart';
import 'package:tgo_todo/view/bottom_bar/bottom_nav.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));

  await initializeNotification();
  runApp(const MyApp());
}


initializeNotification() async {
  var notification = NotificationServices();
  await notification.initializeNotification();
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseServices>(create: (_) => FirebaseServices()),
        Provider<SecureStorage>(create: (_) => SecureStorage()),
        ChangeNotifierProvider(create: (_) => BottomBarProvider()),
        ChangeNotifierProvider(create: (_) => HomePageProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
      ],
      child: MaterialApp(
        title: 'TGO Todo',
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashPage(),
      ),
    );
  }
}
