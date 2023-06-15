import 'package:flutter/material.dart';

class NavigationRouter {
  static void back(BuildContext context) {
    Navigator.pop(context);
  }

  static void switchToLogin(BuildContext context) {
    Navigator.pushNamed(context, "/LoginScreen");
  }

  static void switchToRegistration(BuildContext context) {
    Navigator.pushNamed(context, "/RegistrationScreen");
  }

  static void switchToOTP(BuildContext context) {
    Navigator.pushNamed(context, "/OTPScreen");
  }

  static void switchToResetPass(BuildContext context) {
    Navigator.pushNamed(context, "/ResetPassScreen");
  }

  static void switchToRetrievePass(BuildContext context) {
    Navigator.pushNamed(context, "/RetrievePassScreen");
  }

  static void switchToHome(BuildContext context) {
    Navigator.pushNamed(context, "/HomeScreen");
  }

  static void switchToNotification(BuildContext context) {
    Navigator.pushNamed(context, "/NotificationScreen");
  }

  static void switchToSearch(BuildContext context) {
    Navigator.pushNamed(context, "/SearchScreen");
  }

  static void switchToProfileEdit(BuildContext context) {
    Navigator.pushNamed(context, "/ProfileEditScreen");
  }

  static void switchToAbout(BuildContext context) {
    Navigator.pushNamed(context, "/AboutScreen");
  }

  static void switchToStart(BuildContext context) {
    Navigator.pushNamed(context, "/StartScreen");
  }
}
