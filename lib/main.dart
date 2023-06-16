import 'package:flutter/material.dart';
import 'package:kalamazoo/screen/home_screen.dart';
import 'package:kalamazoo/screen/notification_screen.dart';
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
import 'package:kalamazoo/screen/splash_screen.dart';

var routes = <String, WidgetBuilder>{
  "/OTPScreen": (BuildContext context) => const OTPScreen(),
  "/ResetPassScreen": (BuildContext context) => const ResetPassScreen(),
  "/RetrievePassScreen": (BuildContext context) => const RetrievePassScreen(),
  "/RegistrationScreen": (BuildContext context) => const RegistrationScreen(),
  "/LoginScreen": (BuildContext context) => const LoginScreen(),
  "/HomeScreen": (BuildContext context) => const HomeScreen(),
  "/NotificationScreen": (BuildContext context) => const NotificationScreen(),
  "/SearchScreen": (BuildContext context) => const SearchScreen(),
  "/ProfileEditScreen": (BuildContext context) => const ProfileEditScreen(),
  "/AboutScreen": (BuildContext context) => const AboutScreen(),
  "/MenuScreen": (BuildContext context) => const MenuScreen(),
  "/ItemScreen": (BuildContext context) => const ItemScreen(),
  "/StartScreen": (BuildContext context) => const StartScreen(),
};
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            primaryColor: Colors.deepPurple,
            primarySwatch: Colors.blue,
            primaryColorDark: Colors.deepPurple),
        home: const SplashScreen(),
        routes: routes);
  }
}
