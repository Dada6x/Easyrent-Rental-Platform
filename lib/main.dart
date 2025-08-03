import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:dio/dio.dart';
import 'package:easyrent/core/app/notifications/notificationsApi.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/services/api/dio_consumer.dart';
import 'package:easyrent/data/repos/properties_repo.dart';
import 'package:easyrent/data/repos/user_repo.dart';
import 'package:easyrent/presentation/views/property_homepage/controller/propertiy_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:motion/motion.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easyrent/core/app/controller/app_controller.dart';
import 'package:easyrent/core/app/language/locale.dart';
import 'package:easyrent/core/app/middleware/middelware.dart';
import 'package:easyrent/core/app/theme/themes.dart';
import 'package:easyrent/presentation/navigation/navigator.dart';
import 'package:easyrent/presentation/navigation/splachScreen.dart';
import 'package:easyrent/presentation/views/auth/views/login.dart';

//! FOR DEBUGGING must erase it after the end of the application.
var debug = Logger(
    printer: PrettyPrinter(
  colors: true,
  methodCount: 0,
  errorMethodCount: 3,
  printEmojis: true,
));

SharedPreferences? userPref;

bool isOffline = !Get.find<AppController>().isOffline.value;
final userDio = Userrepo(DioConsumer(Dio()));
final propertyDio = PropertiesRepo(DioConsumer(Dio()));

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await NotificationsService().initNotification();
  userPref = await SharedPreferences.getInstance();
  bool isDarkTheme = userPref?.getBool('isDarkTheme') ?? false;
  int? savedColor = userPref?.getInt('primaryColor');
  Color primaryColor = savedColor != null ? Color(savedColor) : blue;
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // systemNavigationBarColor: blue,
    ),
  );

  // the payment Card gyroscope 3D shi
  await Motion.instance.initialize();
  Motion.instance.setUpdateInterval(60.fps);
  runApp(ScreenUtilInit(
    designSize: const Size(430, 932),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, child) {
      Get.put(AppController());
      Get.put(PropertiesController());
      debug.d("application Started0!!");
      return ThemeProvider(
        duration: const Duration(milliseconds: 700),
        initTheme: isDarkTheme
            ? Themes().darkMode.copyWith(
                colorScheme: Themes()
                    .darkMode
                    .colorScheme
                    .copyWith(primary: primaryColor))
            : Themes().lightMode.copyWith(
                  colorScheme: Themes()
                      .lightMode
                      .colorScheme
                      .copyWith(primary: primaryColor),
                ),
        builder: (_, theme) {
          return GetMaterialApp(
            onInit: () {},
            debugShowCheckedModeBanner: false,
            theme: theme,
            translations: MyLocale(),
            //! middlewares
            initialRoute: '/',
            getPages: [
              GetPage(
                name: '/',
                page: () => const SplashScreen(),
              ),
              GetPage(name: '/login', page: () => LoginPage(), middlewares: [
                MiddlewareAuth(),
              ]),
              GetPage(
                  name: '/homePage', page: () => const HomeScreenNavigator()),
            ],
          );
        },
      );
    },
  ));
}

//////////////////! use this package for animtations
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! flutter_animate: ^4.5.2 
///!!!!!!!!!!!!flutter_custom_carousel: ^0.1.0+1
/*
!design architecture

lib/
├── //! core/
│   ├── constants/           # App-wide colors, images paths.
│   ├── utils/               # textStyles.
│   └── services/            
│       ├── api/             # api consumer , api interceptor , dio consumer , end points
│       ├── app/             # controller for theme , language , internet connection 
│       └── errors/          # error model , exceptions 
│
├── //@ data/
│   ├── models/              # Shared models (e.g., User, Location)
│   └── repositories/        # API calls and implementations
│
├── //? presentation/
│   ├── //$home/ 
│   │   ├── views/
│   │   │   └── home_page.dart
│   │   └── //~bloc/
│   │
│   ├── //$auth/
│   │   ├── views/
│   │   │   └── login_page.dart
│   │   ├── bloc/
│   │   │   ├── auth_bloc.dart
│   │   │   ├── auth_event.dart
│   │   │   └── auth_state.dart
│   │   └── widgets/         # LoginForm, AuthButton, etc.
│   │
│   ├── //$property/
│   │   ├── views/
│   │   │   ├── property_list_page.dart
│   │   │   └── property_detail_page.dart
│   │   ├── //~bloc/
│   │   │   ├── property_bloc.dart
│   │   │   ├── property_event.dart
│   │   │   └── property_state.dart
│   │   ├── widgets/         # PropertyCard, PriceTag, etc.
│   │   └── models/  \        # Optional feature-specific models
│   │
│   ├── //$profile/
│   │   ├── views/
│   │   │   ├── property_list_page.dart
│   │   │   └── property_detail_page.dart
│   │   ├── //~bloc/
│   │   │   ├── profile.dart
│   │   │   └── profile_state.dart
│   │   ├── widgets/         # PropertyCard, PriceTag, etc.
│   │   └── models/          # Optional feature-specific models
│   │
├── //# routes/
│   └── app_routes.dart      # Route names and navigation logic
│
└── //?main.dart
-------------------------------------------------------------------------------------
UI triggers an event (e.g., LoadProperties)
GetXController receives the event and calls the repository
Repository makes API call through DioConsumer
API response is converted to model objects
UI rebuilds with the new state
-----------------
!GetX :
* Localization
* Theming (Dark/Light)
* Navigation through routes
-----------------

/! first 
https://images.unsplash.com/photo-1518780664697-55e3ad937233?q=80&w=1965&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
https://plus.unsplash.com/premium_photo-1689609950069-2961f80b1e70?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
https://images.unsplash.com/photo-1523217582562-09d0def993a6?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
https://images.unsplash.com/photo-1449844908441-8829872d2607?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D

https://images.unsplash.com/photo-1523755231516-e43fd2e8dca5?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
https://images.unsplash.com/photo-1505691723518-36a5ac3be353?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
https://images.unsplash.com/photo-1501127122-f385ca6ddd9d?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
https://images.unsplash.com/photo-1505015920881-0f83c2f7c95e?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
https://images.unsplash.com/photo-1556020685-ae41abfc9365?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
https://images.unsplash.com/photo-1516455590571-18256e5bb9ff?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
*/




/*!SECTION



*/





//TODO
//! (1)  Search And Filtering 
//! (2)  Agent Details By Id 
//! (3)  Notificationsب
//! (4)  Profile Image Error
//! (5)  Upgrade from User to Agent.
//! (6)  AGENT ROLE ( upload,delete,edit,myProperties) 
//! (7)  icon for the application.
