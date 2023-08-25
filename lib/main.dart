import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/utils/globals.dart' as global;
import 'package:kalamazoo/screen/home_screen.dart';
import 'package:kalamazoo/screen/notification_screen.dart';
import 'package:kalamazoo/screen/subscription_screen.dart';
import 'package:kalamazoo/screen/search_screen.dart';
import 'package:kalamazoo/screen/profileedit_screen.dart';
import 'package:kalamazoo/screen/about_screen.dart';
import 'package:kalamazoo/screen/menu_screen.dart';
import 'package:kalamazoo/screen/item_screen.dart';
import 'package:kalamazoo/screen/start_screen.dart';
import 'package:kalamazoo/screen/login_screen.dart';
import 'package:kalamazoo/screen/otp_screen.dart';
import 'package:kalamazoo/screen/resetpass_screen.dart';
import 'package:kalamazoo/screen/retrievepass_screen.dart';
import 'package:kalamazoo/screen/registration_screen.dart';
import 'package:kalamazoo/screen/registration2_screen.dart';
import 'package:kalamazoo/screen/splash_screen.dart';

var routes = <String, WidgetBuilder>{
  "/OTPScreen": (BuildContext context) => const OTPScreen(),
  "/ResetPassScreen": (BuildContext context) => const ResetPassScreen(),
  "/RetrievePassScreen": (BuildContext context) => const RetrievePassScreen(),
  "/RegistrationScreen": (BuildContext context) => const RegistrationScreen(),
  "/Registration2Screen": (BuildContext context) => const Registration2Screen(),
  "/LoginScreen": (BuildContext context) => const LoginScreen(),
  "/HomeScreen": (BuildContext context) => const HomeScreen(),
  "/NotificationScreen": (BuildContext context) => const NotificationScreen(),
  "/SubscriptionScreen": (BuildContext context) => const SubscriptionScreen(),
  "/SearchScreen": (BuildContext context) => const SearchScreen(),
  "/ProfileEditScreen": (BuildContext context) => const ProfileEditScreen(),
  "/AboutScreen": (BuildContext context) => const AboutScreen(),
  "/MenuScreen": (BuildContext context) => const MenuScreen(),
  "/ItemScreen": (BuildContext context) => const ItemScreen(),
  "/StartScreen": (BuildContext context) => const StartScreen(),
};
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? isLogged = prefs.getString('credential');
  isLogged ??= '';
  global.userEmail = isLogged;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MaterialColor defaultcolor = MaterialColor(
    const Color.fromRGBO(45, 108, 255, 1).value,
    const <int, Color>{
      50: Color.fromRGBO(45, 108, 255, 0.1),
      100: Color.fromRGBO(45, 108, 255, 0.2),
      200: Color.fromRGBO(45, 108, 255, 0.3),
      300: Color.fromRGBO(45, 108, 255, 0.4),
      400: Color.fromRGBO(45, 108, 255, 0.5),
      500: Color.fromRGBO(45, 108, 255, 0.6),
      600: Color.fromRGBO(45, 108, 255, 0.7),
      700: Color.fromRGBO(45, 108, 255, 0.8),
      800: Color.fromRGBO(45, 108, 255, 0.9),
      900: Color.fromRGBO(45, 108, 255, 1),
    },
  );

  MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: defaultcolor,
            inputDecorationTheme: const InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    borderSide: BorderSide(color: CustomColor.primaryColor)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    borderSide: BorderSide(color: CustomColor.activeColor)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    borderSide: BorderSide(color: CustomColor.activeColor)),
                filled: true,
                fillColor: Colors.white),
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            )),
        home: const SplashScreen(),
        routes: routes);
  }
}
