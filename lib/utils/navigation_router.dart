import 'package:flutter/material.dart';

class NavigationRouter {
  static void switchToLogin(BuildContext context) {
    Navigator.pushNamed(context, "/LoginScreen");
  }

  static void switchToRegistration(BuildContext context) {
    Navigator.pushNamed(context, "/RegistrationScreen");
  }

  static void switchToHome(BuildContext context) {
    Navigator.pushNamed(context, "/HomeScreen");
  }

  static void switchToStart(BuildContext context) {
    Navigator.pushNamed(context, "/StartScreen");
  }
}
