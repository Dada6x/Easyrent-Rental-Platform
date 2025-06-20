import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:dio/dio.dart';
import 'package:easyrent/core/app/notifications/notificationsApi.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/services/api/dio_consumer.dart';
import 'package:easyrent/data/repos/propertiesRepo.dart';
import 'package:easyrent/data/repos/userRepo.dart';
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

//! FOR DEBUGGING must erase it after the end of the application

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
final PropertyDio = PropertiesRepo(DioConsumer(Dio()));

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
      debug.d("application Started !!");
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

//! some mocky json
// https://run.mocky.io/v3/0df94981-cbd5-431e-935f-fab6a2ef8675   single property
//https://run.mocky.io/v3/2f457c10-6138-48c6-874b-02ae84e9c19f    two

/*
design architecture

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
BLoC receives the event and calls the repository
Repository makes API call through DioConsumer
API response is converted to model objects
BLoC emits new state with the data
UI rebuilds with the new state

?BLoC :
@For business logic and state management (clean, testable, scalable)
-----------------
!GetX :
* Localization
* Theming (Dark/Light)
* Navigation through routes
-----------------

*/

//############################# fetching SHit
/*

//////////!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! when the boolean shared pref worked
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDarkMode') ?? false;
  final langCode = prefs.getString('language') ?? 'ar';

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(ScreenUtilInit(
    designSize: const Size(430, 932),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, child) {
      final appController = Get.put(AppController());

      appController.isDarkMode.value = isDark;
      appController.isArabic.value = langCode == 'en';

      return ThemeProvider(
        initTheme: isDark ? Themes().darkMode : Themes().lightMode,
        builder: (_, theme) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            translations: MyLocale(),
            locale: Locale(langCode),
            fallbackLocale: const Locale('en'),
            home: const HomeScreenNavigator(),
          );
        },
      );
    },
  ));
}

//! first 
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

// Get.to(
                //     transition: Transition.fadeIn,
                //     duration: const Duration(milliseconds: 520),
                //     const PropertyDetailsPage(
                //       title: "MODERNISM VILLA",
                //       genre: "Villa",
                //       ratings: 4.5,
                //       reviews: 1221,
                //       beds: 3,
                //       baths: 4,
                //       area: 2000,
                //       price: 19322,
                //       overview:
                //           "Consequatur porro impedit alias odio voluptatem qui qui rerum aspernatur. Facere mollitia fugit perferendis deleniti quam neque voluptatem repellendus natus. Omnis ipsum culpa qui minima.",
                //       previewImages: [apartment, apartment2, japan],
                //       galleryImages: [
                //         apartment3,
                //         japan,
                //         apartment2,
                //         japan,
                //         apartment,
                //         japan,
                //         apartment
                //       ],
                //       lat: 33.5138,
                //       lng: 36.2765,
                //       panoramaImages: [
                //         {'name': 'Living Room', 'imagePath': panorama1},
                //         {'name': 'Kitchen', 'imagePath': panorama2},
                //         {'name': 'Bedroom', 'imagePath': panorama3},
                //       ],
                //     ));
*/

// https://images.pexels.com/photos/32631167/pexels-photo-32631167.jpeg 